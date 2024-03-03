//
//  StatusView.swift
//  Glance
//
//  Created by Z Q on 2/23/24.
//

import SwiftUI
import ComposableArchitecture

// MARK: - SetStatusView
struct StatusView: View {
    
    @Bindable var store: StoreOf<StatusFeature>
    
    private var step: Int {
        
        if store.status.vibe != nil {
            return 4
            
        } else if store.status.time != nil {
            return 3
            
        }  else if store.status.activity != nil {
            return 2
            
        } else if store.status.location != nil {
            return 1
        }
        
        return 0
    }
    
    // MARK: - V_preview
    private var V_preview: some View {
        
        StatusPreview(status: store.status) {
            
            store.send(.toggleViews(true))
            store.send(.togglePreview(false))
        }
        .padding(.top, 40)
    }
    
    // MARK: - V_statusFields
    private var V_statusFields: some View {
        
        VStack(alignment: .leading) {
            
            if step >= 0 {
                
                NavigationLink(state: StatusFeature.Path.State.pickLocation(PickLocationFeature.State())) {
                    
                    StatusField(type: .location, isFirstTimeAppearing: step < 1, value: store.status.location?.name)
                }
            }
            
            if step >= 1 {
                
                NavigationLink(state: StatusFeature.Path.State.pickActivity(PickFeature<Activity>.State())) {
                    
                    StatusField(type: .activity, isFirstTimeAppearing: step < 2, value: store.status.activity?.id)
                }
            }
            
            if step >= 2 {
                
                NavigationLink(state: StatusFeature.Path.State.pickTime(PickTimeFeature.State())) {
                    
                    StatusField(type: .time, isFirstTimeAppearing: step < 3, value: store.status.time?.end.printable)
                }
            }
            
            if step >= 3 {
                
                NavigationLink(state: StatusFeature.Path.State.pickVibe(PickVibeFeature.State())) {
                    
                    StatusField(type: .vibe, isFirstTimeAppearing: step < 4, value: store.status.vibe?.preview)
                }
            }
        }
        .padding()
        .transition(.asymmetric(insertion: .push(from: .top), removal: .move(edge: .top)))
    }
    
    // MARK: - V_setButton
    private var V_setButton: some View {
        
        Button {
            store.send(.delegate(.didSetStatus))
            
        } label: {
            
            GeometryReader { geo in
                
                HStack {
                    
                    Spacer()
                    
                    Text("Set & Forget")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .frame(width: geo.size.width * 0.4, height: 20)
                .padding(.top)
                .padding(.bottom, 60)
                .background {
                    Color.accent
                        .cornerRadius(100, corners: [.topLeft])
                        .ignoresSafeArea(.all, edges: .bottom)
                }
                .frame(width: geo.size.width, height: 20, alignment: .trailing)
            }
            .frame(height: 20)
        }
        .transition(.push(from: .bottom))
    }
    
    // MARK: - body
    var body: some View {
        
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            
            VStack {
                
                ScrollView {
                    
                    if store.isShowingPreview {
                        
                        V_preview
                        
                    } else if !store.isShowingViews {
                        
                        V_statusFields
                        
                    }
                }
                
                if store.isShowingButton {
                    
                    V_setButton
                }
            }
            .foregroundColor(.white)
            .background {
                Color.background
                    .ignoresSafeArea()
            }
            
        } destination: { path in
            
            switch path.state {
                
            case .pickLocation:
                
                if let store = path.scope(state: \.pickLocation, action: \.pickLocation) {
                    PickLocationView(store: store)
                }
                
            case .pickActivity:
                
                if let store = path.scope(state: \.pickActivity, action: \.pickActivity) {
                    PickView<Activity>(store: store)
                }
                
            case .pickTime:
                
                if let store = path.scope(state: \.pickTime, action: \.pickTime) {
                    PickTimeView(store: store)
                }
                
            case .pickVibe:
                
                if let store = path.scope(state: \.pickVibe, action: \.pickVibe) {
                    PickVibeView(store: store)
                }
            }
        }
        
        .animation(.easeOut, value: step)
        .animation(.easeOut, value: store.isShowingViews)
        .animation(.easeOut, value: store.isShowingPreview)
        .animation(.easeOut, value: store.isShowingButton)
        
        .onChange(of: step) {
            
            if step >= 4 {
                
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                    
                    store.send(.toggleViews(false))
                    
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                        
                        store.send(.toggleButton(true))
                        store.send(.togglePreview(true))
                    }
                }
                
            } else {
                store.send(.toggleButton(false))
            }
        }
        
        .preferredColorScheme(.dark)
    }
}

#Preview {
    StatusView(store: Store(initialState: StatusFeature.State(), reducer: {
        
        StatusFeature()
    }))
}

