//
//  LogInFeatureTest.swift
//  GlanceTests
//
//  Created by Z Q on 3/2/24.
//

import XCTest
import ComposableArchitecture

@MainActor
final class LogInFeatureTest: XCTestCase {
    
    let store = TestStore(initialState: LogInFeature.State()) {
        LogInFeature()
    }
    
    func test_login_failure_invalidEmail() async {
        
        await store.send(.login) {
            $0.isBusy = true
        }
        
        await store.receive(.didTryLogin(.failure(.auth_couldNotLogin(error: "Email address is invalid")))) {
            $0.isBusy = false
            $0.error = .auth_couldNotLogin(error: "Email address is invalid")
        }
        
        await store.send(.clearError) {
            $0.error = nil
        }
        
        await store.finish(timeout: .seconds(2))
    }
    
    func test_login_failure_invalidPassword() async {
        
        await store.send(.binding(.set(\.email, "test@user.com"))) {
            $0.email = "test@user.com"
        }
        
        await store.send(.login) {
            $0.isBusy = true
        }
        
        await store.receive(.didTryLogin(.failure(.auth_couldNotLogin(error: "Password is invalid")))) {
            $0.isBusy = false
            $0.error = .auth_couldNotLogin(error: "Password is invalid")
        }
        
        await store.send(.clearError) {
            $0.error = nil
        }
        
        await store.finish(timeout: .seconds(2))
    }
    
    func test_login_success() async {
        
        await store.send(.binding(.set(\.email, "test@user.com"))) {
            $0.email = "test@user.com"
        }
        
        await store.send(.binding(.set(\.password, "Testuser123"))) {
            $0.password = "Testuser123"
        }
        
        await store.send(.login) {
            $0.isBusy = true
        }
        
        await store.receive(.didTryLogin(.success("1")))
        
        await store.receive(.loggedIn) {
            $0.isBusy = false
        }
        
        await store.receive(.delegate(.didLogIn))
        
        await store.finish(timeout: .seconds(2))
    }
}
