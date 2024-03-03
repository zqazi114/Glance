//
//  City.swift
//  Glance
//
//  Created by Z Q on 2/23/24.
//

import Foundation

// MARK: - City
enum City: String, CustomStringConvertible, RawRepresentable, CaseIterable, Identifiable, Codable {
    case sanFrancisco, kualaLumpur, london, buenosAires
    
    var id: Self {
        return self
    }
    
    var description: String {
        switch self {
        case .sanFrancisco:
            return "San Francisco, U.S."
        case .kualaLumpur:
            return "Kuala Lumpur, Malaysia"
        case .london:
            return "London, U.K."
        case .buenosAires:
            return "Buenos Aires, Argentina"
        }
    }
}
