//
//  LiveFirebaseService.swift
//  Glance
//
//  Created by Z Q on 2/17/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFunctions

// MARK: - LiveFirebaseService
class LiveFirebaseService: FirebaseService {
    
    static var shared: LiveFirebaseService = {
        return LiveFirebaseService()
    }()
    
    
    var handle: AuthStateDidChangeListenerHandle? = nil
    
    
    // MARK: - isSignedIn
    override func isSignedIn() -> Bool {
        Auth.auth().currentUser?.uid != nil
    }
    
    
    // MARK: - createUser
    override func createUser(email: String, password: String) async -> Result<String, AppError> {
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            return .success(result.user.uid)
            
        } catch {
            return .failure(.auth_couldNotRegister(error: error.localizedDescription))
        }
    }
    
    
    // MARK: - loginUser
    override func loginUser(email: String, password: String) async -> Result<String, AppError> {
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            
            return .success(result.user.uid)
            
        } catch {
            return .failure(.auth_couldNotRegister(error: error.localizedDescription))
        }
    }
    
    
    // MARK: - logOut
    override func logOut() {
        try? Auth.auth().signOut()
    }
    
    
    // MARK: - loadUser
    override func loadUser(uid: String? = nil) async -> Result<User, AppError> {
        
        do {
            
            guard let UID = Auth.auth().currentUser?.uid else {
                return .failure(.auth_notLoggedIn(error: "You are not logged in. Please sign into your account"))
            }
            
            let ref = Firestore.firestore().collection("users").document(uid ?? UID)
            
            let user = try await ref.getDocument(as: User.self)
            
            return .success(user)
            
        } catch {
            
            return .failure(.user_couldNotLoad(error: error.localizedDescription))
        }
    }
    

    // MARK: - loadUsers
    override func loadUsers(uids: [String]) async -> Result<[User], AppError> {
        
        
        do {
            
            if uids.isEmpty {
                return await loadUsers()
            }
            
            let ref = Firestore.firestore().collection("users")
            let query = ref.whereField(FieldPath.documentID(), in: uids)
            
            let snapshot = try await query.getDocuments()
            
            let users = try snapshot.documents.map { snap in
                try snap.data(as: User.self)
            }
            
            return .success(users)
            
        } catch {
            return .failure(.user_couldNotLoad(error: error.localizedDescription))
        }
    }
    
        
    // MARK: - loadUsers
    override func loadUsers() async -> Result<[User], AppError> {
        
        do {
            
            let ref = Firestore.firestore().collection("users")
            
            let snapshot = try await ref.getDocuments()
            
            let users = try snapshot.documents.map { snap in
                try snap.data(as: User.self)
            }
            
            return .success(users)
            
        } catch {
            return .failure(.user_couldNotLoad(error: error.localizedDescription))
        }
    }
    
    
    // MARK: - saveUser
    override func saveUser(user: User) async -> Result<Bool, AppError> {
        
        await withCheckedContinuation { continuation in
            
            do {
                
                guard let uid = Auth.auth().currentUser?.uid else {
                    
                    continuation.resume(returning: .failure(.auth_notLoggedIn(error: "You are not logged in. Please sign into your account")))
                    
                    return
                }
                
                let ref = Firestore.firestore().collection("users").document(uid)
                
                try ref.setData(from: user, merge: true) { error in
                    
                    if let error = error {
                        
                        continuation.resume(returning: .failure(.user_couldNotSave(error: error.localizedDescription)))
                        
                    } else {
                        
                        continuation.resume(returning: .success(true))
                    }
                }
                
            } catch {
                continuation.resume(returning: .failure(.user_couldNotSave(error: error.localizedDescription)))
            }
        }
    }
    
    
    // MARK: - saveAndReturnUser
    func saveAndReturnUser(user: User) async -> Result<User, AppError> {
        
        await withCheckedContinuation { continuation in
            
            do {
                
                let ref = Firestore.firestore().collection("users")
                
                var docRef: DocumentReference
                
                if let uid = user.id {
                    
                    docRef = ref.document(uid)
                    
                } else {
                    
                    docRef = ref.document()
                }
                
                try docRef.setData(from: user, merge: true) { error in
                    
                    if let error = error {
                        continuation.resume(returning: .failure(.user_couldNotSave(error: error.localizedDescription)))
                        
                    } else {
                        
                        var copy = user
                        copy.id = docRef.documentID
                        
                        continuation.resume(returning: .success(copy))
                    }
                }
                
            } catch {
                continuation.resume(returning: .failure(.user_couldNotSave(error: error.localizedDescription)))
            }
        }
    }
    
    // MARK: - saveUsers
    func saveUsers(users: [User]) async -> Result<[User], AppError> {
        
        var ret: [User] = []
        
        for user in users {
            
            let result = await saveAndReturnUser(user: user)
            
            switch result {
                
            case .success(let u):
                ret.append(u)
                
            case .failure(let error):
                return .failure(error)
            }
        }
        
        return .success(ret)
    }
}
