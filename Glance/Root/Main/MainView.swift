//
//  MainView.swift
//  Glance
//
//  Created by Z Q on 2/19/24.
//

import SwiftUI
import ComposableArchitecture


// MARK: - MainView
struct MainView: View {
    
    let store: StoreOf<MainFeature>
    
    // MARK: - body
    var body: some View {
        
        if store.isEditingStatus {
            
            StatusView(store: store.scope(state: \.status, action: \.status))
            
        } else {
            
            MatchesView(store: store.scope(state: \.matches, action: \.matches))
        }
    }
}

#Preview {
    MainView(store: Store(initialState: MainFeature.State(), reducer: { MainFeature() }))
}
