//
//  QuoteFeature.swift
//  Glance
//
//  Created by Z Q on 2/28/24.
//

import ComposableArchitecture

@Reducer
struct QuoteFeature {
    
    @ObservableState
    struct State: BaseState {
        
        var isBusy: Bool = false
        var error: AppError? = nil
        
        var quote: Quote? = nil
        
        var isShowing: Bool = false
    }
    
    enum Action: Equatable {
        case onAppear
        case clearError
        
        case didFetch(Quote?)
    }
    
    @Dependency(\.quotesService) var quotesService
    
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
        
            switch action {
                
            // --------------------------------- //
            case .onAppear:
                
                quotesService.fetch()
                
                return .publisher {
                    quotesService
                        .publisher
                        .map { .didFetch($0.first) }
                }
                
                
            // --------------------------------- //
            case .clearError:
                state.error = nil
                
                
            // --------------------------------- //
            case .didFetch(let quote):
                state.quote = quote
                
                state.isShowing = true
            }
            
            return .none
        }
    }
}
