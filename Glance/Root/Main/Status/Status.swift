//
//  Status.swift
//  Glance
//
//  Created by Z Q on 2/28/24.
//

import Foundation

// MARK: - Status
struct Status: Equatable {
    
    var location: Location?
    var activity: Activity?
    var time: Time?
    var vibe: Vibe?
    
}
extension Status {
    static var TEST: [Status] {
        [
            Status(
                location: Location.TEST.randomElement(),
                activity: Activity.TEST.randomElement(),
                time: Time.TEST,
                vibe: Vibe.TEST
            ),
            Status(
                location: Location.TEST.randomElement(),
                activity: Activity.TEST.randomElement(),
                time: Time.TEST,
                vibe: Vibe.TEST
            ),
            Status(
                location: Location.TEST.randomElement(),
                activity: Activity.TEST.randomElement(),
                time: Time.TEST,
                vibe: Vibe.TEST
            ),
        ]
    }
}
