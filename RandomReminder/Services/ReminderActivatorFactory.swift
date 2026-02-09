//
//  ReminderActivatorFactory.swift
//  RandomReminder
//
//  Created by Luca Napoli on 27/1/2026.
//

import Foundation

enum ActivatorType {
    case ticked
    case scheduled
}

final class ReminderActivatorFactory {
    let tickInterval: ReminderTickInterval
    let activatorType: ActivatorType

    init(tickInterval: ReminderTickInterval, activatorType: ActivatorType = .scheduled) {
        self.tickInterval = tickInterval
        self.activatorType = activatorType
    }

    func createActivator(for reminder: RandomReminder) -> ReminderActivatorService {
        switch activatorType {
        case .ticked:
            TickedActivatorService(
                reminder: reminder,
                every: tickInterval,
                onReminderActivation: onReminderActivation(reminder),
                onReminderFinished: onReminderFinished(reminder)
            )
        case .scheduled:
            ScheduledActivatorService(
                reminder: reminder,
                onReminderActivation: onReminderActivation(reminder),
                onReminderFinished: onReminderFinished(reminder)
            )
        }
    }

    private func onReminderActivation(_ reminder: RandomReminder) -> OnReminderActivation {
        { ActiveReminderManager.shared.activateReminder(reminder) }
    }

    private func onReminderFinished(_ reminder: RandomReminder) -> OnReminderFinished {
        { ActiveReminderManager.shared.deactivateReminder(reminder) }
    }
}
