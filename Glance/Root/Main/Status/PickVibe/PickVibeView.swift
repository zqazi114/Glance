//
//  PickVibeView.swift
//  Check
//
//  Created by Z Q on 12/1/23.
//

import SwiftUI
import ComposableArchitecture


// MARK: - PickVibeView
struct PickVibeView: View {
    
    let store: StoreOf<PickVibeFeature>
    
    
    // MARK: - body
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            ForEach(Vibe.allCases) { vibe in
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Button {
                        
                        store.send(.select(vibe))
                        
                    } label: {
                        
                        HStack {
                            Text(vibe.icon)
                                .font(.title)
                                .fontWeight(.light)
                            
                            Text(vibe.title)
                                .font(.body)
                                .fontWeight(.light)
                            
                            Spacer()
                            
                            if store.vibe == vibe {
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accent)
                                    .transition(.move(edge: .trailing))
                                
                            }
                        }
                        .padding()
                    }
                    
                    Color.white
                        .frame(height: 0.5)
                }
                .background {
                    Color.accent.opacity(store.vibe == vibe ? 0.3 : 0.0)
                }
            }
            
            Spacer()
            
            HStack { Spacer() }
        }
        
        .padding()
        
        .foregroundColor(.white)
        .background {
            Color.background
                .ignoresSafeArea()
        }
        
        .animation(.default, value: store.vibe)
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            
            ToolbarItem(placement: .principal) {
                Text("Select Vibe")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            if let vibe = store.vibe {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button {
                        
                        store.send(.delegate(.didSelect(vibe)))
                        
                    } label: {
                        Text("Select")
                            .fontWeight(.bold)
                            .foregroundColor(.accent)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PickVibeView(store: Store(initialState: {
            PickVibeFeature.State()
        }(), reducer: {
            PickVibeFeature()
        }))
    }
}
