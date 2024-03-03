//
//  UserList.swift
//  Glance
//
//  Created by Z Q on 2/17/24.
//

import SwiftUI
import ComposableArchitecture

// MARK: - UserList
struct UserList: View {
    
    @Bindable var store: StoreOf<UserListFeature>
    
    var body: some View {
        
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            
            VStack {
                
                if !store.state.users.isEmpty {
                    
                    List {
                        
                        ForEach(store.state.users) { user in
                            
                            /*
                            Button {
                                store.send(.userTapped(user))
                                
                            } label: {
                                Text(user.id ?? "nil")
                            }
                            .buttonStyle(.borderless)
                             */
                            
                            NavigationLink(state: UserFeature.State(user: user)) {
                                
                                Text(user.id ?? "nil")
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                    
                } else {
                    
                    Button {
                        store.send(.loadUsers)
                        
                    } label: {
                        Text("Load users")
                    }
                }
                
                HStack { Spacer() }
                
                Spacer()
            }
            
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("User List")
            
        } destination: { store in
            UserView(store: store)
        }
        
        .progressView(store.state.isBusy)
        
        .errorAlert(error: store.state.error) {
            store.send(.clearError)
        }
        
        .onAppear(perform: {
            store.send(.loadUsers)
        })
        
        .sheet(item: $store.scope(state: \.viewUser, action: \.viewUser)) { userStore in
            
            NavigationStack {
                UserView(store: userStore)
            }
        }
    }
}

#Preview {
    UserList(store: 
        Store(
            initialState: UserListFeature.State(),
            reducer: {
                UserListFeature()
            }
        )
    )
}
