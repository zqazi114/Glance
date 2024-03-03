//
//  SurveyFeatureTest.swift
//  GlanceTests
//
//  Created by Z Q on 3/2/24.
//

import XCTest
import ComposableArchitecture

final class SurveyFeatureTest: XCTestCase {
    
    let store = TestStore(initialState: SurveyFeature.State()) {
        SurveyFeature()
    }
    
    let timeout = Duration(secondsComponent: 2, attosecondsComponent: 0)
    
    func test_survey_failure_invalidName() async {
        
        await store.send(.binding(.set(\.name, "Xi2 Pi"))) {
            $0.name = "Xi2 Pi"
        }
        
        await store.send(.save) {
            $0.isBusy = true
        }
        
        await store.receive(.didTrySave(.failure(.user_couldNotSave(error: "Name is invalid")))) {
            $0.isBusy = false
            $0.error = .user_couldNotSave(error: "Name is invalid")
        }
        
        await store.send(.clearError) {
            $0.error = nil
        }
        
        await store.send(.binding(.set(\.name, "Xi Pi!"))) {
            $0.name = "Xi Pi!"
        }
        
        await store.send(.save) {
            $0.isBusy = true
        }
        
        await store.receive(.didTrySave(.failure(.user_couldNotSave(error: "Name is invalid")))) {
            $0.isBusy = false
            $0.error = .user_couldNotSave(error: "Name is invalid")
        }
        
        await store.send(.clearError) {
            $0.error = nil
        }
        
        await store.finish(timeout: timeout)
    }
    
    func test_survey_failure_invalidDOB() async {
        
        await store.send(.binding(.set(\.name, "Xi"))) {
            $0.name = "Xi"
        }
        
        var comps = Calendar.current.dateComponents(in: .current, from: Date())
        comps.second = 0
        comps.nanosecond = 0
        
        let dob = Calendar.current.date(from: comps)
        
        await store.send(.binding(.set(\.dob, dob!))) {
            $0.dob = dob!
        }
        
        await store.send(.save) {
            $0.isBusy = true
        }
        
        await store.receive(.didTrySave(.failure(.user_couldNotSave(error: "DOB is invalid")))) {
            $0.isBusy = false
            $0.error = .user_couldNotSave(error: "DOB is invalid")
        }
        
        await store.send(.clearError) {
            $0.error = nil
        }
        
        await store.finish(timeout: timeout)
    }
    
    func test_survey_failure_invalidPicture() async {
        
        await store.send(.binding(.set(\.name, "Xi"))) {
            $0.name = "Xi"
        }
        
        var comps = Calendar.current.dateComponents(in: .current, from: Date(timeIntervalSince1970: 0))
        comps.second = 0
        comps.nanosecond = 0
        
        let dob = Calendar.current.date(from: comps)
        
        await store.send(.binding(.set(\.dob, dob!))) {
            $0.dob = dob!
        }
        
        await store.send(.binding(.set(\.picture, "")))
        
        await store.send(.save) {
            $0.isBusy = true
        }
        
        await store.receive(.didTrySave(.failure(.user_couldNotSave(error: "Picture is invalid")))) {
            $0.isBusy = false
            $0.error = .user_couldNotSave(error: "Picture is invalid")
        }
        
        await store.send(.clearError) {
            $0.error = nil
        }
        
        await store.finish(timeout: timeout)
    }
    
    func test_survey_success() async {
        
        await store.send(.binding(.set(\.name, "Xi"))) {
            $0.name = "Xi"
        }
        
        var comps = Calendar.current.dateComponents(in: .current, from: Date(timeIntervalSince1970: 0))
        comps.second = 0
        comps.nanosecond = 0
        
        let dob = Calendar.current.date(from: comps)
        
        await store.send(.binding(.set(\.dob, dob!))) {
            $0.dob = dob!
        }
        
        await store.send(.binding(.set(\.picture, "www.anyurlisfine.com"))) {
            $0.picture = "www.anyurlisfine.com"
        }
        
        await store.send(.save) {
            $0.isBusy = true
        }
        
        await store.receive(.didTrySave(.success(true))) 
        
        await store.receive(.saved) {
            $0.isBusy = false
        }
        
        await store.receive(.delegate(.didSave))
        
        await store.finish(timeout: timeout)
    }
}
