//
//  MatchesFeature.swift
//  Glance
//
//  Created by Z Q on 2/28/24.
//

import ComposableArchitecture

@Reducer
struct MatchesFeature {
    
    @ObservableState
    struct State: BaseState {
        
        var isBusy: Bool = false
        var error: AppError? = nil
        
        var isFirstTimeAppearing: Bool = true
        var isShowingView: Bool = false
        var isShowingProfiles: Bool = false
        
        var quote = QuoteFeature.State()
        var profileList = ProfileListFeature.State()
    }
    
    enum Action: Equatable {
        
        case onAppear
        case clearError
        
        case toggleShowingView(Bool)
        case toggleShowingProfiles(Bool)
        
        case subscribeToNearbyUsers
        case loadNearbyUsers([String])
        
        case quote(QuoteFeature.Action)
        case profileList(ProfileListFeature.Action)
    }
    
    @Dependency(\.notificationHelper) var notificationHelper
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.quote, action: \.quote) {
            QuoteFeature()
        }
        
        Scope(state: \.profileList, action: \.profileList) {
            ProfileListFeature()
        }
        
        Reduce { state, action in
            
            switch action {
                
            // --------------------------------- //
            case .onAppear:
                state.isFirstTimeAppearing = false
                return .send(.subscribeToNearbyUsers)
                
                
            // --------------------------------- //
            case .clearError:
                state.error = nil
                
                
            // --------------------------------- //
            case .toggleShowingView(let value):
                state.isShowingView = value
                
                
            // --------------------------------- //
            case .toggleShowingProfiles(let value):
                state.isShowingProfiles = value
                
                
            // --------------------------------- //
            case .subscribeToNearbyUsers:
                
                return .publisher {
                    notificationHelper
                        .newUsersSubject
                        .map { .loadNearbyUsers($0) }
                }
                
                
            // --------------------------------- //
            case .loadNearbyUsers(let users):
                state.isShowingProfiles = true
                
                return .send(.profileList(.loadNearbyUsers(users)))
                
                
            // --------------------------------- //
            case .quote:
                break
                
                
            // --------------------------------- //
            case .profileList(.delegate(.allProfilesExpired)):
                return .send(.toggleShowingProfiles(false))
                
                
            // --------------------------------- //
            case .profileList:
                break
                
            }
            
            return .none
        }
    }
}
