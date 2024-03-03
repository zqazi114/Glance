//
//  QuotesService_Wrapper.swift
//  Glance
//
//  Created by Z Q on 2/28/24.
//

import SwiftUI

struct QuotesService_Wrapper: View {
    
    @Environment(\.quotesService) var quotesService
    
    @State private var quote: Quote? = nil
    @State private var isBusy: Bool = false
    @State private var count: Int = 0
    
    var body: some View {
        
        VStack {
            
            Button {
                isBusy = true
                
                quotesService.fetch(category: .alone)
                
            } label: {
                Text("Fetch Quote")
            }
            
            Text("\(count)")
            
            if let quote = quote {
                Text(quote.quote)
            }
        }
        .onReceive(quotesService.publisher) { quotes in
            self.quote = quotes.first
            
            isBusy = false
            count += 1
        }
        
        .progressView(isBusy)
    }
}

#Preview {
    QuotesService_Wrapper()
}
