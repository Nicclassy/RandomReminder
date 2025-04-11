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
    
    @Published var showSpecificDaysPopover = false
    @Published var showTimesOnlyPopover = false
    @Published var showCancelPopover = false
    @Published var showFileImporter = false
    
    init(
        repeatingEnabled: Bool = false,
        timesOnly: Bool = false,
        alwaysRunning: Bool = false,
        specificDays: Bool = false,
        useAudioFile: Bool = false
    ) {
        self.repeatingEnabled = repeatingEnabled
        self.timesOnly = timesOnly
        self.alwaysRunning = alwaysRunning
        self.specificDays = specificDays
        self.useAudioFile = useAudioFile
    }
    
    func from(reminder: RandomReminder) -> Self {
        let alwaysRunning = if let interval = reminder.interval as? ReminderTimeInterval, interval.isInfinite {
            true
        } else {
            false
        }
        let repeatingEnabled = !alwaysRunning && reminder.interval.repeatInterval != .never
        let specificDays = !alwaysRunning && !reminder.days.isEmpty
        let useAudioFile = reminder.activationEvents.audio != nil
        return Self(
            repeatingEnabled: repeatingEnabled,
            alwaysRunning: alwaysRunning,
            specificDays: specificDays,
            useAudioFile: useAudioFile
        )
    }
}
