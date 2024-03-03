//
//  String.swift
//  Glance
//
//  Created by Z Q on 2/22/24.
//

import Foundation

// MARK: - extension String
extension String {
    
    var isValidName: Bool {
        return !self.isEmpty && self.rangeOfCharacter(from: .letters.inverted) == nil
    }
    
    var isValidUsername: Bool {
        let pattern = #"^[a-zA-Z-]"#//"+ ?.* [a-zA-Z-]+$"#
        
        return isValidRegex(content: self, pattern: pattern)
    }
    
    var isValidDate: Bool {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        if let date = formatter.date(from: self) {
            return true
        }
        
        return false
    }
    
    var toDate: Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        return formatter.date(from: self)
    }
    
    var isValidNumber: Bool {
        let pattern = #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
        
        return isValidRegex(content: self, pattern: pattern)
    }
    
    var isValidEmail: Bool {
        //let pattern = #"^\S+@\S+\.\S+$"#
        let pattern = #"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"#
        
        return isValidRegex(content: self, pattern: pattern)
    }
    
    var isValidPassword: Bool {
        let pattern = #"(?=.{8,})"# +  #"(?=.*[A-Z])"# + #"(?=.*[a-z])"# + #"(?=.*\d)"#
        
        return isValidRegex(content: self, pattern: pattern)
    }
    
    func isValidRegex(content: String, pattern: String) -> Bool {
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            return regex.numberOfMatches(in: content, options: .anchored, range: NSRange(location: 0, length: content.count)) >= 1
        }
        
        return false
    }
    
    static func languages() -> [String] {
        var languages = [String]()
        let currentLocale = NSLocale.current as NSLocale
        for languageCode in NSLocale.availableLocaleIdentifiers {
            if let name = currentLocale.displayName(forKey: NSLocale.Key.languageCode, value: languageCode), !languages.contains(name) {
                languages.append(name)
            }
        }
        
        return languages.sorted()
    }
    
    static func professions() -> [String] {
        return [
            "Artist",
            "Engineer",
            "Crafts",
            "Self-employed",
            "Student",
            "Entrepreneur",
            "Medical",
            "Law Enforcement",
            "Teacher",
            "Agriculture",
            "Finance",
            "Accountant",
            "Real Estate",
            "Other",
        ].sorted()
    }
    
    static func educations() -> [String] {
        return [
            "High School Diploma",
            "Homeschooled",
            "College",
            "Informal",
            "Other",
        ]
    }
}
