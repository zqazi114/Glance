//
//  StatusFeature.swift
//  Glance
//
//  Created by Z Q on 2/23/24.
//

import ComposableArchitecture


@Reducer
struct StatusFeature {
    
    @Reducer
    struct Path {
        
        @ObservableState
        enum State: Equatable {
            case pickLocation(PickLocationFeature.State)
            case pickActivity(PickFeature<Activity>.State)
            case pickTime(PickTimeFeature.State)
            case pickVibe(PickVibeFeature.State)
        }
        
        enum Action: Equatable {
            case pickLocation(PickLocationFeature.Action)
            case pickActivity(PickFeature<Activity>.Action)
            case pickTime(PickTimeFeature.Action)
            case pickVibe(PickVibeFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            
            Scope(state: \.pickLocation, action: \.pickLocation) {
                PickLocationFeature()
            }
            
            Scope(state: \.pickActivity, action: \.pickActivity) {
                PickFeature<Activity>()
            }
            
            Scope(state: \.pickTime, action: \.pickTime) {
                PickTimeFeature()
            }
            
            Scope(state: \.pickVibe, action: \.pickVibe) {
                PickVibeFeature()
            }
        }
    }
    
    @ObservableState
    struct State: BaseState {
        
        var isBusy: Bool = false
        var error: AppError? = nil
        
        var status: Status = Status()
        
        var isShowingButton: Bool = false
        var isShowingViews: Bool = false
        var isShowingPreview: Bool = false
        
        var path = StackState<Path.State>()
    }
    
    enum Action: Equatable {
        
        case onAppear
        case clearError
        
        case toggleButton(Bool)
        case togglePreview(Bool)
        case toggleViews(Bool)
        
        enum Delegate: Equatable {
            case didSetStatus
        }
        
        case delegate(Delegate)
        
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
            case .toggleButton(let value):
                state.isShowingButton = value
                
                
            // --------------------------------- //
            case .togglePreview(let value):
                state.isShowingPreview = value
                
                
            // --------------------------------- //
            case .toggleViews(let value):
                state.isShowingViews = value
                
                
            // --------------------------------- //
            case .delegate:
                break
                
                
            // --------------------------------- //
            case let .path(.element(id: id, action: .pickLocation(.delegate(.didSelect(location))))):
                state.status.location = location
                state.path.pop(from: id)
                
                
            // --------------------------------- //
            case let .path(.element(id: id, action: .pickActivity((.delegate(.didSelect(activity)))))):
                state.status.activity = activity
                state.path.pop(from: id)
                
                
            // --------------------------------- //
            case let .path(.element(id: id, action: .pickTime((.delegate(.didSelect(time)))))):
                state.status.time = time
                state.path.pop(from: id)
                
                
            // --------------------------------- //
            case let .path(.element(id: id, action: .pickVibe((.delegate(.didSelect(vibe)))))):
                state.status.vibe = vibe
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
