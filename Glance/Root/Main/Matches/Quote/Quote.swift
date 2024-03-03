//
//  Quote.swift
//  Glance
//
//  Created by Z Q on 2/28/24.
//

import Foundation

// MARK: - Quote
struct Quote: Equatable, Codable {
    
    var quote: String
    var author: String
    var category: String
    
}
extension Quote {
    static var TEST: [Quote] = [
        Quote(quote: "Most of life is just showing up", author: "Regina Brett", category: "alone"),
        Quote(quote: "Vulnerability is about showing up and being seen", author: "Brene Brown", category: "alone"),
    ]
}
