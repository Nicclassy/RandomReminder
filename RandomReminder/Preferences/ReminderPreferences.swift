//
//  ReminderPreferences.swift
//  RandomReminder
//
//  Created by Luca Napoli on 22/2/2025.
//

import SwiftUI

@Observable
final class ReminderPreferences {
    var repeatingEnabled: Bool
    var timesOnly: Bool
    var alwaysRunning: Bool
    var specificDays: Bool
    var useAudioFile: Bool
    var activationCommandEnabled: Bool
    var nonRandom: Bool
    var showWhenActive: Bool

    init(
        repeatingEnabled: Bool = false,
        timesOnly: Bool = false,
        alwaysRunning: Bool = false,
        specificDays: Bool = false,
        useAudioFile: Bool = false,
        activationCommandEnabled: Bool = false,
        nonRandom: Bool = false,
        showWhenActive: Bool = false
    ) {
        self.repeatingEnabled = repeatingEnabled
        self.timesOnly = timesOnly
        self.alwaysRunning = alwaysRunning
        self.specificDays = specificDays
        self.useAudioFile = useAudioFile
        self.activationCommandEnabled = activationCommandEnabled
        self.nonRandom = nonRandom
        self.showWhenActive = showWhenActive
    }

    convenience init(from reminder: RandomReminder) {
        self.init(
            repeatingEnabled: !reminder.interval.isInfinite && reminder.hasRepeats,
            timesOnly: reminder.interval is ReminderTimeInterval,
            alwaysRunning: reminder.interval.isInfinite,
            specificDays: !reminder.interval.isInfinite && !reminder.days.isEmpty,
            useAudioFile: reminder.activationEvents.audio != nil,
            activationCommandEnabled: reminder.activationEvents.command.isEnabled,
            nonRandom: !reminder.eponymous,
            showWhenActive: reminder.activationEvents.showWhenActive
        )
    }

    func copyFrom(reminder: RandomReminder) {
        repeatingEnabled = !alwaysRunning && reminder.hasRepeats
        timesOnly = reminder.interval is ReminderTimeInterval
        alwaysRunning = reminder.interval.isInfinite
        specificDays = !alwaysRunning && !reminder.days.isEmpty
        useAudioFile = reminder.activationEvents.audio != nil
        activationCommandEnabled = reminder.activationEvents.command.isEnabled
        nonRandom = !reminder.eponymous
        showWhenActive = reminder.activationEvents.showWhenActive
    }

    func reset() {
        repeatingEnabled = false
        timesOnly = false
        alwaysRunning = false
        specificDays = false
        useAudioFile = false
        activationCommandEnabled = false
        nonRandom = false
        showWhenActive = false
    }
}
