//
//  ProfileListFeatureTest.swift
//  GlanceTests
//
//  Created by Z Q on 3/2/24.
//

import XCTest
import ComposableArchitecture

final class ProfileListFeatureTest: XCTestCase {
    
    let store = TestStore(initialState: ProfileListFeature.State()) {
        ProfileListFeature()
    }
    
    let timeout = Duration(secondsComponent: 2, attosecondsComponent: 0)
    
    override func setUpWithError() throws {
        store.exhaustivity = .off(showSkippedAssertions: false)
    }
    
    func test_profileList_success_loadNearbyUsers() async {
        
        await store.send(.loadNearbyUsers([]))
    }
}
