//
//  PickActivityFeature.swift
//  Glance
//
//  Created by Z Q on 2/27/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PickFeature<Selectable> where Selectable: Equatable, Selectable: Identifiable, Selectable: Codable, Selectable: CaseIterable {
    
    @ObservableState
    struct State: BaseState {
        
        var isBusy: Bool = false
        var error: AppError? = nil
        
        var selected: Selectable? = nil
    }
    
    enum Action: Equatable {
        case onAppear
        case clearError
        
        case select(Selectable)
        
        enum Delegate: Equatable {
            case didSelect(Selectable)
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
            case .select(let selected):
                state.selected = state.selected == selected ? nil : selected
                
                
            // --------------------------------- //
            case .delegate:
                break
            }
            
            return .none
        }
    }
}
