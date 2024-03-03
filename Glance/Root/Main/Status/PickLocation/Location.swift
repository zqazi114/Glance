//
//  Location.swift
//  Glance
//
//  Created by Z Q on 2/23/24.
//

import Foundation
import SwiftUI


// MARK: - LocationType
enum LocationType: String, CustomStringConvertible, Identifiable, Equatable, Codable, CaseIterable {
    
    case restaurant, bar, club
    
    var id: Self {
        return self
    }
    
    var description: String {
        switch self {
        case .restaurant:
            return "Restaurant"
        case .bar:
            return "Bar"
        case .club:
            return "Club"
        }
    }
}

// MARK: - Location
struct Location: Identifiable, Equatable, Codable {
    
    enum Status: String, CustomStringConvertible, Equatable, Codable, CaseIterable {
        
        case popping, busy, decent, dead
        
        var description: String {
            switch self {
            case .popping:
                return "Popping 🔥"
            case .busy:
                return "Busy 📈"
            case .decent:
                return "Decent 🍕"
            case .dead:
                return "Dead 💀"
            }
        }
        
        var color: Color {
            switch self {
            case .popping:
                return .red.opacity(0.7)
            case .busy:
                return .orange.opacity(0.7)
            case .decent:
                return .yellow.opacity(0.7)
            case .dead:
                return .gray.opacity(0.7)
            }
        }
    }
    
    var id: String = UUID().uuidString
    
    var name: String
    var type: LocationType
    var address: String
    var rating: CGFloat
    var stars: Int
    var reviews: Int
    var operation: String
    var close: String
    var status: Status
    var image: String
    
    init(name: String, type: LocationType, address: String, rating: CGFloat, stars: Int, reviews: Int, operation: String, close: String, status: Status, image: String) {
        self.name = name
        self.type = type
        self.address = address
        self.rating = rating
        self.stars = stars
        self.reviews = reviews
        self.operation = operation
        self.close = close
        self.status = status
        self.image = image
    }
    
    init(placeResult: GooglePlacesHTTPResponse.PlaceResult) {
        self.id = placeResult.place_id
        self.name = placeResult.name
        self.type = LocationType(rawValue: placeResult.types.first ?? "bar") ?? .bar
        self.address = placeResult.formatted_address ?? "na"
        self.rating = placeResult.rating ?? 0.0
        self.stars = Int(self.rating)
        self.reviews = placeResult.user_ratings_total ?? -1
        self.operation = "Open"
        self.close = "12am"
        self.status = Status.allCases.randomElement() ?? .popping
        self.image = ""
    }
}

// MARK: - extension Location
extension Location {
    static var TEST: [Location] {
        return [
            Location(
                name: "Drink drink @ Stand S",
                type: .bar,
                address: "Bandar Sri Damansara, 52200 Kuala Lumpur, Federal Territory of Kuala Lumpur",
                rating: 4.1,
                stars: 4,
                reviews: 18,
                operation: "Open",
                close: "2am",
                status: .popping,
                image: "bar1"),
            
            Location(
                name: "The BARRATS",
                type: .bar,
                address: "B-G-23 13A Dataran Cascades, 5, Jalan PJU 5/1, Kota Damansara, 47810 Petaling Jaya, Selangor",
                rating: 4.0,
                stars: 4,
                reviews: 16,
                operation: "Open",
                close: "12am",
                status: .busy,
                image: "bar2"),
            
            Location(
                name: "BT2 Karaoke Bar",
                type: .club,
                address: "B-F-12, BLOCK B ATIVO PLAZA JALAN PJU 9/1, DAMANSARA AVENUE 52200 PETALING JAYA, Bandar Sri Damansara, 52200 Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur",
                rating: 4.9,
                stars: 5,
                reviews: 31,
                operation: "Open",
                close: "12am",
                status: .decent,
                image: "bar3"),
            
            Location(
                name: "Shamrock TTDI",
                type: .restaurant,
                address: "No62, Lorong Rahim Kajai 14, Taman Tun Dr Ismail, 60000 Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur",
                rating: 4.1,
                stars: 4,
                reviews: 141,
                operation: "Open",
                close: "1am",
                status: .dead,
                image: "bar4"),
        ]
    }
}
