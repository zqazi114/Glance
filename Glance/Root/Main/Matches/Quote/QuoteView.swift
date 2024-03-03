//
//  QuoteView.swift
//  Glance
//
//  Created by Z Q on 2/28/24.
//

import SwiftUI
import ComposableArchitecture

// MARK: - QuoteView
struct QuoteView: View {
    
    let store: StoreOf<QuoteFeature>
    
    
    // MARK: - body
    var body: some View {
        
        VStack {
            
            if store.isShowing, let quote = store.quote {
                
                HStack {
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 10) {
                        
                        Text(quote.quote)
                            .font(.title3)
                            .fontWeight(.light)
                            .italic()
                            .lineSpacing(5.0)
                            .foregroundColor(.black)
                        
                        Text("- \(quote.author)")
                            .font(.caption)
                            .fontWeight(.light)
                            .foregroundColor(.black)
                    }
                    .padding()
                    
                    Spacer()
                }
                .background {
                    Color.white
                        .cornerRadius(20, corners: [.topLeft, .topRight])
                        .ignoresSafeArea(.container, edges: .bottom)
                }
                .transition(.push(from: .bottom))
            }
        }
        
        .animation(.default.delay(1.0), value: store.isShowing)
        
        .transition(.opacity)
        
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    VStack {
        
        Spacer()
        
        HStack { Spacer() }
        
        QuoteView(store: Store(initialState: QuoteFeature.State(), reducer: { QuoteFeature() }))
    }
    .background {
        Color.black
            .ignoresSafeArea()
    }
}
