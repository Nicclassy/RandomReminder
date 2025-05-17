//
//  ReminderValidator.swift
//  RandomReminder
//
//  Created by Luca Napoli on 16/5/2025.
//

import Foundation

struct ValidationError {
    let alertText: String
    let messageText: String
}

struct ReminderValidator {
    let reminder: MutableReminder
    let preferences: ReminderPreferences
    let fields: ModificationViewFields

    func validate() -> ValidationError? {
        if fields.occurrencesText.isEmpty {
            return ValidationError(
                alertText: "Reminder occurrences is empty",
                messageText: "This field must not be left blank"
            )
        }

        if preferences.repeatingEnabled && fields.intervalQuantityText.isEmpty {
            return ValidationError(
                alertText: "Interval quantity is empty",
                messageText: "This field must not be left blank"
            )
        }

        if reminder.repeatIntervalType == .every && preferences.repeatingEnabled {
            let earliestDate = reminder.earliestDate
            let latestDate = reminder.latestDate
            let reminderDuration = latestDate.timeIntervalSince(earliestDate)
            let repeatIntervalDuration =
                reminder.repeatInterval.timeInterval() * TimeInterval(reminder.intervalQuantity)
            if reminderDuration > repeatIntervalDuration {
                return ValidationError(
                    alertText: "Reminder duration is too short",
                    messageText: "A reminder that repeats every fixed period must last at least as long as that period."
                )
            }
        }

        return nil
    }
}
