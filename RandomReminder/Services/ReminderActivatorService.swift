//
//  ReminderActivatorService.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import Foundation
import SwiftUI

final class ReminderActivatorService {
    let reminder: RandomReminder
    let activationProbability: Float
    let endRemindersDate: Date
    
    var onReminderActivation: () -> Void = {}
    var running = true
    
    init(reminder: RandomReminder, every interval: ReminderTickInterval, onReminderActivation: @escaping () -> Void) {
        self.reminder = reminder
        self.onReminderActivation = onReminderActivation
        
        activationProbability = Float(reminder.counts.totalOccurences) * Float(interval.seconds()) / reminder.durationInSeconds()
        endRemindersDate = reminder.interval.latest.addMinutes(1)
    }
    
    func activate() {
        let activateReminder = activateReminder()
        if reminder.state != .started {
            FancyLogger.info("Reminder '\(reminder)' did not finish")
            onReminderActivation()
            running = false
        } else if activateReminder && reminder.counts.occurenceIsFinal {
            FancyLogger.info("Activated final reminder for '\(reminder)'")
            onReminderActivation()
            running = false
        } else if activateReminder {
            FancyLogger.info("Activated '\(reminder)'!")
            onReminderActivation()
        } else {
            FancyLogger.info("Did not activate '\(reminder)'")
        }
    }
    
    private func activateReminder() -> Bool {
        Float.random(in: 0...1) < activationProbability
    }
}
