//
//  TabBarFeature.swift
//  Glance
//
//  Created by Z Q on 2/18/24.
//

import ComposableArchitecture

@Reducer
struct TabBarFeature {
    
    @ObservableState
    struct State: Equatable {
        
        var isBusy: Bool = false
        var error: AppError? = nil
        
        var user = UserFeature.State()
        var userList = UserListFeature.State()
        var settings = SettingsFeature.State()
    }
    
    enum Action: Equatable {
        
        case onAppear
        
        case user(UserFeature.Action)
        case userList(UserListFeature.Action)
        case settings(SettingsFeature.Action)
        
        case clearError
    }
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.user, action: \.user) {
            UserFeature()
        }
        
        Scope(state: \.userList, action: \.userList) {
            UserListFeature()
        }
        
        Scope(state: \.settings, action: \.settings) {
            SettingsFeature()
        }
        
        Reduce { state, action in
            
            return .none
        }
    }
}
