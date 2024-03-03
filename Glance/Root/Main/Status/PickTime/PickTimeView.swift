//
//  PickTimeView.swift
//  Check
//
//  Created by Z Q on 12/1/23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - PickTimeView
struct PickTimeView: View {
    
    let store: StoreOf<PickTimeFeature>
    
    
    // MARK: - body
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 0) {
                
                ForEach(TimeOption.allCases) { option in
                    
                    VStack {
                        
                        HStack {
                            
                            Button {
                                
                                store.send(.selectOption(option))
                                
                            } label: {
                                
                                HStack {
                                    Text(option.description)
                                    
                                    Spacer()
                                    
                                    if store.option == option {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.accent)
                                            .transition(.move(edge: .trailing))
                                    }
                                }
                                .padding(.vertical)
                                .padding(.horizontal)
                            }
                            
                            if option == .custom {
                                
                                DatePicker("", selection: .constant(Date()), displayedComponents: [.hourAndMinute])
                                    .datePickerStyle(.compact)
                                    .accentColor(.accent)
                                    .preferredColorScheme(.dark)
                                    .background {
                                        Color.gray.opacity(0.5)
                                            .cornerRadius(20.0)
                                            .offset(x: 3)
                                    }
                                    .tint(.accent)
                                    .frame(width: 100, alignment: .leading)
                                    .padding(.trailing)
                                    .transition(.move(edge: .trailing))
                            }
                        }
                            
                        Color.white.frame(height: 0.5)
                    }
                    .background {
                        Color.accent.opacity(store.option == option ? 0.3 : 0.0)
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .foregroundColor(.white)
        .background {
            Color.background
                .ignoresSafeArea()
        }
        .animation(.default, value: store.option)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Select Time")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            if let time = store.time {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button {
                        
                        store.send(.delegate(.didSelect(time)))
                        
                    } label: {
                        Text("Select")
                            .fontWeight(.bold)
                            .foregroundColor(.accent)
                    }
                }
            }
        }
        .onAppear {
            /*if let rounded = endDate.roundedUp {
                endDate = rounded
            } else {
                endDate = Date(timeIntervalSinceNow: -10 * 60)
            }*/
        }
    }
}

#Preview {
    NavigationStack {
        PickTimeView(store: Store(initialState: PickTimeFeature.State(), reducer: {
            PickTimeFeature()
        }))
    }
}
