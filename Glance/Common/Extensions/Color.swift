//
//  Color.swift
//  Glance
//
//  Created by Z Q on 2/23/24.
//

import SwiftUI

// MARK: - extension Color
extension Color {
    
    static let accent: Color                = Color(red: 255.0/255.0, green: 160.0/255.0, blue: 39.0/255.0)
    static let accentRed: Color             = Color(red: 255.0/255.0, green: 105.0/255.0, blue: 97.0/255.0)
    static let background: Color            = Color.black
    static let white_buttonSelected: Color  = .accent.opacity(0.3)
    static let white_button: Color          = Color.white.opacity(0.3)
    static let white_textField: Color       = Color.white.opacity(0.2)
}

// MARK: - Color_Wrapper
struct Color_Wrapper: View {
    
    var body: some View {
        
        VStack {
            
            Color.accent
                .frame(height: 40)
                .clipShape(Capsule())
            
        }
    }
}

#Preview {
    Color_Wrapper()
}
