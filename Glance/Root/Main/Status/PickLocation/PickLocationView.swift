//
//  PickLocationView.swift
//  Check
//
//  Created by Z Q on 11/30/23.
//

import SwiftUI
import ComposableArchitecture


// MARK: - PickLocationView
struct PickLocationView: View {
    
    @Bindable var store: StoreOf<PickLocationFeature>
    
    
    // MARK: - V_searchBar
    private var V_searchBar: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                
                TextField(text: $store.search.sending(\.searchChanged), prompt: Text("Enter name").foregroundColor(.gray)) {
                    
                }
                .foregroundColor(.white)
                .padding()
                .background {
                    Color.white_textField
                        .cornerRadius(10.0)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 10.0)
                        .strokeBorder(Color.white)
                }
                
                Button {
                    store.send(.fetchLocations)
                    
                } label: {
                    
                    Text("Find")
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .foregroundStyle(Color.white)
                        .background {
                            Color.accent
                        }
                        .clipShape(Capsule())
                }
            }
            
            ScrollView(.horizontal) {
                
                HStack {
                    
                    ForEach(LocationType.allCases) { type in
                        
                        Button {
                            store.send(.toggleType(type))
                            
                        } label: {
                            
                            Text(type.description)
                                .font(.caption)
                                .fontWeight(store.type == type ? .bold : .light)
                        }
                    }
                }
            }
            .padding(10)
        }
    }
    
    // MARK: - V_results
    private var V_results: some View {
        
        ScrollView {
            
            ForEach(store.locations) { location in
                
                Button {
                    
                    store.send(.delegate(.didSelect(location)))
                    
                } label: {
                    
                    LocationTile(location: location)
                }
                
                Color.white
                    .frame(height: 0.5)
                    .padding(.vertical)
            }
        }
    }
    
    // MARK: - body
    var body: some View {
        
        VStack(alignment: .leading, spacing: 40) {
            
            V_searchBar
            
            Text("Places nearby".uppercased())
                .font(.caption)
            
            V_results
        }
        .padding()
        
        .foregroundColor(.white)
        .background {
            Color.background
                .ignoresSafeArea()
        }
        
        .animation(.default, value: store.search)
        .animation(.default, value: store.locations)
        
        .progressView(store.isBusy)
        
        .errorAlert(error: store.error) {
            store.send(.clearError)
        }
        
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    NavigationStack {
        PickLocationView(store: Store(initialState: PickLocationFeature.State(), reducer: {
            
            PickLocationFeature()
        }))
    }
}
