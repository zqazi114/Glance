//
//  PickVibeFeature.swift
//  Glance
//
//  Created by Z Q on 2/27/24.
//

import ComposableArchitecture

@Reducer
struct PickVibeFeature {
    
    @ObservableState
    struct State: BaseState {
        
        var isBusy: Bool = false
        var error: AppError? = nil
        
        var vibe: Vibe? = nil
    }
    
    enum Action: Equatable {
        case onAppear
        case clearError
        
        case select(Vibe)
        
        enum Delegate: Equatable {
            case didSelect(Vibe)
        }
        
        case delegate(Delegate)
    }
    
    @Dependency(\.dismiss) var dismiss
    
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
            case .select(let vibe):
                
                if state.vibe == vibe {
                    state.vibe = nil
                    
                } else {
                    state.vibe = vibe
                }
                
                
            // --------------------------------- //
            case .delegate:
                break
            }
            
            return .none
        }
    }
}
