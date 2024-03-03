//
//  Encodable.swift
//  Glance
//
//  Created by Z Q on 2/23/24.
//

import Foundation

// MARK: - extension Encodable
extension Encodable {
    
    func toDict() throws -> [String : Any] {
        
        let encoder = JSONEncoder()
        
        let data = try encoder.encode(self)
        
        return try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as! [String : Any]
    }
}
