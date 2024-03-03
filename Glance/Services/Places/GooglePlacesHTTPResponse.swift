//
//  GooglePlacesHTTPResponse.swift
//  Glance
//
//  Created by Z Q on 2/25/24.
//

import Foundation

// MARK: - GooglePlacesHTTPResponse
struct GooglePlacesHTTPResponse: Codable {
    
    struct PlaceResult: Codable {
        
        struct PlacePhoto: Codable {
            var width: Int
            var height: Int
            var photo_reference: String
            var html_attributions: [String]
        }
        
        var place_id: String
        var name: String
        var types: [String]
        var rating: Double?
        var user_ratings_total: Int?
        var photos: [PlacePhoto]?
        var formatted_address: String?
    }
    
    var html_attributions: [String]
    var results: [PlaceResult]
    var status: String
}
