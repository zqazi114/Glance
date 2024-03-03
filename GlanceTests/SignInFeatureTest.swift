//
//  SignInFeatureTest.swift
//  GlanceTests
//
//  Created by Z Q on 3/2/24.
//

import XCTest
import ComposableArchitecture

final class SignInFeatureTest: XCTestCase {
    
    let store = TestStore(initialState: SignInFeature.State()) {
        SignInFeature()
    }
    
    let timeout = Duration(secondsComponent: 2, attosecondsComponent: 0)
    
    override func setUpWithError() throws {
        store.exhaustivity = .off(showSkippedAssertions: false)
    }

    override func tearDownWithError() throws {
        
    }
    
    func test_signIn_success_login() async {
        
        await store.send(.path(.push(id: 0, state: .login(LogInFeature.State(email: "test@user.com", password: "Testuser123")))))
        await store.send(.path(.element(id: 0, action: .login(.login))))
        
        await store.receive(.path(.element(id: 0, action: .login(.didTryLogin(.success("1"))))))
        await store.receive(.path(.element(id: 0, action: .login(.loggedIn))))
        await store.receive(.path(.element(id: 0, action: .login(.delegate(.didLogIn)))))
        
        await store.finish(timeout: timeout)
    }
    
    func test_signIn_success_register() async {
        
        await store.send(.path(.push(id: 0, state: .register(RegisterFeature.State(email: "test2@user.com", password: "Testuser123")))))
        await store.send(.path(.element(id: 0, action: .register(.register))))
        
        await store.receive(.path(.element(id: 0, action: .register(.didTryRegistering(.success("1"))))))
        await store.receive(.path(.element(id: 0, action: .register(.registered))))
        await store.receive(.path(.element(id: 0, action: .register(.delegate(.didRegister)))))
        
        await store.finish(timeout: timeout)
    }
}
