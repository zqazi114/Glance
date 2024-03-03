//
//  StatusPreview.swift
//  Glance
//
//  Created by Z Q on 2/27/24.
//

import SwiftUI
import ComposableArchitecture


// MARK: - StatusPreview
struct StatusPreview: View {

    let status: Status
    
    var callback: () -> ()
    
    private var attributedString: AttributedString? {
        
        guard let name = status.location?.name,
              let time = status.time?.end.printable,
              let activity = status.activity?.id,
              let vibe = status.vibe?.title else {
            
            return nil
        }
        
        var a = AttributedString("I'm hanging out at ")
        a.font = .title3
        a.foregroundColor = .white
        
        var b = AttributedString("\(name) ")
        b.font = .title3
        b.foregroundColor = .accent
        
        var c = AttributedString("for another ")
        c.font = .title3
        c.foregroundColor = .white
        
        var d = AttributedString("\(time). ")
        d.font = .title3
        d.foregroundColor = .accent
        
        var e = AttributedString("\n\nLet's ")
        e.font = .title3
        e.foregroundColor = .white
        
        var f = AttributedString("\(activity.lowercased()). ")
        f.font = .title3
        f.foregroundColor = .accent
        
        var g = AttributedString("\n\nI'm feeling like ")
        g.font = .title3
        g.foregroundColor = .white
        
        var h = AttributedString("\(vibe.lowercased()).")
        h.font = .title3
        h.foregroundColor = .accent
        
        return a + b + c + d + e + f + g + h
    }
    
    // MARK: - body
    var body: some View {
        
        Button {
            callback()
            
        } label: {
            
            HStack(spacing: 0) {
                
                Spacer()
                
                if let attributedString = attributedString {
                    Text(attributedString)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(10)
                }
                
                Spacer()
            }
            .padding(.vertical)
            .padding(.horizontal, 10)
            .background {
                Color.white_button
            }
            .cornerRadius(20)
        }
        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .move(edge: .bottom)))
    }
}

#Preview {
    VStack {
        
        Spacer()
        
        StatusPreview(status: Status.TEST.randomElement()!, callback: {
            
        })
        
        Spacer()
    }
    .background {
        Color.black
            .ignoresSafeArea()
    }
}
