//
//  TabBarView.swift
//  Glance
//
//  Created by Z Q on 2/19/24.
//

import SwiftUI
import ComposableArchitecture


// MARK: - TabBarView
struct TabBarView: View {
    
    let store: StoreOf<TabBarFeature>
    
    var body: some View {
        
        TabView {
            
            SettingsView(store: store.scope(state: \.settings, action: \.settings))
                .tabItem { Text("Settings") }
            
            UserList(store: store.scope(state: \.userList, action: \.userList))
                .tabItem { Text("User List") }
            
            UserView(store: store.scope(state: \.user, action: \.user))
                .tabItem { Text("User") }
            
        }
    }
}

#Preview {
    TabBarView(store: Store(
        initialState: TabBarFeature.State(),
        reducer: {
            TabBarFeature()
        })
    )
}
