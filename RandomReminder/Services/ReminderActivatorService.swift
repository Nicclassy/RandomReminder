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

    private let activationProbability: Float
    private var reminderActivations: Int

    private let onReminderActivation: () -> Void
    private let onReminderFinished: () -> Void

    init(
        reminder: RandomReminder,
        every interval: ReminderTickInterval,
        onReminderActivation: @escaping () -> Void,
        onReminderFinished: @escaping () -> Void
    ) {
        self.reminder = reminder
        self.reminderActivations = reminder.counts.occurences
        self.onReminderActivation = onReminderActivation
        self.onReminderFinished = onReminderFinished

        self.activationProbability = (
            Float(reminder.counts.totalOccurences) * Float(interval.seconds()) / reminder.durationInSeconds()
        )
        // We do this so that the range is inclusive—[startDate, endDate]
        let endRemindersDate = reminder.interval.latest.addMinutes(1)
        FancyLogger.info("Reminder '\(reminder)' ends at \(endRemindersDate)")
    }

    func tick() {
        let reminderWillActivate = reminderWillActivate()
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
