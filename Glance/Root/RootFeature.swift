//
//  RootFeature.swift
//  Glance
//
//  Created by Z Q on 2/18/24.
//

import ComposableArchitecture

protocol BaseState: Equatable {
    
    var isBusy: Bool { get set }
    var error: AppError? { get set }
}

@Reducer
struct RootFeature {
    
    @ObservableState
    struct State: Equatable {
        
        var isBusy: Bool = false
        var error: AppError? = nil
        
        var signIn: SignInFeature.State?
        var main: MainFeature.State?
    }
    
    enum Action: Equatable {
        
        case onAppear
        
        case showSignIn
        case showMain
        
        case signIn(SignInFeature.Action)
        case main(MainFeature.Action)
        
        case clearError
    }
    
    @Dependency(\.firebase) var firebase
    
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            
            switch action {
                
            // --------------------------------- //
            case .onAppear:
                
                return .run { send in
                    
                    try? await Task.sleep(nanoseconds: 4_000_000_000)
                    
                    await send(firebase.isSignedIn() ? .showMain : .showSignIn)
                }
                
                
            // --------------------------------- //
            case .clearError:
                state.error = nil
                
                
            // --------------------------------- //
            case .showSignIn:
                state.main = nil
                state.signIn = SignInFeature.State()
                
                
            // --------------------------------- //
            case .showMain:
                state.signIn = nil
                state.main = MainFeature.State()
                
                
            // --------------------------------- //
            case let .signIn(.path(.element(id: id, action: .login(.delegate(.didLogIn))))):
                return .run { send in
                    await send(.showMain)
                }
                
                
            // --------------------------------- //
            case let .signIn(.path(.element(id: id, action: .survey(.delegate(.didSave))))):
                
                return .run { send in
                    await send(.showMain)
                }
                
                
            // --------------------------------- //
            case .signIn:
                 break
                 
                
             // --------------------------------- //
             case .main:
                break
                
                
            // --------------------------------- //
                /*
            case .main(.settings(.delegate(.didLogOut))):
                
                return .run { send in
                    await send(.showSignIn)
                }*/
            }
            
            return .none
        }
        
        .ifLet(\.signIn, action: \.signIn) {
            SignInFeature()
        }
        
        .ifLet(\.main, action: \.main) {
            MainFeature()
        }
    }
}
