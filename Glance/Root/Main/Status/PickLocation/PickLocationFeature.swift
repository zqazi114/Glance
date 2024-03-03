//
//  PickLocationFeature.swift
//  Glance
//
//  Created by Z Q on 2/23/24.
//

import ComposableArchitecture
import Combine
import Foundation


@Reducer
struct PickLocationFeature {
    
    @ObservableState
    struct State: BaseState {
        
        var isBusy: Bool = false
        var error: AppError? = nil
        
        var type: LocationType? = nil
        var search: String = ""
        var locations: [Location] = []
        var selectedLocation: Location?
        
        var cancellables: [AnyCancellable] = []
    }
    
    enum Action: Equatable {
        
        case onAppear
        case clearError
        
        case toggleType(LocationType)
        case searchChanged(String)
        
        case fetchLocations
        case didFetchLocations([Location])
        case setError(AppError)
        
        case saveCancellable(AnyCancellable)
        
        enum Delegate: Equatable {
            case didSelect(Location)
        }
        
        case delegate(Delegate)
    }
    
    @Dependency(\.googlePlaces) var googlePlaces
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            
            switch action {
                
            // --------------------------------- //
            case .onAppear:
                return .publisher {
                    
                    googlePlaces
                        .placesSubject
                        .receive(on: RunLoop.main)
                        .map { .didFetchLocations($0.map { Location(placeResult: $0) } ) }
                }
                
                
            // --------------------------------- //
            case .clearError:
                state.error = nil
                
                
            // --------------------------------- //
            case .toggleType(let type):
                if state.type == type {
                    state.type = nil
                    
                } else {
                    state.type = type
                }
                
                
            // --------------------------------- //
            case let .searchChanged(newValue):
                state.search = newValue
                
                
            // --------------------------------- //
            case .fetchLocations:
                state.isBusy = true
                
                googlePlaces.fetchPlaces(type: state.type?.description ?? "bar")

                
            // --------------------------------- //
            case .didFetchLocations(let locations):
                state.locations = locations
                state.isBusy = false
                
                
            // --------------------------------- //
            case .setError(let error):
                state.error = error
                    
                
            // --------------------------------- //
            case .saveCancellable(let cancellable):
                state.cancellables.append(cancellable)
                    
                
            // --------------------------------- //
            case .delegate:
                break
            }
            
            return .none
        }
    }
}
