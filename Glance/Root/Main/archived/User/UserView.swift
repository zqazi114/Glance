//
//  UserView.swift
//  Glance
//
//  Created by Z Q on 2/16/24.
//

import SwiftUI
import ComposableArchitecture

// MARK: - UserView
struct UserView: View {
    
    let store: StoreOf<UserFeature>
    
    // MARK: - V_user
    private var V_user: some View {
        
        VStack {
            
            if let user = store.state.user {
                
                Text("\(user.name), \(user.dob.age)")
                
                Text(user.city.description)
                
                AsyncImage(url: URL(string: user.profilePictureURL)) { image in
                    
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                } placeholder: {
                    
                    Color.gray
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }

            }
        }
    }
    
    // MARK: - body
    var body: some View {
        
        VStack {
            
            V_user
            
            Spacer()
        }
        
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing) {
                
                Button {
                    store.send(.backTapped)
                    
                } label: {
                    Text("Cancel")
                }
            }
        }
        
        .onAppear(perform: {
            store.send(.loadUser())
        })
        
        .progressView(store.state.isBusy)
        
        .errorAlert(error: store.state.error) {
            store.send(.clearError)
        }
    }
}

#Preview {
    UserView(store:
        Store(
            initialState: UserFeature.State(user: User.TEST.first!),
            reducer: {
                UserFeature()
            }
        )
    )
}
