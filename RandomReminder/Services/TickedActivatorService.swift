//
//  TickedActivatorService.swift
//  RandomReminder
//
//  Created by Luca Napoli on 27/1/2026.
//

import Foundation

final class TickedActivatorService: ReminderActivatorService {
    let reminder: RandomReminder
    var running = false
    var terminated = false

    private var reminderActivations: Int
    private let activationProbability: Float

    private let onReminderActivation: OnReminderActivation
    private let onReminderFinished: OnReminderFinished

    init(
        reminder: RandomReminder,
        every interval: ReminderTickInterval,
        onReminderActivation: @escaping OnReminderActivation,
        onReminderFinished: @escaping OnReminderFinished
    ) {
        self.reminder = reminder
        // Note: we cannot trust the value of reminder.counts.occurrences
        // for determining how many activations we must do (except for determining this value initially)
        // because this value (reminder occurrences) is incremented
        // when the notification disappears (as of now)
        self.reminderActivations = reminder.counts.occurrences
        self.onReminderActivation = onReminderActivation
        self.onReminderFinished = onReminderFinished

        self.activationProbability = (
            Float(reminder.counts.totalOccurrences) * Float(interval.seconds()) / Float(reminder.durationInSeconds())
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
        let isFinalActivation = reminderActivations == reminder.counts.totalOccurrences - 1
        if reminderWillActivate && isFinalActivation {
            reminderActivations += 1
            onReminderActivation()
            onReminderFinished()
            running = false
        } else if reminderWillActivate {
            reminderActivations += 1
            onReminderActivation()
        }
    }

    private func reminderWillActivate() -> Bool {
        Float.random(in: 0...1) < activationProbability
    }
}
