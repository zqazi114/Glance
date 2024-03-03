//
//  SignInView.swift
//  Glance
//
//  Created by Z Q on 2/19/24.
//

import SwiftUI
import ComposableArchitecture

// MARK: - SignInView
struct SignInView: View {
    
    @Bindable var store: StoreOf<SignInFeature>
    
    // MARK: - V_logo
    private var V_logo: some View {
        
        HStack(spacing: 18) {
            
            Spacer()
            
            Image("eye left")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
            
            Text("GLANCE")
                .font(.app_title)
                .foregroundStyle(Color.white)
            
            Image("eye right")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
            
            Spacer()
        }
    }
    
    // MARK: - body
    var body: some View {
        
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            
            VStack {
                
                V_logo
                
                Spacer()
                
                NavigationLink(state: SignInFeature.Path.State.login(LogInFeature.State(email: "test@user.com", password:"Testuser123"))) {
                    
                    HStack {
                        Spacer()
                        
                        Text("Log In")
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
                
                NavigationLink(state: SignInFeature.Path.State.register(RegisterFeature.State())) {
                    
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
            }
            .padding()
            
            .background {
                Color.black
                    .ignoresSafeArea()
            }
            
        } destination: { path in
            
            switch path.state {
                
            case .login:
                
                if let store = path.scope(state: \.login, action: \.login) {
                    LogInView(store: store)
                }
                
                
            case .register:
                
                if let store = path.scope(state: \.register, action: \.register) {
                    RegisterView(store: store)
                }
                
                
            case .survey:
                
                if let store = path.scope(state: \.survey, action: \.survey) {
                    SurveyView(store: store)
                }
            }
        }
    }
}

#Preview {
    SignInView(store: Store(initialState: SignInFeature.State(), reducer: {
        SignInFeature()
    }))
}
