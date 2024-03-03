//
//  StatusType.swift
//  Glance
//
//  Created by Z Q on 2/28/24.
//

import Foundation
import SwiftUI


// MARK: - StatusType
enum StatusType: String, Identifiable {
    
    case location, time, activity, vibe
    
    var id: String {
        return self.rawValue
    }
    
    var title: String {
        return self.rawValue.uppercased()
    }
    
    var icon: String {
        switch self {
            
        case .location:
            return "mappin.and.ellipse"
            
        case .time:
            return "clock"
            
        case .activity:
            return "figure.walk.motion"
            
        case .vibe:
            return "face.dashed.fill"
        }
    }
    
    var iconColors: (Color, Color) {
        switch self {
            
        case .location:
            return (Color.accent, .white)
            
        case .time:
            return (.white, Color.accent)
            
        case .activity:
            return (Color.accent, .white)
            
        case .vibe:
            return (Color.accent, .white)
        }
    }
    
    var info: String {
        switch self {
            
        case .location:
            return "Set your location for the next 2 hours to check who's around"
            
        case .time:
            return "Set how long you're planning on sticking around"
            
        case .activity:
            return "Set what you're looking to do"
            
        case .vibe:
            return "Set your vibe so you match with people looking for the same thing"
        }
    }
    
    var prompt: String {
        switch self {
            
        case .location:
            return "I'm hanging out at"
            
        case .time:
            return "I'll be here for another"
            
        case .activity:
            return "Let's"
            
        case .vibe:
            return "I'm feeling like"
        }
    }
}
