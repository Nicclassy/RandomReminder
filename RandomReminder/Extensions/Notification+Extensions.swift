//
//  Notification+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 28/4/2025.
//

import Foundation

extension Notification.Name {
    static let refreshReminders = Self("refreshReminders")
    static let refreshModificationWindow = Self("refreshModificationWindow")
    static let updateReminderPreferencesText = Self("updateReminderPreferencesText")
    static let openActiveReminderWindow = Self("openActiveReminderWindow")
    static let dismissActiveReminderWindow = Self("dismissActiveReminderWindow")
}
