//
//  SettingsView.swift
//  Glance
//
//  Created by Z Q on 2/19/24.
//

import SwiftUI
import ComposableArchitecture


// MARK: - SettingsView
struct SettingsView: View {
    
    let store: StoreOf<SettingsFeature>
    
    
    var body: some View {
        
        VStack {
            
            Button {
                store.send(.logOut)
                
            } label: {
                Text("Log out")
            }
        }
        
        .progressView(store.state.isBusy)
        
        .errorAlert(error: store.state.error) {
            store.send(.clearError)
        }
    }
}

#Preview {
    SettingsView(store: Store(initialState: SettingsFeature.State(), reducer: {
        SettingsFeature()
    }))
}
