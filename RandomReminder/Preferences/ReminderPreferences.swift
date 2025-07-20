//
//  ReminderPreferences.swift
//  RandomReminder
//
//  Created by Luca Napoli on 22/2/2025.
//

import Foundation
import SwiftUI

final class ReminderPreferences: ObservableObject {
    @Published var repeatingEnabled: Bool
    @Published var timesOnly: Bool
    @Published var alwaysRunning: Bool
    @Published var specificDays: Bool
    @Published var useAudioFile: Bool
    @Published var nonRandom: Bool
    @Published var occurAsap: Bool

    init(
        repeatingEnabled: Bool = false,
        timesOnly: Bool = false,
        alwaysRunning: Bool = false,
        specificDays: Bool = false,
        useAudioFile: Bool = false,
        nonRandom: Bool = false,
        occurAsap: Bool = false
    ) {
        self.repeatingEnabled = repeatingEnabled
        self.timesOnly = timesOnly
        self.alwaysRunning = alwaysRunning
        self.specificDays = specificDays
        self.useAudioFile = useAudioFile
        self.nonRandom = nonRandom
        self.occurAsap = occurAsap
    }

    convenience init(from reminder: RandomReminder) {
        self.init(
            repeatingEnabled: !reminder.interval.isInfinite && reminder.hasRepeats,
            timesOnly: reminder.interval is ReminderTimeInterval,
            alwaysRunning: reminder.interval.isInfinite,
            specificDays: !reminder.interval.isInfinite && !reminder.days.isEmpty,
            useAudioFile: reminder.activationEvents.audio != nil,
            nonRandom: !reminder.eponymous
        )
    }

    func copyFrom(reminder: RandomReminder) {
        repeatingEnabled = !alwaysRunning && reminder.hasRepeats
        timesOnly = reminder.interval is ReminderTimeInterval
        alwaysRunning = reminder.interval.isInfinite
        specificDays = !alwaysRunning && !reminder.days.isEmpty
        useAudioFile = reminder.activationEvents.audio != nil
        nonRandom = !reminder.eponymous
    }

    func reset() {
        repeatingEnabled = false
        timesOnly = false
        alwaysRunning = false
        specificDays = false
        useAudioFile = false
        nonRandom = false
    }
}
