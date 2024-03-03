//
//  Time.swift
//  Glance
//
//  Created by Z Q on 2/25/24.
//

import Foundation

// MARK: - Time
struct Time: Equatable {
    var start: Date
    var end: Date
    
    var preview: String {
        return "Around for the next \(end.printable)"
    }
}
extension Time {
    static var TEST: Time {
        return Time(
            start: Date().roundedDown!,
            end: Date(timeIntervalSinceNow: TimeInterval(Int.random(in: 1..<5)) * 60 * 60).roundedDown!)
    }
}

// MARK: - enum TimeOption
enum TimeOption: Int, Identifiable, CaseIterable {
    
    case oneHour = 1, twoHours = 2, custom = 3
    
    var description: String {
        switch self {
        case .oneHour:
            return "An hour"
        case .twoHours:
            return "Two hours"
        case .custom:
            return "Until"
        }
    }
    
    var id: Self { return self }
}
