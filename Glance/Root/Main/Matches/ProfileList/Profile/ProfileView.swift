//
//  ProfileView.swift
//  Check
//
//  Created by Z Q on 12/2/23.
//

import SwiftUI
import ComposableArchitecture


// MARK: - ProfileView
struct ProfileView: View {
    
    let store: StoreOf<ProfileFeature>
    
    
    // MARK: - V_picture
    private var V_picture: some View {
        
        AsyncImage(url: URL(string: store.user.profilePictureURL)) { image in
            
            image
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .edgesIgnoringSafeArea(.top)
                .mask {
                    Circle()
                        .frame(width: store.isOpen ? UIScreen.main.bounds.height + 200 : 1, height: store.isOpen ? UIScreen.main.bounds.height + 200 : 1)
                }
            
        } placeholder: {
            
            Color.gray
                .edgesIgnoringSafeArea(.top)
        }
    }
    
    // MARK: - V_pictureGradient
    private var V_pictureGradient: some View {
        
        VStack(spacing: 0) {
            
            LinearGradient(colors: [.black, .clear], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1))
                .frame(height: 100)
            
            Spacer()
            
            LinearGradient(colors: [.clear, .black], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1))
                .frame(height: 100)
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    // MARK: - V_timerBar
    private var V_timerBar: some View {
        
        GeometryReader { geo in
            
            HStack(alignment: .bottom) {
                
                Spacer()
                
                Capsule()
                    .foregroundColor(.accent)
                    .frame(width: 3)
                    .padding(.bottom, 80)
                    .padding(.trailing, 5)
                    .frame(height: geo.size.height * store.expiration / store.Duration)
                    .shadow(color: .black, radius: 3)
                    .animation(.default, value: store.expiration)
            }
            .frame(height: geo.size.height, alignment: .bottom)
        }
    }
    
    // MARK: - V_statusButton
    private var V_statusButton: some View {
        
        Button {
            store.send(.toggleStatus)
            
        } label: {
            
            Text("What are they up to?")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.accent)
                .background {
                    Color.black
                        .blur(radius: 10)
                }
        }
        .transition(.opacity)
    }
    
    // MARK: - V_status
    private var V_status: some View {
        
        StatusPreview(status: store.status) {
            store.send(.toggleStatus)
        }
        .background {
            Color.black.opacity(0.6)
                .cornerRadius(20)
        }
        .padding(.bottom, 80)
    }
    
    // MARK: - V_dislikeButton
    private var V_dislikeButton: some View {
        
        Button {
            F_animateDisappear()
            
        } label: {
            HStack {
                Text("Look away 👀")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            .frame(width: 150, height: 20)
            .padding(.top)
            .padding(.bottom, 60)
            .background {
                Color.accentRed
                    .cornerRadius(100, corners: [.topRight])
                    .ignoresSafeArea(.all, edges: .bottom)
            }
            .frame(height: 20)
        }
    }
    
    // MARK: - V_likeButton
    private var V_likeButton: some View {
        
        Button {
            store.send(.delegate(.liked(store.user)))
            
        } label: {
            
            HStack {
                Text("Smile 😏")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            .frame(width: 150, height: 20)
            .padding(.top)
            .padding(.bottom, 60)
            .background {
                Color.accent
                    .cornerRadius(100, corners: [.topLeft])
                    .ignoresSafeArea(.all, edges: .bottom)
            }
            .frame(height: 20)
        }
    }
    
    // MARK: - body
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            Color.black
                .ignoresSafeArea()
            
            V_picture
            
            V_pictureGradient
            
            V_timerBar
            
            if store.isShowingButtons {
                
                VStack {
                    
                    V_statusButton
                    
                    Spacer()
                    
                    if store.isShowingStatus {
                        
                        V_status
                    }
                }
                .padding()
                
                HStack {
                    
                    V_dislikeButton
                    
                    Spacer()
                    
                    V_likeButton
                }
                .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                .zIndex(1)
            }
        }
        
        .animation(.easeOut, value: store.isOpen)
        .animation(.easeOut, value: store.isShowingButtons)
        .animation(.linear, value: store.isShowingStatus)
        
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            if store.isShowingButtons {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    HStack(spacing: 0) {
                        Text(store.user.name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(",  \(store.user.dob.age)")
                            .font(.title3)
                            .fontWeight(.light)
                            .foregroundColor(.white)
                    }
                    .transition(.move(edge: .trailing))
                }
                
            } else {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    HStack(spacing: 0) {
                        Text(" ")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
                
            }
        }
        
        .onChange(of: store.expiration) { oldValue, newValue in
            
            if newValue <= 1 {
                
                store.send(.stopTimer)
                
                F_animateDisappear()
            }
        }
        
        .onAppear {
            
            store.send(.startTimer)
            
            F_animateAppear()
        }
    }
    
    // MARK: - F_animateAppear
    private func F_animateAppear() {
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            store.send(.toggleOpen)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
            store.send(.toggleButtons)
        }
    }
    
    // MARK: - F_animateDisappear
    private func F_animateDisappear() {
        
        store.send(.toggleStatus)
        store.send(.toggleButtons)
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            store.send(.toggleOpen)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            
            store.send(.delegate(.disliked(store.user)))
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(store: Store(initialState: ProfileFeature.State(user: User.TEST.randomElement()!, status: Status.TEST.randomElement()!), reducer: {
            ProfileFeature()
        }))
    }
}
