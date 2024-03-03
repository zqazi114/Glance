//
//  StatusField.swift
//  Glance
//
//  Created by Z Q on 2/27/24.
//

import SwiftUI

// MARK: - StatusHeader
struct StatusHeader: View {
    
    var type: StatusType
    var isFirstTimeAppearing: Bool
    
    @State private var isShowingInfo: Bool = false
    
    @State private var animationFrame: Int = 0
    private var animated_scale: CGFloat {
        switch animationFrame {
        case 0:
            return 1.0
        case 1:
            return 2.0
        case 2:
            return 2.0
        case 3:
            return 1.0
        default:
            return 1.0
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Button {
                withAnimation {
                    isShowingInfo.toggle()
                }
                
            } label: {
                
                HStack(alignment: .bottom) {
                    
                    Image(systemName: type.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: animated_scale * 30, height: animated_scale * 30)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(type.iconColors.0, type.iconColors.1)
                    
                    Text(type.title)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    Spacer()
                }
                
                Image(systemName: "info.circle")
            }
            
            if isShowingInfo {
                
                Text(type.info)
                    .font(.caption)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
            }
        }
        .padding(.top, 20)
        .onAppear {
            if isFirstTimeAppearing {
                F_animate()
            }
        }
    }
    
    // MARK: - F_animate
    private func F_animate() {
        
        let start = 0.5
        let delta = 0.25
        let middle = 0.5
        
        Timer.scheduledTimer(withTimeInterval: start, repeats: false) { timer in
            
            withAnimation(.easeOut) {
                animationFrame = 1
                
                withAnimation(.easeOut.delay(delta)) {
                    animationFrame = 2
                    
                    withAnimation(.easeOut.delay(delta + middle)) {
                        animationFrame = 3
                    }
                }
            }
        }
    }
}

// MARK: - StatusValue
struct StatusValue: View {
    
    var type: StatusType
    var value: String?
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 5) {
                
                Text(type.prompt)
                    .font(.title3)
                    .fontWeight(value == nil ? .bold : .light)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.white)
                
                if let value = value {
                    
                    Text(value)
                        .font(.title3)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.accent)
                    
                } else {
                    
                    GeometryReader { geo in
                        Color.white
                            .frame(width: geo.size.width/2, height: 2)
                            .frame(height: 30, alignment: .bottom)
                            .padding(.trailing, 40)
                    }
                    .frame(height: 30, alignment: .bottom)
                }
            }
            
            Spacer()
        }
        .padding()
        .background {
            value == nil ? Color.accent : Color.white_button
        }
        .cornerRadius(20)
    }
}

// MARK: - StatusField
struct StatusField: View {
    
    var type: StatusType
    var isFirstTimeAppearing: Bool
    var value: String?
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            StatusHeader(type: type, isFirstTimeAppearing: isFirstTimeAppearing)
            
            StatusValue(type: type, value: value)
        }
        .transition(.asymmetric(insertion: .push(from: .top), removal: .move(edge: .top)))
    }
}

#Preview {
    VStack {
        StatusField(type: .location, isFirstTimeAppearing: true, value: nil)
        
        Spacer()
    }
    .padding()
    .foregroundStyle(.white)
    .background {
        Color.black.ignoresSafeArea()
    }
}
