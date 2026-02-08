//
//  ScheduledActivatorService.swift
//  RandomReminder
//
//  Created by Luca Napoli on 27/1/2026.
//

import Foundation

private func calculateActivationDates(for reminder: RandomReminder) -> [Date] {
    // Dates are spaced evenly; this activator is spaced and scheduled
    let startDate = max(reminder.interval.earliest, .now)
    let timeRemaining = reminder.interval.latest.timeIntervalSince(startDate)
    let activationDuration = timeRemaining / TimeInterval(reminder.counts.occurrencesLeft)

    return (0..<reminder.counts.occurrencesLeft).map { activationNumber in
        let start = startDate + activationDuration * TimeInterval(activationNumber)
        let end = start + activationDuration
        return Date(
            timeIntervalSince1970: .random(in: start.timeIntervalSince1970..<end.timeIntervalSince1970)
        )
    }
}

final class ScheduledActivatorService: ReminderActivatorService {
    let reminder: RandomReminder
    var running = false
    var terminated = false

    private let onReminderActivation: OnReminderActivation
    private let onReminderFinished: OnReminderFinished
    private var activationDates: [Date]
    private var reminderActivations: Int

    init(
        reminder: RandomReminder,
        onReminderActivation: @escaping OnReminderActivation,
        onReminderFinished: @escaping OnReminderFinished
    ) {
        self.reminder = reminder
        self.onReminderActivation = onReminderActivation
        self.onReminderFinished = onReminderFinished
        self.activationDates = calculateActivationDates(for: reminder)
        self.reminderActivations = reminder.counts.occurrences
    }

    func tick() {
        let upcomingDate = activationDates[0]
        guard !terminated else {
            FancyLogger.info("Activator for '\(reminder)' has been terminated")
            return
        }

        guard Date() >= upcomingDate else {
            FancyLogger.info("Did not activate '\(reminder)'")
            return
        }

        let isFinalActivation = reminderActivations == reminder.counts.totalOccurrences - 1
        if isFinalActivation {
            reminderActivations += 1
            FancyLogger.info(
                "Activated final reminder for '\(reminder)'",
                "(\(reminderActivations)/\(reminder.counts.totalOccurrences))"
            )
            onReminderActivation()
            onReminderFinished()
            running = false
        } else {
            reminderActivations += 1
            onReminderActivation()
            FancyLogger.info(
                "Activated '\(reminder)'",
                "(\(reminderActivations)/\(reminder.counts.totalOccurrences))!"
            )
        }

        activationDates.removeFirst()
    }
}
