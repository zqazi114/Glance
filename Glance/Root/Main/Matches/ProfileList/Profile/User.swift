//
//  UserModel.swift
//  Glance
//
//  Created by Z Q on 2/16/24.
//

import Foundation
import FirebaseFirestore

// MARK: - User
struct User: Identifiable, Equatable, Codable {
    
    @DocumentID var id: String?
    
    var name: String
    var dob: Date
    var city: City
    var profilePictureURL: String
    var pictureURLs: [String]
}

extension User {
    static var TEST: [User] {
        return [
            User(id: UUID().uuidString, name: "Test 1", dob: Date(), city: .london, profilePictureURL: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", pictureURLs: []),
            
            User(id: UUID().uuidString, name: "Test 2", dob: Date(), city: .buenosAires, profilePictureURL: "https://images.unsplash.com/photo-1605993439219-9d09d2020fa5?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", pictureURLs: []),
        ]
    }
}
