//
//  ReminderActivatorService.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import Foundation
import SwiftUI

private struct MutableReminderOperations {
    let reminder: RandomReminder
    let queue: DispatchQueue
    
    init(for reminder: RandomReminder) {
        self.reminder = reminder
        queue = DispatchQueue(label: Constants.bundleID + ".reminder\(reminder.id)Operations", attributes: .concurrent)
    }
    
    func setReminderState(to state: ReminderState) {
        queue.sync {
            reminder.state = state
        }
    }
    
    func resetReminder() {
        queue.sync {
            reminder.counts.occurences = 0
        }
    }
    
    func activateReminder() {
        queue.sync {
            reminder.counts.occurences += 1
        }
    }
}

final class ReminderActivatorService {
    let reminder: RandomReminder
    let activationProbability: Float
    let endRemindersDate: Date
    private let operations: MutableReminderOperations
    
    var onReminderActivation: () -> Void
    var running = false
    
    init(reminder: RandomReminder, every interval: ReminderTickInterval, onReminderActivation: @escaping () -> Void) {
        self.reminder = reminder
        self.operations = MutableReminderOperations(for: reminder)
        self.onReminderActivation = onReminderActivation
        
        activationProbability = (
            Float(reminder.counts.totalOccurences) * Float(interval.seconds()) / reminder.durationInSeconds()
        )
        endRemindersDate = reminder.interval.latest.addMinutes(1)
    }
    
    func start() {
        operations.setReminderState(to: .started)
        running = true
    }
    
    func stop() {
        operations.setReminderState(to: .finished)
        operations.resetReminder()
        running = false
    }
    
    func activate() {
        let reminderWillActivate = reminderWillActivate()
        if reminderWillActivate && reminder.counts.occurenceIsFinal {
            FancyLogger.info("Activated final reminder for '\(reminder)'")
            operations.activateReminder()
            onReminderActivation()
            stop()
        } else if reminderWillActivate {
            FancyLogger.info("Activated '\(reminder)'!")
            onReminderActivation()
        } else {
            FancyLogger.info("Did not activate '\(reminder)'")
        }
    }
    
    private func reminderWillActivate() -> Bool {
        Float.random(in: 0...1) < activationProbability
    }
}
