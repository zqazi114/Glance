//
//  GlanceApp.swift
//  Glance
//
//  Created by Z Q on 2/16/24.
//

import SwiftUI
import ComposableArchitecture
import XCTestDynamicOverlay

@main
struct GlanceApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let rootStore = Store(initialState: RootFeature.State()) {
        RootFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        
        WindowGroup {
            
            if !_XCTIsTesting {
                RootView(store: rootStore)
                //MainView(store: Store(initialState: MainFeature.State(), reducer: { MainFeature() }))
                //GooglePlacesService_Wrapper()
                //SurveyView(store: Store(initialState: SurveyFeature.State(), reducer: { SurveyFeature() }))
                //UserView(store: rootStore)
                //FirebaseService_Wrapper()
                //UserList(store: rootStore.scope(state: \.userList, action: \.userList))
                //SignInView(store: Store(initialState: SignInFeature.State(), reducer: { SignInFeature() }))
                //PickLocationView(store: Store(initialState: PickLocationFeature.State(), reducer: { PickLocationFeature() }))
                //PickView<Activity>(store: Store(initialState: PickFeature.State(), reducer: { PickFeature() }))
                //StatusView(store: Store(initialState: StatusFeature.State(), reducer: { StatusFeature() }))
                //ProfileListView(store: Store(initialState: ProfileListFeature.State(users: IdentifiedArray(uniqueElements: User.TEST, id: \.id)), reducer: { ProfileListFeature() }))
                //MatchesView(store: Store(initialState: MatchesFeature.State(), reducer: { MatchesFeature() }, withDependencies: { $0.firebase = FirebaseService.test }))
                //QuoteView(store: Store(initialState: QuoteFeature.State(), reducer: { QuoteFeature() }))
            }
        }
    }
}
