//
//  PropertyList.swift
//  Glance
//
//  Created by Z Q on 3/2/24.
//

import Foundation

// MARK: - PropertyList
struct PropertyList: Codable {
    var GOOGLE: String
    var QUOTES: String
}

// MARK: - PropertyListService
class PropertyListService {
    
    init?() {
        
        guard let filePath = Bundle.main.path(forResource: "Glance-Info", ofType: "plist") else {
            
            app_print("Could not find Glance-Info.plist in project")
            
            return nil
        }
        
        guard let xml = FileManager.default.contents(atPath: filePath) else {
            app_print("Could not read contents of Glance-Info.plist")
            return nil
        }
        
        guard let preferences = try? PropertyListDecoder().decode(PropertyList.self, from: xml) else {
            app_print("Could not decode contents of Glance-Info.plist")
            return nil
        }
        
        self.plist = preferences
    }
    
    var plist: PropertyList
}
