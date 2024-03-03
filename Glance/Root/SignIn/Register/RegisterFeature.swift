//
//  RegisterFeature.swift
//  Glance
//
//  Created by Z Q on 2/19/24.
//

import ComposableArchitecture

@Reducer
struct RegisterFeature {
    
    @ObservableState
    struct State: BaseState {
        
        var isBusy: Bool = false
        var error: AppError? = nil
    
        var email: String = ""
        var password: String = ""
        var passwordConfirmation: String = ""
    }
    
    enum Action: Equatable, BindableAction {
        
        case onAppear
        case clearError
        
        case binding(BindingAction<State>)
        
        case register
        case didTryRegistering(Result<String,AppError>)
        case registered
        
        enum Delegate {
            case didRegister
        }
        
        case delegate(Delegate)
    }
    
    @Dependency(\.firebase) var firebase
    
    var body: some ReducerOf<Self> {
        
        BindingReducer()
        
        Reduce { state, action in
            
            switch action {
                
            // --------------------------------- //
            case .onAppear:
                break
            
            
            // --------------------------------- //
            case .clearError:
                state.error = nil
                
                
            // --------------------------------- //
            case .register:
                
                state.isBusy = true
                
                return .run { [ email = state.email, password = state.password ] send in
                    
                    let result = await firebase.createUser(email: email, password: password)
                    
                    await send(.didTryRegistering(result))
                }
                
            // --------------------------------- //
            case .didTryRegistering(let result):
                
                switch result {
                    
                case .success(let uid):
                    return .run { await $0(.registered) }
                    
                case .failure(let error):
                    state.isBusy = false
                    state.error = error
                }
                
                
            // --------------------------------- //
            case .registered:
                state.isBusy = false
                
                return .run { send in
                    await send(.delegate(.didRegister))
                }
                
                
            // --------------------------------- //
            case .binding:
                break
                
                
            // --------------------------------- //
            case .delegate:
                break
                
            }
            
            return .none
        }
    }
}
