//
//  RegisterView.swift
//  Glance
//
//  Created by Z Q on 2/19/24.
//

import SwiftUI
import ComposableArchitecture

// MARK: - RegisterView
struct RegisterView: View {
    
    @Bindable var store: StoreOf<RegisterFeature>
    
    // MARK: - V_logo
    private var V_logo: some View {
        
        HStack(spacing: 18) {
            
            Spacer()
            
            Image("eye left")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            Text("GLANCE")
                .font(.app_title)
                .foregroundStyle(Color.white)
            
            Image("eye right")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            Spacer()
        }
    }
    
    // MARK: - V_inputFields
    private var V_inputFields: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            TextInputField(value: $store.email, type: .email)
            
            TextInputField(value: $store.password, type: .password)
            
            TextInputField(value: $store.passwordConfirmation, type: .password)
            
        }
        .transition(.move(edge: .top))
    }
    
    // MARK: - body
    var body: some View {
        
        VStack(spacing: 40) {
            
            V_logo
            
            V_inputFields
            
            Button {
                
                store.send(.register)
                
            } label: {
                
                HStack {
                    Spacer()
                    
                    Text("Register")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                    
                    Spacer()
                }
                .padding()
                .background {
                    Color.accent
                }
                .clipShape(Capsule())
            }
            /*
            NavigationLink(state: SignInFeature.Path.State.survey(SurveyFeature.State())) {
                
                HStack {
                    Spacer()
                    
                    Text("Go to survey")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                    
                    Spacer()
                }
                .padding()
                .background {
                    Color.accent
                }
                .clipShape(Capsule())
            }
            */
            Spacer()
        }
        .padding()
        
        .background {
            Color.black
                .ignoresSafeArea()
        }
        
        .progressView(store.isBusy)
        
        .errorAlert(error: store.error) {
            store.send(.clearError)
        }
    }
}

#Preview {
    RegisterView(store: Store(
        initialState: RegisterFeature.State(email: "test1@user.com", password: "Testuser123", passwordConfirmation: "Testuser123"),
        reducer: {
            
        RegisterFeature()
    }))
}
