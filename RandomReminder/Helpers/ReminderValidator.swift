//
//  ReminderValidator.swift
//  RandomReminder
//
//  Created by Luca Napoli on 16/5/2025.
//

import Foundation

enum ValidationResult {
    case unset
    case success
    case warning(alertText: String, messageText: String)
    case error(alertText: String, messageText: String)

    var alertText: String {
        switch self {
        case .success, .unset: ""
        case let .warning(alertText, _): alertText
        case let .error(alertText, _): alertText
        }
    }

    var messageText: String {
        switch self {
        case .success, .unset: ""
        case let .warning(_, messageText): messageText
        case let .error(_, messageText): messageText
        }
    }
}

struct ReminderValidator {
    let reminder: MutableReminder
    let preferences: ReminderPreferences
    let fields: ModificationViewFields

    func validate() -> ValidationResult {
        if fields.occurrencesText.isEmpty {
            .error(
                alertText: "Reminder occurrences is empty",
                messageText: "This field must not be left blank"
            )
        } else if preferences.repeatingEnabled && fields.intervalQuantityText.isEmpty {
            .error(
                alertText: "Interval quantity is empty",
                messageText: "This field must not be left blank"
            )
        } else if reminderDurationIsTooShort() {
            .error(
                alertText: "Reminder duration is too short",
                messageText: "A reminder that repeats every fixed period must last at least as long as that period"
            )
        } else if reminderWillNeverHappen() {
            .error(
                alertText: "Reminder will never happen",
                messageText: "The specific days option is enabled, but no days have been selected"
            )
        } else if reminderHasAlreadyHappened() {
            .error(
                alertText: "Reminder occurs in the past",
                messageText: "Reminders cannot have a latest time or date in the past"
            )
        } else if reminderWithSameTitleExists() {
            .warning(
                alertText: "A reminder already exists with the title '\(reminder.title)'",
                messageText: "Are you sure you want to create a new reminder with the same title?"
            )
        } else {
            .success
        }
    }

    private func reminderDurationIsTooShort() -> Bool {
        guard !preferences.nonRandom else {
            return false
        }

        guard reminder.repeatIntervalType == .every && preferences.repeatingEnabled else {
            return false
        }

        let earliestDate = reminder.earliestDate
        let latestDate = reminder.latestDate
        let reminderDuration = latestDate.timeIntervalSince(earliestDate)
        let repeatIntervalDuration =
            reminder.repeatInterval.timeInterval * TimeInterval(reminder.intervalQuantity)
        return reminderDuration > repeatIntervalDuration
    }

    private func reminderWithSameTitleExists() -> Bool {
        let isEditingThisReminder = ReminderModificationController.shared.isEditingReminder(with: reminder.id)
        let reminderWithSameTitleExists = ReminderManager.shared.reminderWithSameTitleExists(as: reminder.title)
        return !isEditingThisReminder && reminderWithSameTitleExists
    }

    private func reminderHasAlreadyHappened() -> Bool {
        if preferences.nonRandom {
            Date() >= reminder.earliestDate
        } else {
            Date() >= reminder.latestDate
        }
    }

    private func reminderWillNeverHappen() -> Bool {
        reminder.days.isEmpty && preferences.specificDays
    }
}
