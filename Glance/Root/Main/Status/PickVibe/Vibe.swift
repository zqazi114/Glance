//
//  Vibe.swift
//  Glance
//
//  Created by Z Q on 2/25/24.
//

import Foundation


// MARK: - Vibe
enum Vibe: String, Equatable, Identifiable, Codable, CaseIterable {
    case romantic, friendly
    
    var id: String {
        return self.rawValue
    }
    
    var title: String {
        switch self {
            
        case .romantic:
            return "Looking for the real one"
            
        case .friendly:
            return "Just chilling"
        }
    }
    
    var icon: String {
        switch self {
            
        case .romantic:
            return "💛"
            
        case .friendly:
            return "😇"
        }
    }
    
    var preview: String {
        "Feels like \(self.title.lowercased()) \(self.icon)"
    }
}
extension Vibe {
    static var TEST: Vibe {
        return Vibe.allCases[Int.random(in: 0..<Vibe.allCases.count)]
    }
}
