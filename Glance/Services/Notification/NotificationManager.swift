//
//  NotificationHelper.swift
//  Glance
//
//  Created by Z Q on 2/29/24.
//

import Foundation
import Combine
import UserNotifications
import SwiftUI
import ComposableArchitecture

// MARK: - NotificationHelperProtocol
protocol NotificationHelperProtocol {
    
    static var shared: NotificationHelper { get }
    
    var newUsersSubject: PassthroughSubject<[String], Never> { get set}
    
    func newUsersNearby(uids: [String])
    func scheduleLocalNotification(title: String, body: String, userInfo: [String : Any]?, delay: TimeInterval)
}

// MARK: - NotificationHelper
class NotificationHelper: NotificationHelperProtocol {
    
    static var shared: NotificationHelper = {
        NotificationHelper()
    }()
    
    var newUsersSubject: PassthroughSubject<[String], Never>
    
    private init() {
        self.newUsersSubject = .init()
    }
    
    // MARK: - newUsersNearby
    func newUsersNearby(uids: [String]) {
        
        newUsersSubject.send(uids)
    }
    
    
    // MARK: - scheduleLocalNotification
    func scheduleLocalNotification(title: String, body: String, userInfo: [String : Any]? = nil, delay: TimeInterval = 5.0) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.userInfo = userInfo ?? [:]
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

// MARK: - QuotesServiceKey
struct NotificationHelperKey: EnvironmentKey {
    static var defaultValue = NotificationHelper.shared
}

// MARK: - extension EnvironmentValues
extension EnvironmentValues {
    
    var notificationHelper: NotificationHelper {
        get { self[NotificationHelperKey.self] }
        set { self[NotificationHelperKey.self] = newValue }
    }
}

// MARK: - extension NotificationHelper
extension NotificationHelper: DependencyKey {
    
    static let liveValue: NotificationHelper = NotificationHelper.shared
    static let testValue: NotificationHelper = NotificationHelper.shared
}


// MARK: - extension DependencyValues
extension DependencyValues {
    
    var notificationHelper: NotificationHelper {
        get { self[NotificationHelper.self] }
        set { self[NotificationHelper.self] = newValue }
    }
}
