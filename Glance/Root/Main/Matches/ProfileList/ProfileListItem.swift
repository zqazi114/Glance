//
//  ProfileListItemView.swift
//  Glance
//
//  Created by Z Q on 2/28/24.
//

import SwiftUI
import ComposableArchitecture

// MARK: - StatusTag
struct StatusTag: View {
    
    var text: String?
    var type: StatusType
    
    var body: some View {
        
        HStack {
            
            Image(systemName: type.icon)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 20)
            
            Text(text ?? "")
                .font(.caption)
                .foregroundColor(.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background {
                    Color.accent.opacity(0.5)
                }
                .clipShape(Capsule())
        }
    }
}

// MARK: - ProfileListItem
struct ProfileListItem: View {
    
    var store: StoreOf<ProfileFeature>
    
    
    // MARK: - V_picture
    private var V_picture: some View {
        
        AsyncImage(url: URL(string: store.user.profilePictureURL)) { image in
            
            image
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.trailing)
            
        } placeholder: {
            
            Color.black
                .frame(width: 60, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.trailing)
        }
    }
    
    // MARK: - V_status
    private var V_status: some View {
        
        VStack(alignment: .leading) {
            
            StatusTag(text: store.status.time?.preview, type: .time)
            
            StatusTag(text: store.status.activity?.id, type: .activity)
            
            StatusTag(text: store.status.vibe?.preview, type: .vibe)
            
            Spacer()
        }
    }
    
    // MARK: - V_timerBar
    private var V_timerBar: some View {
        
        GeometryReader { geo in
            
            ZStack(alignment: .bottom) {
                
                Capsule()
                    .foregroundColor(.background)
                    .frame(width: 3)
                
                Capsule()
                    .foregroundColor(.accent)
                    .frame(width: 3, height: geo.size.height * store.expiration / store.Duration)
            }
        }
        .frame(width: 3)
    }
    
    // MARK: - body
    var body: some View {
        
        let pathState = ProfileListFeature.Path.State.profile(store.state)
        
        NavigationLink(state: pathState) {
            
            VStack {
                
                HStack(alignment: .top) {
                    
                    V_picture
                    
                    V_status
                    
                    Spacer()
                    
                    V_timerBar
                }
                .padding(.vertical, 5)
                
                Color.white
                    .frame(height: 0.5)
            }
            
            .animation(.default, value: store.expiration)
            
            .onChange(of: store.expiration) { oldValue, newValue in
                
                if newValue <= 0 {
                    
                    store.send(.stopTimer)
                    //store.send(.delegate(.disliked(store.user)))
                    NotificationCenter.default.post(name: .profileExpired, object: store.user)
                }
            }
            
            .onAppear {
                
                store.send(.startTimer)
            }
        }
    }
}

#Preview {
    
    ProfileListItem(store: Store(initialState: ProfileFeature.State(user: User.TEST.randomElement()!, status: Status.TEST.randomElement()!), reducer: {
        
        ProfileFeature()
    }))
    .background {
        Color.black
            .ignoresSafeArea()
    }
}
