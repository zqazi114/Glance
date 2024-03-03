//
//  ProfileListView.swift
//  Glance
//
//  Created by Z Q on 2/28/24.
//

import SwiftUI
import ComposableArchitecture

// MARK: - ProfileListView
struct ProfileListView: View {
    
    @Bindable var store: StoreOf<ProfileListFeature>
    
    
    // MARK: - body
    var body: some View {
        
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            
            ScrollView {
                
                VStack(alignment: .leading) {
                    
                    Text("WHO'S AROUND")
                        .font(.caption)
                    
                    ForEach(store.users) { user in
                        
                        ProfileListItem(store: Store(initialState: ProfileFeature.State(user: user, status: Status.TEST.randomElement()!), reducer: {
                            
                            ProfileFeature()
                        }))
                    }
                    
                    HStack { Spacer() }
                }
            }
            .padding()
            .background {
                Color.black
                    .ignoresSafeArea()
            }
            
            .animation(.default, value: store.users)
            
        } destination: { path in
            
            switch path.state {
                
            case .profile:
                
                if let store = path.scope(state: \.profile, action: \.profile) {
                    
                    ProfileView(store: store)
                }
            }
        }
        
        .onReceive(NotificationCenter.default.publisher(for: .profileExpired), perform: { object in
            
            if let user = object.object as? User {
                store.send(.userExpired(user))
            }
        })
    }
}

#Preview {
    ProfileListView(store: Store(initialState: ProfileListFeature.State(users: []), reducer: {
        
        ProfileListFeature()
    }))
}
