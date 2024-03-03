//
//  ProgressViewModifier.swift
//  Glance
//
//  Created by Z Q on 2/16/24.
//

import SwiftUI

// MARK: ProgressViewModifier
struct ProgressViewModifier: ViewModifier {
    
    var isBusy: Bool
    
    func body(content: Content) -> some View {
        
        content
            .animation(.default, value: isBusy)
            .disabled(isBusy)
            .blur(radius: isBusy ? 3 : 0)
            .overlay {
                
                if isBusy {
                    ProgressView()
                        .preferredColorScheme(.light)
                        .scaleEffect(CGSize(width: 2.0, height: 2.0))
                }
            }
    }
}

// MARK: extension View
extension View {
    
    func progressView(_ isBusy: Bool) -> some View {
        modifier(ProgressViewModifier(isBusy: isBusy))
    }
}

// MARK: - ProgressViewModifier_Wrapper
struct ProgressViewModifier_Wrapper: View {
    
    @State private var isBusy: Bool = false
    
    // MARK: - body
    var body: some View {
        
        VStack {
            Spacer()
            
            Button {
                isBusy.toggle()
                
            } label: {
                Text("Hello, World! Hello, World! Hello, World!\nHello, World! Hello, World! Hello, World!\nHello, World! Hello, World! Hello, World!\nHello, World! Hello, World! Hello, World!\n")
                    .lineSpacing(20.0)
                    .font(.largeTitle)
            }
            
            HStack {
                Spacer()
            }
            
            Spacer()
        }
        .progressView(isBusy)
    }
}

#Preview {
    ProgressViewModifier_Wrapper()
}
