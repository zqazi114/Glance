//
//  FirebaseService_Wrapper.swift
//  Glance
//
//  Created by Z Q on 2/17/24.
//

import SwiftUI

// MARK: - WrapperField
struct WrapperField: View {
    
    var title: String
    var value: String
    
    var body: some View {
        
        HStack {
            
            Text(title)
                .foregroundStyle(.gray)
                .frame(width: 100, alignment: .leading)
            
            Divider()
            
            Text(value)
        }
    }
}

// MARK: - FirebaseService_Wrapper
struct FirebaseService_Wrapper: View {
    
    @State private var users: [User] = User.TEST
    
    @State private var error: AppError? = nil
    @State private var isBusy: Bool = false
    
    // MARK: - V_core
    private var V_core: some View {
        
        Section("Core") {
            
        }
    }
    
    // MARK: - V_auth
    private var V_auth: some View {
        
        Section("Auth") {
            
            Button {
                
                
            } label: {
                Text("Create user")
            }
            .buttonStyle(.borderless)
            
        }
    }
    
    // MARK: - V_firestore
    private var V_firestore: some View {
        
        Section("Firestore") {
            
            Button {
                F_createUserData()
                
            } label: {
                Text("Create user data")
            }
            .buttonStyle(.borderless)
            
            
            Button {
                F_loadUserData()
                
            } label: {
                Text("Load user data")
            }
            .buttonStyle(.borderless)
            
            
            ForEach($users) { $user in
                
                VStack(alignment: .leading) {
                    
                    Text(user.id ?? "nil")
                        .font(.caption)
                        .fontWeight(.bold)
                    
                    TextField(text: $user.name, prompt: Text("Name")) {
                        Text(user.name)
                    }
                    .textFieldStyle(.roundedBorder)
                }
            }
        }
    }
    
    // MARK: - body
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                List {
                    
                    V_core
                    
                    V_auth
                    
                    V_firestore
                }
                .listStyle(SidebarListStyle())
            }
            
            // ----------- NAVIGATION -----------
            
            .navigationTitle(Text("Firebase Service"))
            .navigationBarTitleDisplayMode(.large)
            
            // ----------- ANIMATION -----------

            .animation(.linear, value: isBusy)
            
            // ----------- OTHER -----------
            
            .progressView(isBusy)
            
            .errorAlert(error: error) {
                error = nil
            }
        }
    }
    
    // MARK: - F_createUserData
    private func F_createUserData() {
        
        Task {
            isBusy = true
            
            let result = await LiveFirebaseService.shared.saveUsers(users: users)
            
            switch result {
            
            case .success(let users):
                self.users = users
                
            case .failure(let error):
                self.error = error
            }
            
            isBusy = false
        }
    }
    
    // MARK: - F_loadUserData
    private func F_loadUserData() {
        
        Task {
            isBusy = true
            
            let result = await LiveFirebaseService.shared.loadUsers()
            
            switch result {
            
            case .success(let users):
                self.users = users
                
            case .failure(let error):
                self.error = error
            }
            
            isBusy = false
        }
    }
}

#Preview {
    FirebaseService_Wrapper()
}
