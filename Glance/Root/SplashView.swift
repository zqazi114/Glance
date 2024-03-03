//
//  SplashView.swift
//  Glance
//
//  Created by Z Q on 2/19/24.
//

import SwiftUI


// MARK: - SplashView
struct SplashView: View {
    
    @State private var isAnimating: Bool = false
    
    // MARK: - body
    var body: some View {
        
        VStack {
            
            Spacer()
            
            HStack(spacing: 18) {
                
                Spacer()
                
                Image("eye left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .opacity(isAnimating ? 0.0 : 1.0)
                
                Text("GLANCE")
                    .font(.app_logo)
                
                Image("eye right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .opacity(isAnimating ? 0.0 : 1.0)
                
                Spacer()
            }
            
            Spacer()
        }
        .foregroundColor(isAnimating ? Color.background : Color.white)
        .background {
            isAnimating ? Color.white.ignoresSafeArea() : Color.background.ignoresSafeArea()
        }
        .onAppear {
            
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                F_animateBlink()
                
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                    F_animateBlink()
                }
            }
        }
    }
    
    // MARK: - F_animateBlink
    private func F_animateBlink() {
        
        let duration: CGFloat = 0.2
        
        withAnimation(.linear(duration: duration)) {
            isAnimating.toggle()
        }
        
        withAnimation(.linear(duration: duration).delay(duration * 2)) {
            isAnimating.toggle()
        }
    }
}

#Preview {
    SplashView()
}
