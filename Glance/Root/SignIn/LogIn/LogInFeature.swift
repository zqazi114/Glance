//
//  LogInFeature.swift
//  Glance
//
//  Created by Z Q on 2/19/24.
//

import ComposableArchitecture

@Reducer
struct LogInFeature {
    
    @ObservableState
    struct State: BaseState {
        
        var isBusy: Bool = false
        var error: AppError? = nil
        
        var email: String = ""
        var password: String = ""
    }
    
    enum Action: Equatable, BindableAction {
        
        case binding(BindingAction<State>)
        
        case login
        case didTryLogin(Result<String,AppError>)
        case loggedIn
        
        case clearError
        
        
        enum Delegate {
            case didLogIn
        }
        
        case delegate(Delegate)
    }
    
    @Dependency(\.firebase) var firebase
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        
        BindingReducer()
        
        Reduce { state, action in
            
            switch action {
                
            // --------------------------------- //
            case .login:
                
                state.isBusy = true
                
                return .run { [ email = state.email, password = state.password ] send in
                    
                    let result = await firebase.loginUser(email: email, password: password)
                    
                    await send(.didTryLogin(result))
                }
                
                
            // --------------------------------- //
            case .didTryLogin(let result):
                
                switch result {
                    
                case .success(let uid):
                    app_print("Logged in user with uid: \(uid)")
                    
                    return .run { await $0(.loggedIn) }
                    
                case .failure(let error):
                    state.error = error
                    state.isBusy = false
                }
                
                
            // --------------------------------- //
            case .loggedIn:
                state.isBusy = false
                
                return .run { send in
                    await send(.delegate(.didLogIn))
                }
                
                
            // --------------------------------- //
            case .clearError:
                state.error = nil
                
                
            // --------------------------------- //
            case .delegate:
                break
                
                
            // --------------------------------- //
            case .binding:
                break
            }
            
            return .none
        }
    }
}
