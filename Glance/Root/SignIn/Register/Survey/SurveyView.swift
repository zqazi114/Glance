//
//  SurveyView.swift
//  Glance
//
//  Created by Z Q on 2/22/24.
//

import SwiftUI
import ComposableArchitecture
import PhotosUI


// MARK: - PickerView
struct PickerView<T: Hashable & CaseIterable & RawRepresentable & CustomStringConvertible>: View {
    
    var title: String
    @Binding var selection: T
    
    var body: some View {
        
        Picker(title, selection: $selection) {
            
            let cases = T.allCases
            
            ForEach(0..<cases.count, id: \.self) { idx in
                
                let index = cases.index(cases.startIndex, offsetBy: idx)
                let thisCase = cases[index]
                
                Text(thisCase.description)
                    .foregroundStyle(Color.blue)
                    .tag(thisCase)
            }
        }
        .frame(width: 0)
    }
}

// MARK: - SurveyView
struct SurveyView: View {
    
    @Bindable var store: StoreOf<SurveyFeature>
    
    @State var item: PhotosPickerItem?
    @State private var profileImage: Image?
    
    // MARK: - body
    var body: some View {
        
        VStack {
            
            Form {
                
                
                Section {
                    
                    TextField(text: $store.name, prompt: Text("Enter your name")) {
                        
                        Text(store.name)
                    }
                    .foregroundStyle(Color.black)
                    
                } header: {
                    Text("Name")
                }
                
                
                Section {
                    
                    DatePicker("", selection: $store.dob, displayedComponents: .date)
                        .frame(width: 110)
                        .tint(Color.accent)
                        .background {
                            Color.white
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                } header: {
                    Text("Date of birth")
                }
                .listRowBackground(Color.clear)
                
                Section {
                    
                    PickerView(title: "", selection: $store.city)
                        .tint(Color.white)
                    
                } header: {
                    Text("Location")
                }
                .listRowBackground(Color.clear)
                
                Section {
                    
                    profileImage?
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .padding(10)
                        .padding(.leading)
                    
                    PhotosPicker("Select picture", selection: $item, matching: .images)
                    
                        .foregroundStyle(Color.black)
                    
                        .onChange(of: item) {
                            
                            Task {
                                
                                if let loaded = try? await item?.loadTransferable(type: Image.self) {
                                    profileImage = loaded
                                }
                            }
                        }
                    
                    
                } header: {
                    Text("Images")
                }
            }
            
            .foregroundStyle(Color.white)
            
            .background {
                Color.black
            }
            
            .scrollContentBackground(.hidden)
            
            Button {
                
                store.send(.save)
                
            } label: {
                
                HStack {
                    
                    Spacer()
                    
                    Text("Save")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                    
                    Spacer()
                }
                .padding()
                .background {
                    store.isInputValid ? Color.blue : Color.gray
                }
                .clipShape(Capsule())
            }
            .padding()
            .disabled(!store.isInputValid)
        }
        
        .background {
            Color.black
                .ignoresSafeArea()
        }
        
        .toolbar(.hidden, for: .navigationBar)
        
        .progressView(store.isBusy)
        
        .errorAlert(error: store.error) {
            store.send(.clearError)
        }
    }
}

#Preview {
    SurveyView(store: Store(initialState: SurveyFeature.State(), reducer: {
        
        SurveyFeature()
    }))
}
