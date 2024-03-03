//
//  MatchesView.swift
//  Glance
//
//  Created by Z Q on 2/27/24.
//

import SwiftUI
import ComposableArchitecture


// MARK: - MatchesView
struct MatchesView: View {
    
    @Environment(\.notificationHelper) var notificationHelper
    
    let store: StoreOf<MatchesFeature>
    
    
    // MARK: - V_matches
    private var V_matches: some View {
        
        ProfileListView(store: store.scope(state: \.profileList, action: \.profileList))
            .transition(.push(from: .bottom))
    }
    
    
    // MARK: - V_bannerAndQuote
    private var V_bannerAndQuote: some View {
        
        VStack {
            
            Text("Put your phone away and have fun\n\nWe'll let you know when there's someone to see")
                .font(.title3)
                .fontWeight(.ultraLight)
                .lineSpacing(5.0)
                .multilineTextAlignment(.center)
                .padding(.top, 60)
            
            Spacer()
            
            HStack { Spacer() }
            
            Button {
                notificationHelper.newUsersNearby(uids: [])
                
                Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
                    
                    notificationHelper.newUsersNearby(uids: [])
                }
                
            } label: {
                
                QuoteView(store: store.scope(state: \.quote, action: \.quote))
            }
        }
        .transition(.opacity)
        .overlay {
            
            if store.isShowingView {
                
                VStack {
                    
                    HStack {
                        Text("You're active")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        // FIXME: Replace with TCA
                        Button {
                            //NotificationCenter.default.post(name: .app_didSetStatus, object: false)
                            
                        } label: {
                            
                            Text("Edit Status")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.bottom)
                                .padding(.leading)
                                .frame(width: 130, height: 100, alignment: .bottom)
                                .background {
                                    Color.accent
                                }
                                .cornerRadius(100, corners: [.bottomLeft])
                                .offset(x: 0, y: -20)
                        }
                    }
                    .padding(.top)
                    
                    Spacer()
                }
                .ignoresSafeArea(edges: .top)
            }
        }
    }
    
    
    // MARK: - body
    var body: some View {
        
        VStack(alignment: .leading) {
            
            if store.isShowingView {
                
                if store.isShowingProfiles {
                    
                    V_matches
                    
                } else {
                    
                    V_bannerAndQuote
                }
                
            } else {
                
                Spacer()
                
                HStack { Spacer() }
            }
        }
        
        .foregroundColor(.white)
        .background {
            Color.black
                .ignoresSafeArea()
        }
        
        .animation(.easeOut.delay(1), value: store.isShowingView)
        .animation(.easeIn, value: store.isShowingProfiles)
        .animation(.easeOut.delay(1), value: store.profileList.users)
        
        .onAppear {
            
            store.send(.onAppear)
            
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
                
                store.send(.toggleShowingView(true))
            }
        }
    }
}

#Preview {
    MatchesView(store: Store(initialState: MatchesFeature.State(), reducer: { MatchesFeature() }, withDependencies: {
        
        $0.firebase = FirebaseService.testValue
    }))
}

