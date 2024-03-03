//
//  FirebaseService.swift
//  Glance
//
//  Created by Z Q on 2/16/24.
//

import SwiftUI
import ComposableArchitecture
import Firebase

// MARK: - FirebaseServiceProtocol
protocol FirebaseServiceProtocol {
    
    static var liveValue: FirebaseService { get set }
    static var testValue: FirebaseService { get set }
    
    static func configure()
    
    func isSignedIn() -> Bool
    
    func createUser(email: String, password: String) async -> Result<String, AppError>
    func loginUser(email: String, password: String) async -> Result<String, AppError>
    func logOut()
    
    func loadUser(uid: String?) async -> Result<User, AppError>
    func loadUsers(uids: [String]) async -> Result<[User], AppError>
    func loadUsers() async -> Result<[User], AppError>
    func saveUser(user: User) async -> Result<Bool, AppError>
}


// MARK: - FirebaseService
class FirebaseService: FirebaseServiceProtocol {
    
    static func configure() {
        FirebaseApp.configure()
    }
    
    func isSignedIn() -> Bool {
        return false
    }
    
    func createUser(email: String, password: String) async -> Result<String, AppError> {
        return .failure(.unimplemented)
    }
    
    func loginUser(email: String, password: String) async -> Result<String, AppError> {
        return .failure(.unimplemented)
    }
    
    func logOut() {
        
    }
    
    func loadUser(uid: String? = nil) async -> Result<User, AppError> {
        return .failure(.unimplemented)
    }
    
    func loadUsers(uids: [String]) async -> Result<[User], AppError> {
        return .failure(.unimplemented)
    }
    
    func loadUsers() async -> Result<[User], AppError> {
        return .failure(.unimplemented)
    }
    
    func saveUser(user: User) async -> Result<Bool, AppError> {
        return .failure(.unimplemented)
    }
}


// MARK: - extension FirebaseService
extension FirebaseService: DependencyKey {
    
    static var liveValue: FirebaseService = LiveFirebaseService.shared
    static var testValue: FirebaseService = TestFirebaseService.shared
}


// MARK: - extension DependencyValues
extension DependencyValues {
    
    var firebase: FirebaseService {
        get { self[FirebaseService.self] }
        set { self[FirebaseService.self] = newValue }
    }
}
