//
//  UserListFeature.swift
//  Glance
//
//  Created by Z Q on 2/17/24.
//

import ComposableArchitecture

@Reducer
struct UserListFeature {
    
    @ObservableState
    struct State: Equatable {
        
        var isBusy: Bool = false
        var error: AppError?
        
        var users: [User] = []
        
        @Presents var viewUser: UserFeature.State?
        
        var path = StackState<UserFeature.State>()
    }
    
    enum Action: Equatable {
        
        case loadUsers
        case didLoad(Result<[User],AppError>)
        
        case userTapped(User)
        
        case viewUser(PresentationAction<UserFeature.Action>)
        
        case path(StackAction<UserFeature.State, UserFeature.Action>)
        
        case clearError
    }
    
    @Dependency(\.firebase) var firebase
    
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            
            switch action {
                
            case .loadUsers:
                state.isBusy = true
                
                return .run { send in
                    let result = await firebase.loadUsers()
                    
                    await send(.didLoad(result))
                }
                
            case .didLoad(let result):
                
                switch result {
                    
                case .success(let users):
                    state.users = users
                    
                case .failure(let error):
                    state.error = error
                }
                
                state.isBusy = false
                
                
            case .userTapped(let user):
                state.viewUser = UserFeature.State(user: user)
                
                
            case .viewUser(.presented(.backTapped)):
                break//state.viewUser = nil
                
                
            case .viewUser:
                break
                
                
            case .path(let action):
                break
                
                
            case .clearError:
                state.error = nil
            }
            
            return .none
        }
        .ifLet(\.$viewUser, action: \.viewUser) {
            UserFeature()
        }
        .forEach(\.path, action: \.path) {
            UserFeature()
        }
    }
}
