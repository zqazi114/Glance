//
//  Date.swift
//  Glance
//
//  Created by Z Q on 2/22/24.
//

import Foundation

// MARK: - extension TimeInterval
extension TimeInterval {
    var remaining: String {
        let days = Int(self) / (24 * 60 * 60)
        
        if days >= 2 {
            return "\(days) more days"
            
        } else {
            
            //let hours = (Int(self) % (24 * 60 * 60)) / (60 * 60)
            let hours = Int(self) / (60 * 60)
            let minutes = (Int(self) % (60 * 60)) / 60
            let seconds = Int(self) % 60
            
            return "\(hours)h " +
            "\(minutes >= 10 ? "\(minutes)" : "0\(minutes)")m " +
            "\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")s"
        }
    }
}

// MARK: - extension Date
extension Date {
    
    var age: Int {
        
        let year = Calendar.current.component(.year, from: self)
        let thisYear = Calendar.current.component(.year, from: Date())
        
        return thisYear - year
    }
    
    var isLegalAge: Bool {
        age >= 18
    }
    
    var roundedUp: Date? {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        
        if !(components.minute == 0 && components.second == 0 && components.nanosecond == 0) {
            
            components.hour = components.hour! + 1
            components.minute = 0
            components.second = 0
            components.nanosecond = 0
        }
        
        return Calendar.current.date(from: components)
    }
    
    var roundedDown: Date? {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        
        return Calendar.current.date(from: components)
    }
    
    private var hoursFromNow: Int {
        let diff = self.timeIntervalSinceNow + 60 * 60
        return Int(diff / (60 * 60) + (diff > 0 ? 0 : -1))
    }
    
    private var minutesFromNow: Int {
        let diff = self.timeIntervalSinceNow
        return Int(diff / (60) + (diff > 0 ? 0 : -1))
    }
    
    var printable: String {
        let diff = self.timeIntervalSinceNow
        
        if diff > 48 * 60 * 60 {
            let formatter = DateFormatter()
            formatter.dateFormat = "h a, MMM d"
            
            return "at \(formatter.string(from: self))"
            
        } else if diff < 48 * 60 * 60, diff > 24 * 60 * 60 {
            return "Tomorrow"
            
        } else if diff < 24 * 60 * 60, diff > 0 {
            return "in \(self.hoursFromNow)h"
            
        } else if diff < 0, diff > -1 * 60 * 60 {
            return "\(-self.minutesFromNow)m ago"
            
        }  else if diff < -1 * 60 * 60, diff > -24 * 60 * 60 {
            return "\(-self.hoursFromNow)h ago"
            
        } else if diff > -48 * 60 * 60 {
            return "Yesterday"
            
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "h a, MMM d"
            
            return "at \(formatter.string(from: self))"
        }
    }
}
