//
//  RegisterFeatureTest.swift
//  GlanceTests
//
//  Created by Z Q on 3/2/24.
//

import XCTest
import ComposableArchitecture

final class RegisterFeatureTest: XCTestCase {
    
    let store = TestStore(initialState: RegisterFeature.State()) {
        RegisterFeature()
    }
    
    let timeout = Duration(secondsComponent: 2, attosecondsComponent: 0)
    
    func test_register_failure_accountExists() async {
        
        await store.send(.register) {
            $0.isBusy = true
        }
        
        await store.receive(.didTryRegistering(.failure(.auth_couldNotRegister(error: "Account already exists")))) {
            $0.isBusy = false
            $0.error = .auth_couldNotRegister(error: "Account already exists")
        }
        
        await store.send(.clearError) {
            $0.error = nil
        }
        
        await store.finish(timeout: timeout)
    }
    
    func test_register_failure_invalidEmail() async {
        
        await store.send(.binding(.set(\.email, "test@user.c"))) {
            $0.email = "test@user.c"
        }
        
        await store.send(.register) {
            $0.isBusy = true
        }
        
        await store.receive(.didTryRegistering(.failure(.auth_couldNotRegister(error: "Email address is invalid")))) {
            $0.isBusy = false
            $0.error = .auth_couldNotRegister(error: "Email address is invalid")
        }
        
        await store.send(.clearError) {
            $0.error = nil
        }
        
        await store.finish(timeout: timeout)
    }
    
    func test_register_failure_invalidPassword() async {
        
        await store.send(.binding(.set(\.email, "test2@user.com"))) {
            $0.email = "test2@user.com"
        }
        
        await store.send(.binding(.set(\.password, "Testuser"))) {
            $0.password = "Testuser"
        }
        
        await store.send(.register) {
            $0.isBusy = true
        }
        
        await store.receive(.didTryRegistering(.failure(.auth_couldNotRegister(error: "Password is invalid")))) {
            $0.isBusy = false
            $0.error = .auth_couldNotRegister(error: "Password is invalid")
        }
        
        await store.send(.clearError) {
            $0.error = nil
        }
        
        await store.finish(timeout: timeout)
    }
    
    func test_register_success() async {
        
        await store.send(.binding(.set(\.email, "test2@user.com"))) {
            $0.email = "test2@user.com"
        }
        
        await store.send(.binding(.set(\.password, "Testuser123"))) {
            $0.password = "Testuser123"
        }
        
        await store.send(.register) {
            $0.isBusy = true
        }
        
        await store.receive(.didTryRegistering(.success("1")))
        
        await store.receive(.registered) {
            $0.isBusy = false
        }
        
        await store.receive(.delegate(.didRegister))
        
        await store.finish(timeout: timeout)
    }
}
