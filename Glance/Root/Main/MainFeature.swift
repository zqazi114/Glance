//
//  MainFeature.swift
//  Glance
//
//  Created by Z Q on 2/18/24.
//

import ComposableArchitecture

@Reducer
struct MainFeature {
    
    @ObservableState
    struct State: Equatable {
        
        var isBusy: Bool = false
        var error: AppError? = nil
        
        var isEditingStatus: Bool = true
        
        var status = StatusFeature.State()
        var matches = MatchesFeature.State()
    }
    
    enum Action: Equatable {
        
        case onAppear
        case clearError
        
        case toggleEditingStatus(Bool)
        
        case status(StatusFeature.Action)
        case matches(MatchesFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.status, action: \.status) {
            StatusFeature()
        }
        
        Scope(state: \.matches, action: \.matches) {
            MatchesFeature()
        }
        
        Reduce { state, action in
            
            switch action {
                
            // --------------------------------- //
            case .onAppear:
                break
                
                
            // --------------------------------- //
            case .clearError:
                state.error = nil
                
                
            // --------------------------------- //
            case .toggleEditingStatus(let value):
                state.isEditingStatus = value
                
                
            // --------------------------------- //
            case .status(.delegate(.didSetStatus)):
                return .send(.toggleEditingStatus(false))
                
                
            // --------------------------------- //
            case .status:
                break
                
                
            // --------------------------------- //
            case .matches:
                break
                
            }
            
            return .none
        }
    }
}
