//
//  AppDelegate.swift
//  Glance
//
//  Created by Z Q on 2/16/24.
//

import SwiftUI

// MARK: - AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseService.configure()
        GooglePlacesService.shared.configure()
        
        return true
    }
}
