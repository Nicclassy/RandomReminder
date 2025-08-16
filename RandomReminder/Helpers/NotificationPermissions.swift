//
//  NotificationPermissions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 15/8/2025.
//

import SwiftUI
import UserNotifications

private enum SettingStatus: Equatable {
    case ok
    case warning(String)
    case error(String)
}

final class NotificationPermissions {
    static let shared = NotificationPermissions()
    private let notificationCenter: UNUserNotificationCenter = .current()

    private init() {}

    func showNotificationAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "Open Settings")
        alert.addButton(withTitle: "Cancel")
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            openNotificationSettings()
        }
    }

    func promptIfAlertsNotEnabled() {
        Task {
            let settings = await notificationCenter.notificationSettings()
            var alertTitle: String?
            var alertMessage: String?

            if case let .error(message) = authorizationStatus(settings) {
                alertTitle = "Notifications not enabled"
                alertMessage = message
            } else if case let .error(message) = alertStyleStatus(settings) {
                alertTitle = "Notifications will not appear"
                alertMessage = message
            }

            guard let alertTitle, let alertMessage else { return }
            await MainActor.run {
                showNotificationAlert(title: alertTitle, message: alertMessage)
            }
        }
    }

    func openNotificationSettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications") else {
            FancyLogger.error("Could not find url")
            return
        }

        NSWorkspace.shared.open(url)
    }

    func alertsEnabled() async -> Bool {
        let settings = await notificationCenter.notificationSettings()
        defer {
            assert(settings.alertSetting == .enabled)
        }
        return alertStyleStatus(settings) == .ok && authorizationStatus(settings) == .ok
    }

    private func alertStyleStatus(_ settings: UNNotificationSettings) -> SettingStatus {
        switch settings.alertStyle {
        case .none:
            .error(multilineString {
                "Notifications for RandomReminder are allowed but 'None' is currently set. "
                "It is recommended to change this setting to 'Alerts'."
            })
        case .banner:
            .warning(multilineString {
                "Notifications for RandomReminder are currently set to 'Banner'. "
                "Although notifications will function correctly, it is recommended to change this to 'Alerts'."
            })
        case .alert:
            .ok
        @unknown default:
            fatalError("Unknown alert style")
        }
    }

    private func authorizationStatus(_ settings: UNNotificationSettings) -> SettingStatus {
        switch settings.authorizationStatus {
        case .authorized, .provisional:
            .ok
        case .denied:
            .error(multilineString {
                "Notifications are disabled for RandomReminder. "
                "Enable notifications in System Settings to receive notifications for reminders."
            })
        case .notDetermined:
            .error(multilineString {
                "Notifications are yet to be set for RandomReminder. "
                "Enable notifications in System Settings to receive notifications for reminders."
            })
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
}
