//
//  Activity.swift
//  Glance
//
//  Created by Z Q on 2/25/24.
//

import Foundation


// MARK: - Activity
enum Activity: String, Identifiable, Codable, CaseIterable {
    
    case food, dancing, drinks
    
    var id: String {
        switch self {
            
        case .food:
            return "🍕 Get some food"
            
        case .dancing:
            return "🕺 Dance"
            
        case .drinks:
            return "🍻 Share a drink"
        }
    }
}
extension Activity {
    static var TEST: [Activity] {
        var all = Activity.allCases.shuffled()
        
        let n = Int.random(in: 0..<all.count)
        
        for _ in 0..<n {
            all.remove(at: 0)
        }
        
        return all
    }
}
