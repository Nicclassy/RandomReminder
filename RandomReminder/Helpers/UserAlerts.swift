//
//  UserAlerts.swift
//  RandomReminder
//
//  Created by Luca Napoli on 15/8/2025.
//

import Foundation
import UserNotifications

private enum SettingStatus: Equatable {
    case ok
    case warning(String)
    case error(String)
}

final class UserAlerts {
    static let shared = UserAlerts()
    private let notificationCenter: UNUserNotificationCenter = .current()
    
    private init() {}
    
    func alertsEnabled() async -> Bool {
        let settings = await notificationCenter.notificationSettings()
        return alertStyleStatus(settings: settings) == .ok && authorizationStatus(settings: settings) == .ok
    }
    
    private func alertStyleStatus(settings: UNNotificationSettings) -> SettingStatus {
        switch settings.alertStyle {
        case .none:
            .error("You will not receive notifications")
        case .banner:
            .warning("You will see banners")
        case .alert:
            .ok
        @unknown default:
            fatalError("Unknown alert style")
        }
    }
    
    private func authorizationStatus(settings: UNNotificationSettings) -> SettingStatus {
        switch settings.authorizationStatus {
        case .authorized:
            .ok
        case .provisional:
            .warning("Permissions are provisionally granted")
        case .denied:
            .error("Permissions were not given to receive notifications")
        case .notDetermined:
            .error("Permissions are yet to be determined")
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
}
