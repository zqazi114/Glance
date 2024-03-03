//
//  UserFeature.swift
//  Glance
//
//  Created by Z Q on 2/16/24.
//

import ComposableArchitecture

@Reducer
struct UserFeature {
    
    @ObservableState
    struct State: Equatable {
        
        var isBusy: Bool = false
        var error: AppError?
        
        var user: User?
    }
    
    enum Action: Equatable {
        
        case loadUser(String? = nil)
        case didLoad(Result<User,AppError>)
        
        case backTapped
        
        case clearError
    }
    
    @Dependency(\.firebase) var firebase
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            
            switch action {
                
            case .loadUser(let uid):
                state.isBusy = true
                
                return .run { send in
                    let result = await firebase.loadUser(uid: uid)
                    
                    await send(.didLoad(result))
                }
                
                
            case .didLoad(let result):
                
                switch result {
                    
                case .success(let user):
                    state.user = user
                    
                case .failure(let error):
                    state.error = error
                }
                
                state.isBusy = false
                
                
            case .backTapped:
                return .run { _ in
                    await dismiss()
                }
                
                
            case .clearError:
                state.error = nil
            }
            
            return .none
        }
    }
}
