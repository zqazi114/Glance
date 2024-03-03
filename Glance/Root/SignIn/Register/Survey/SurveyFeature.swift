//
//  SurveyFeature.swift
//  Glance
//
//  Created by Z Q on 2/22/24.
//

import Foundation
import ComposableArchitecture


@Reducer
struct SurveyFeature {
    
    @ObservableState
    struct State: BaseState {
        
        var isBusy: Bool = false
        var error: AppError? = nil
        
        var name: String = ""
        var dob: Date = Date(timeIntervalSinceNow: 0)
        var city: City = .sanFrancisco
        var picture: String = ""
        
        var isInputValid: Bool {
            return name.isValidName && dob.isLegalAge
        }
    }
    
    enum Action: Equatable, BindableAction {
        
        case onAppear
        case clearError
        
        case binding(BindingAction<State>)
        
        case save
        case didTrySave(Result<Bool, AppError>)
        case saved
        
        enum Delegate: Equatable {
            case didSave
        }
        
        case delegate(Delegate)
    }
    
    @Dependency(\.firebase) var firebase
    
    var body: some ReducerOf<Self> {
        
        BindingReducer()
        
        Reduce { state, action in
            
            switch action {
                
            // --------------------------------- //
            case .onAppear:
                break
                
                
            // --------------------------------- //
            case .clearError:
                state.error = nil
                
                
            // --------------------------------- //
            case .binding:
                break
            
            
            // --------------------------------- //
            case .save:
                state.isBusy = true
                
                return .run { [ name = state.name , dob = state.dob, city = state.city, profilePictureURL = state.picture, pictureURLs = [state.picture] ] send in
                    
                    let result = await firebase.saveUser(user: User(name: name, dob: dob, city: city, profilePictureURL: profilePictureURL, pictureURLs: pictureURLs))
                    
                    await send(.didTrySave(result))
                }
                
                
            // --------------------------------- //
            case let .didTrySave(result):
                
                switch result {
                    
                case .success(let status):
                    return .run { await $0(.saved) }
                    
                case .failure(let error):
                    state.isBusy = false
                    state.error = error
                }
                
                
            // --------------------------------- //
            case .saved:
                state.isBusy = false
                
                return .run {
                    await $0(.delegate(.didSave))
                }
                
                
            // --------------------------------- //
            case .delegate:
                break
                
            }
            
            return .none
        }
    }
}
