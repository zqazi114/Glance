//
//  ProfileFeature.swift
//  Glance
//
//  Created by Z Q on 2/27/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ProfileFeature {
    
    @ObservableState
    struct State: BaseState {
        
        var isBusy: Bool = false
        var error: AppError? = nil
        
        var user: User
        var status: Status
        
        var expiration: CGFloat = 20
        let Duration: CGFloat = 20
        
        var isOpen: Bool = false
        var isShowingButtons: Bool = false
        var isShowingStatus: Bool = false
    }
    
    enum Action: Equatable {
        
        case onAppear
        case clearError
        
        case startTimer
        case tick
        case stopTimer
        
        case toggleOpen
        case toggleButtons
        case toggleStatus
        
        enum Delegate: Equatable {
            case disliked(User)
            case liked(User)
        }
        
        case delegate(Delegate)
    }
    
    enum CancelID {
        case timer
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.continuousClock) var clock
    
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
            case .startTimer:
                state.expiration = state.Duration
                
                return .run { send in
                    while true {
                        try await clock.sleep(for: .seconds(1))
                        await send(.tick)
                    }
                }
                .cancellable(id: CancelID.timer)
                
                
            // --------------------------------- //
            case .stopTimer:
                return .cancel(id: CancelID.timer)
                
                
            // --------------------------------- //
            case .tick:
                state.expiration = state.expiration - 1
                
                
            // --------------------------------- //
            case .toggleOpen:
                state.isOpen.toggle()
                
                
            // --------------------------------- //
            case .toggleButtons:
                state.isShowingButtons.toggle()
                
                
            // --------------------------------- //
            case .toggleStatus:
                state.isShowingStatus.toggle()
                
                
            // --------------------------------- //
            case .delegate:
                break
            }
        
            return .none
        }
    }
}
