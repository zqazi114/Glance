//
//  LogInView.swift
//  Glance
//
//  Created by Z Q on 2/19/24.
//

import SwiftUI
import ComposableArchitecture

// MARK: - TextInputField
struct TextInputField: View {
    
    enum FieldType {
        case email, password
    }

    @Binding var value: String
    var type: FieldType
    
    private var title: String {
        type == .email ? "Email" : "Password"
    }
    
    private var logo: String {
        type == .email ? "envelope.fill" : "lock.fill"
    }
    
    private var placeholder: String {
        type == .email ? "Enter email address" : "Enter password"
    }
    
    // MARK: - body
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            
            HStack(spacing: 5) {
                
                Image(systemName: logo)
                    .font(.caption)
                    .foregroundStyle(Color.white)
                
                Text(title.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
            }
            
            if type == .email {
                
                TextField(text: $value, prompt: Text(placeholder)) { }
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .foregroundStyle(Color.white)
                    .background {
                        
                        HStack {
                            
                            Text(value.isEmpty ? placeholder : "")
                                .foregroundStyle(.gray)
                            
                            Spacer()
                        }
                    }
                
            } else {
                
                SecureField(text: $value, prompt: Text(placeholder)) { }
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .foregroundStyle(Color.white)
                    .background {
                        
                        HStack {
                            
                            Text(value.isEmpty ? placeholder : "")
                                .foregroundStyle(.gray)
                            
                            Spacer()
                        }
                    }
            }
        }
        .padding()
        .background {
            Color.white.opacity(0.2)
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(Color.white, lineWidth: 0.5)
        }
    }
}

// MARK: - LogInView
struct LogInView: View {
    
    @Bindable var store: StoreOf<LogInFeature>
    
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
            
        }
        .transition(.move(edge: .top))
    }
    
    // MARK: - body
    var body: some View {
        
        VStack(spacing: 40) {
            
            V_logo
            
            V_inputFields
            
            Button {
                
                store.send(.login)
                
            } label: {
                
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
    LogInView(store: Store(initialState: LogInFeature.State(email: "test@user.com", password:"Testuser123"), reducer: {
        LogInFeature()
    }))
}
