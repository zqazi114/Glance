//
//  ProfileListFeature.swift
//  Glance
//
//  Created by Z Q on 2/28/24.
//


import Foundation
import ComposableArchitecture

@Reducer
struct ProfileListFeature {
    
    @Reducer
    struct Path {
        
        @ObservableState
        enum State: Equatable {
            case profile(ProfileFeature.State)
        }
        
        enum Action: Equatable {
            case profile(ProfileFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            
            Scope(state: \.profile, action: \.profile) {
                ProfileFeature()
            }
        }
    }
    
    @ObservableState
    struct State: BaseState {
        
        var isBusy: Bool = false
        var error: AppError? = nil
    
        var users: IdentifiedArray<String?, User> = []
        
        var path = StackState<Path.State>()
    }
    
    enum Action: Equatable {
        
        case onAppear
        case clearError
        
        case loadNearbyUsers([String])
        case didLoadNearbyUsers(Result<[User], AppError>)
        case userExpired(User)
        
        enum Delegate: Equatable {
            case allProfilesExpired
        }
        
        case delegate(Delegate)
        
        case path(StackAction<Path.State, Path.Action>)
    }
    
    @Dependency(\.firebase) var firebase
    
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
            case .loadNearbyUsers(let uids):
                return .run { send in
                    
                    let result = await firebase.loadUsers(uids: uids)
                    
                    await send(.didLoadNearbyUsers(result))
                }
                
                
            // --------------------------------- //
            case .didLoadNearbyUsers(let result):
                switch result {
                    
                case .success(let users):
                    state.users.append(contentsOf: users)
                    
                case .failure(let error):
                    state.error = error
                }
                
                
            // --------------------------------- //
            case .userExpired(let user):
                state.users.removeAll { $0.id == user.id }
                
                if state.users.isEmpty {
                    return .send(.delegate(.allProfilesExpired))
                }
                
                
            // --------------------------------- //
            case .delegate:
                break
                
                
            // --------------------------------- //
            case let .path(.element(id: id, action: .profile(.delegate(.liked(user))))):
                state.users.removeAll { $0.id == user.id }
                state.path.pop(from: id)
                
                
            // --------------------------------- //
            case let .path(.element(id: id, action: .profile(.delegate(.disliked(user))))):
                state.users.removeAll { $0.id == user.id }
                state.path.pop(from: id)
                
                
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
