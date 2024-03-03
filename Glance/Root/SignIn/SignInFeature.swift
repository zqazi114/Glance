//
//  SignInFeature.swift
//  Glance
//
//  Created by Z Q on 2/19/24.
//

import ComposableArchitecture
    
@Reducer
struct SignInFeature {
    
    @Reducer
    struct Path {
        
        @ObservableState
        enum State: Equatable {
            case login(LogInFeature.State)
            case register(RegisterFeature.State)
            case survey(SurveyFeature.State)
        }
        
        enum Action: Equatable {
            case login(LogInFeature.Action)
            case register(RegisterFeature.Action)
            case survey(SurveyFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            
            Scope(state: \.login, action: \.login) {
                LogInFeature()
            }
            
            Scope(state: \.register, action: \.register) {
                RegisterFeature()
            }
            
            Scope(state: \.survey, action: \.survey) {
                SurveyFeature()
            }
        }
    }
    
    @ObservableState
    struct State: BaseState {
        
        var isBusy: Bool = false
        var error: AppError? = nil
        
        var path = StackState<Path.State>()
    }
    
    enum Action: Equatable {
        
        case onAppear
        case clearError
        
        case path(StackAction<Path.State, Path.Action>)
    }
    
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            
            switch action {
                
            // --------------------------------- //
            case .onAppear:
                break
                
                
            // --------------------------------- //
            case .clearError:
                state.error = nil
                
                
            // --------------------------------- //
            case let .path(.element(id: id, action: .register(.delegate(.didRegister)))):
                state.path.append(SignInFeature.Path.State.survey(SurveyFeature.State()))
                
                
            // --------------------------------- //
            case .path:
                break
                
            }
            
            return .none
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}
