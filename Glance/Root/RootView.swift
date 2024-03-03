//
//  RootView.swift
//  Glance
//
//  Created by Z Q on 2/18/24.
//

import SwiftUI
import ComposableArchitecture

// MARK: - RootView
struct RootView: View {
    
    @Bindable var store: StoreOf<RootFeature>
    
    
    // MARK: - body
    var body: some View {
        
        VStack {
            
            if store.main != nil, let mainStore = store.scope(state: \.main, action: \.main) {
                
                MainView(store: mainStore)
                
            } else if store.signIn != nil, let signInStore = store.scope(state: \.signIn, action: \.signIn) {
                
                SignInView(store: signInStore)
                    .transition(.move(edge: .bottom))
                
            } else {
                
                SplashView()
                    .transition(.move(edge: .leading))
                
            }
        }
        
        .onAppear {
            store.send(.onAppear, animation: .bouncy)
            
            FirebaseService.liveValue.logOut()
        }
    }
}

#Preview {
    RootView(store: Store(
        initialState: RootFeature.State(),
        reducer: {
            RootFeature()
        })
    )
}
