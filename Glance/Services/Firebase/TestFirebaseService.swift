//
//  TestFirebaseService.swift
//  Glance
//
//  Created by Z Q on 2/17/24.
//

import Foundation

// MARK: - TestFirebaseService
class TestFirebaseService: FirebaseService {
    
    static var shared: TestFirebaseService = {
        return TestFirebaseService()
    }()
    
    
    // MARK: - createUser
    override func createUser(email: String, password: String) async -> Result<String, AppError> {
        if email == "test@user.com" {
            return .failure(.auth_couldNotRegister(error: "Account already exists"))
        }
        
        if email != "test2@user.com" {
            return .failure(.auth_couldNotRegister(error: "Email address is invalid"))
        }
        
        if password != "Testuser123" {
            return .failure(.auth_couldNotRegister(error: "Password is invalid"))
        }
        
        return .success("1")
    }
    
    
    // MARK: - loginUser
    override func loginUser(email: String, password: String) async -> Result<String, AppError> {
        if email != "test@user.com" {
            return .failure(.auth_couldNotLogin(error: "Email address is invalid"))
        }
        
        if password != "Testuser123" {
            return .failure(.auth_couldNotLogin(error: "Password is invalid"))
        }
        
        return .success("1")
    }
    
    
    // MARK: - isSignedIn
    override func logOut() {
        
    }
    
    
    // MARK: - isSignedIn
    override func isSignedIn() -> Bool {
        return true
    }
    
    
    // MARK: - loadUser
    override func loadUser(uid: String? = nil) async -> Result<User, AppError> {
        
        if let uid = uid, uid.isEmpty {
            return .failure(.user_couldNotLoad(error: "UID is empty"))
            
        } else if uid != "test" {
            return .failure(.user_couldNotLoad(error: "The data couldn’t be read because it is missing."))
        }
        
        guard let user = User.TEST.first else {
            return .failure(.user_couldNotLoad(error: "Dummy users is empty"))
        }
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        return .success(user)
    }
    
    
    // MARK: - loadUsers
    override func loadUsers(uids: [String]) async -> Result<[User], AppError> {
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        return .success([User.TEST.randomElement()!])
    }
    
    
    // MARK: - loadUsers
    override func loadUsers() async -> Result<[User], AppError> {
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        return .success(User.TEST)
    }
    
    
    // MARK: - loadUsers
    override func saveUser(user: User) async -> Result<Bool, AppError> {
        
        if !user.name.isValidName {
            return .failure(.user_couldNotSave(error: "Name is invalid"))
            
        } else if !user.dob.isLegalAge {
            return .failure(.user_couldNotSave(error: "DOB is invalid"))
            
        } else if URL(string: user.profilePictureURL) == nil {
            return .failure(.user_couldNotSave(error: "Picture is invalid"))
        }
        
        return .success(true)
    }
}
