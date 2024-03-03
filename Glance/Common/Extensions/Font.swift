//
//  Font.swift
//  Check
//
//  Created by Z Q on 12/6/23.
//

import SwiftUI

// MARK: - extension Font
extension Font {
    static let app_logo = Font.custom("RiftSoft-BoldItalic",    size: 64.0)
    static let app_title = Font.custom("RiftSoft-BoldItalic",    size: 32.0)
}

// MARK: - Font_Wrapper
struct Font_Wrapper: View {
    
    var body: some View {
        
        VStack {
            
            Text("GLANCE")
                .font(.app_logo)
            
            Text("GLANCE")
                .font(.app_title)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    Font_Wrapper()
}
