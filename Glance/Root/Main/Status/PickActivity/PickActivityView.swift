//
//  PickActivityView.swift
//  Check
//
//  Created by Z Q on 12/1/23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - PickView
struct PickView<Selectable>: View where Selectable: Equatable, Selectable: Identifiable, Selectable: Codable, Selectable: CaseIterable, Selectable.AllCases == Array<Selectable> {
    
    let store: StoreOf<PickFeature<Selectable>>
    
    
    // MARK: - body
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 0) {
                
                ForEach(Selectable.allCases) { option in
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Button {
                            store.send(.select(option))
                            
                        } label: {
                            
                            HStack {
                                
                                Text(option.id as? String ?? "")
                                
                                Spacer()
                                
                                if store.selected == option {
                                    
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
                        Color.accent
                            .opacity(store.selected == option ? 0.3 : 0.0)
                    }
                }
            }
        }
        
        .padding()
        
        .foregroundColor(.white)
        .background {
            Color.background
                .ignoresSafeArea()
        }
        
        .animation(.default, value: store.selected)
        
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            ToolbarItem(placement: .principal) {
                Text("Select Activities")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            if let selected = store.selected {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button {
                        
                        store.send(.delegate(.didSelect(selected)))
                        
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
        PickView<Activity>(store: Store(initialState: PickFeature.State(), reducer: {
            
            PickFeature()
        }))
    }
}
