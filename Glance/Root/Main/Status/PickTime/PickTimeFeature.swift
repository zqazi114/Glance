//
//  PickTimeFeature.swift
//  Glance
//
//  Created by Z Q on 2/27/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PickTimeFeature {
    
    @ObservableState
    struct State: BaseState {
        
        var isBusy: Bool = false
        var error: AppError? = nil
        
        var time: Time? = nil
        var option: TimeOption? = nil
    }
    
    enum Action: Equatable {
        case onAppear
        case clearError
        
        case select(Time)
        case selectOption(TimeOption)
        
        enum Delegate: Equatable {
            case didSelect(Time)
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
            case .select(let time):
                state.time = time
                
                
            // --------------------------------- //
            case .selectOption(let option):
                
                if state.option == option {
                    
                    state.option = nil
                    state.time = nil
                    
                } else if let start = Date().roundedDown,
                          let end = Date(timeIntervalSinceNow: TimeInterval(option.rawValue) * 60 * 60).roundedDown {
                    
                    state.option = option
                    state.time = Time(start: start, end: end)
                }
                
                
            // --------------------------------- //
            case .delegate:
                break
                
            }
            
            return .none
        }
    }
}
