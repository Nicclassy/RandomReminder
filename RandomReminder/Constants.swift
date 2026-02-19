//
//  Constants.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import Foundation
import RegexBuilder
import SwiftUI

/// An implementation of C#'s null-coalescing assignment operator
infix operator ??=: AssignmentPrecedence

// swiftlint:disable:next static_operator
func ??= <T>(lhs: inout T?, rhs: T) {
    lhs = lhs ?? rhs
}

enum StoredReminders {
    static let fileExtension = "json"
    static let folderName = "reminders"
    static let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first!
        .appendingPathComponent(folderName)
    static let filenamePattern = Regex {
        /^(\d+)\./
        fileExtension
        /$/
    }
}

enum ReminderConstants {
    static let minOccurrences = 1
    static let maxOccurrences = 999

    static let reminderDayChunkSize = 3
}

enum ViewConstants {
    static let preferencesSpacing: CGFloat = 20
    static let optionsSectionSpacing: CGFloat = 20
    static let optionSpacing: CGFloat = 10
    static let horizontalSpacing: CGFloat = 10
    static let upcomingRemindersBeforeScroll: UInt = 3
    static let pastRemindersBeforeScroll: UInt = 2
    static let reminderRowHeight: CGFloat = 57.5
    static let reminderRowCornerRadius: CGFloat = 10

    static let reminderWindowWidth: CGFloat = 550
    static let reminderWindowHeight: CGFloat = 200

    static let mediumWindowWidth: CGFloat = 350
    static let mediumWindowHeight: CGFloat = 300

    static let modificationButtonSize: CGFloat = 60
    static let horizontalButtonSpace: CGFloat = 15
}

enum WindowIds {
    static let createReminder = "create-reminder"
    static let editReminder = "edit-reminder"
    static let reminderCommand = "reminder-command"
    static let activeReminder = "active-reminder"
    static let onboarding = "onboarding"
}

enum WindowTitles {
    static let createReminder = "Create New Reminder"
    static let modificationFirstStep = "Reminder Content"
    static let modificationFinalStep = "Reminder Settings"
    static let editReminder = "Edit Reminder"
    static let descriptionCommand = "Description Command"
    static let activationCommand = "Activation Command"
    static let reminderCommand = "Reminder Command"
    static let activeReminder = "Reminder Active"
    static let onboarding = "RandomReminder"
}

enum Constants {
    static let bundleID = "io.nicclassy.RandomReminder"
}
