//
//  SettingsFeature.swift
//  Glance
//
//  Created by Z Q on 2/19/24.
//

import ComposableArchitecture


@Reducer
struct SettingsFeature {
    
    @ObservableState
    struct State: BaseState {
        
        var isBusy: Bool = false
        var error: AppError? = nil
        
        
    }
    
    enum Action: Equatable {
        case onAppear
        
        case logOut
        case loggedOut
        
        case clearError
        
        
        enum Delegate{
            case didLogOut
        }
        
        case delegate(Delegate)
    }
    
    @Dependency(\.firebase) var firebase
    
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            
            switch action {
                
            // --------------------------------- //
            case .onAppear:
                break
                
                
            // --------------------------------- //
            case .logOut:
                state.isBusy = true
                
                return .run { send in
                    firebase.logOut()
                    
                    await send(.loggedOut)
                }
                
                
            // --------------------------------- //
            case .loggedOut:
                state.isBusy = false
                
                return .run { send in
                    await send(.delegate(.didLogOut))
                }
                
                    
            // --------------------------------- //
            case .delegate:
                break
                
                
            // --------------------------------- //
            case .clearError:
                state.error = nil
            }
            
            return .none
        }
    }
}
