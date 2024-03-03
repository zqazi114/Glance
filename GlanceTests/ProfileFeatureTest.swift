//
//  ProfileFeatureTest.swift
//  GlanceTests
//
//  Created by Z Q on 3/2/24.
//

import XCTest
import ComposableArchitecture

final class ProfileFeatureTest: XCTestCase {
    
    let store = TestStore(initialState: ProfileFeature.State(user: User.TEST.first!, status: Status.TEST.first!)) {
        ProfileFeature()
    } withDependencies: {
        $0.continuousClock = ImmediateClock()
    }
    
    let timeout = Duration(secondsComponent: 2, attosecondsComponent: 0)
    
    func test_profile_success_timer() async {
        
        await store.send(.startTimer)
        
        await store.receive(.tick) {
            $0.expiration = 19
        }
        
        await store.receive(.tick) {
            $0.expiration = 18
        }
        
        await store.receive(.tick) {
            $0.expiration = 17
        }
        
        await store.receive(.tick) {
            $0.expiration = 16
        }
        
        await store.receive(.tick) {
            $0.expiration = 15
        }
        
        await store.receive(.tick) {
            $0.expiration = 14
        }
        
        await store.receive(.tick) {
            $0.expiration = 13
        }
        
        await store.receive(.tick) {
            $0.expiration = 12
        }
        
        await store.receive(.tick) {
            $0.expiration = 11
        }
        
        await store.receive(.tick) {
            $0.expiration = 10
        }
        
        await store.receive(.tick) {
            $0.expiration = 9
        }
        
        await store.receive(.tick) {
            $0.expiration = 8
        }
        
        await store.receive(.tick) {
            $0.expiration = 7
        }
        
        await store.receive(.tick) {
            $0.expiration = 6
        }
        
        await store.receive(.tick) {
            $0.expiration = 5
        }
        
        await store.receive(.tick) {
            $0.expiration = 4
        }
        
        await store.receive(.tick) {
            $0.expiration = 3
        }
        
        await store.receive(.tick) {
            $0.expiration = 2
        }
        
        await store.receive(.tick) {
            $0.expiration = 1
        }
        
        await store.receive(.tick) {
            $0.expiration = 0
        }
        
        //await store.send(.stopTimer)
        
        //await store.finish(timeout: timeout)
    }
    
    func test_profile_success_appear() async {
        
        await store.send(.toggleOpen) {
            $0.isOpen = true
        }
        
        await store.send(.toggleButtons) {
            $0.isShowingButtons = true
        }
        
        await store.send(.toggleStatus) {
            $0.isShowingStatus = true
        }
        
        await store.send(.toggleOpen) {
            $0.isOpen = false
        }
        
        await store.send(.toggleButtons) {
            $0.isShowingButtons = false
        }
        
        await store.send(.toggleStatus) {
            $0.isShowingStatus = false
        }
    }
}
