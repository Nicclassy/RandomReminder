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
    var running = false
    var terminated = false

    private var reminderActivations: Int
    private let activationProbability: Float

    private let onReminderActivation: () -> Void
    private let onReminderFinished: () -> Void

    init(
        reminder: RandomReminder,
        every interval: ReminderTickInterval,
        onReminderActivation: @escaping () -> Void,
        onReminderFinished: @escaping () -> Void
    ) {
        self.reminder = reminder
        // Note: we cannot trust the value of reminder.counts.occurences
        // for determining how many activations we must do (except for determining this value initially)
        // because this value (reminder occurences) is incremented
        // when the notification disappears (as of now)
        self.reminderActivations = reminder.counts.occurences
        self.onReminderActivation = onReminderActivation
        self.onReminderFinished = onReminderFinished

        self.activationProbability = (
            Float(reminder.counts.totalOccurences) * Float(interval.seconds()) / reminder.durationInSeconds()
        )
        let endRemindersDate = reminder.interval.latest
        FancyLogger.info("Reminder '\(reminder)' ends at \(endRemindersDate)")
    }

    func tick() {
        guard !terminated else {
            FancyLogger.info("Activator for '\(reminder)' has been terminated")
            return
        }

        let reminderCanActivate = ReminderManager.shared.reminderCanActivate(reminder)
        let reminderWillActivate = reminderCanActivate && reminderWillActivate()
        let isFinalActivation = reminderActivations == reminder.counts.totalOccurences - 1
        if reminderWillActivate && isFinalActivation {
            reminderActivations += 1
            FancyLogger.info(
                "Activated final reminder for '\(reminder)'",
                "(\(reminderActivations)/\(reminder.counts.totalOccurences))"
            )
            onReminderActivation()
            onReminderFinished()
            running = false
        } else if reminderWillActivate {
            reminderActivations += 1
            onReminderActivation()
            FancyLogger.info(
                "Activated '\(reminder)'",
                "(\(reminderActivations)/\(reminder.counts.totalOccurences))!"
            )
        } else {
            FancyLogger.info("Did not activate '\(reminder)'")
        }
    }

    private func reminderWillActivate() -> Bool {
        Float.random(in: 0...1) < activationProbability
    }
}
