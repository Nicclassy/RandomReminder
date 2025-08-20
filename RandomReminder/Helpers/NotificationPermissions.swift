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
    private let appPreferences: AppPreferences = .shared

    private init() {}

    func showNotificationAlert(
        title: String,
        message: String,
        selector: Selector? = nil
    ) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "Open Settings")
        alert.addButton(withTitle: "Cancel")

        if let selector {
            let checkbox = NSButton(
                checkboxWithTitle: "Don't show this again",
                target: nil,
                action: selector
            )
            alert.accessoryView = checkbox
        }

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            openNotificationSettings()
        }
    }
    
    func promptIfAlertsNotEnabled() {
        Task {
            await promptIfAlertsNotEnabled(launch: true)
        }
    }

    @discardableResult
    func promptIfAlertsNotEnabled(launch: Bool = false) async -> Bool {
        let settings = await notificationCenter.notificationSettings()
        let authorizationStatus = authorizationStatus(settings, launch: launch)
        let alertStyleStatus = alertStyleStatus(settings, launch: launch)

        var alertTitle: String?
        var alertMessage: String?
        var selector: Selector?

        if case let .error(message) = authorizationStatus {
            alertTitle = "Notifications not enabled"
            alertMessage = message
        } else if case let .warning(message) = alertStyleStatus, !appPreferences.allowBanners {
            alertTitle = "Alerts are recommended"
            alertMessage = message
            selector = #selector(toggleAllowBanners)
        } else if case let .error(message) = alertStyleStatus {
            alertTitle = "Notifications will not appear"
            alertMessage = message
        }

        guard let alertTitle, let alertMessage else { return true }
            
        await MainActor.run { [selector] in
            showNotificationAlert(
                title: alertTitle,
                message: alertMessage,
                selector: selector
            )
        }
        
        return false
    }

    func alertsEnabled(launch: Bool) async -> Bool {
        let settings = await notificationCenter.notificationSettings()
        defer {
            assert(settings.alertSetting == .enabled)
        }
        return alertStyleStatus(settings, launch: launch) == .ok && authorizationStatus(settings, launch: launch) == .ok
    }

    func openNotificationSettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications") else {
            FancyLogger.error("Could not find url")
            return
        }

        NSWorkspace.shared.open(url)
    }

    private func alertStyleStatus(_ settings: UNNotificationSettings, launch: Bool) -> SettingStatus {
        switch settings.alertStyle {
        case .none:
            .error(
                launch ? L10n.NotificationPermissions.Launch.AlertStyle.none :
                L10n.NotificationPermissions.Notification.AlertStyle.none
            )
        case .banner:
            launch ? .warning(L10n.NotificationPermissions.Launch.AlertStyle.banner) : .ok
        case .alert:
            .ok
        @unknown default:
            fatalError("Unknown alert style")
        }
    }

    private func authorizationStatus(_ settings: UNNotificationSettings, launch: Bool) -> SettingStatus {
        switch settings.authorizationStatus {
        case .authorized, .provisional:
            .ok
        case .denied:
            .error(
                launch ? L10n.NotificationPermissions.Launch.AuthorisationStatus.denied :
                L10n.NotificationPermissions.Notification.AuthorisationStatus.denied
            )
        case .notDetermined:
            .error(
                launch ? L10n.NotificationPermissions.Launch.AuthorisationStatus.notDetermined :
                L10n.NotificationPermissions.Notification.AuthorisationStatus.notDetermined
            )
        @unknown default:
            fatalError("Unknown authorisation status")
        }
    }

    @objc
    private func toggleAllowBanners() {
        FancyLogger.info("Allow banners toggled")
        appPreferences.allowBanners.toggle()
    }
}
