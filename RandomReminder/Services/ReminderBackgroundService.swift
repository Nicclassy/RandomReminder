//
//  ReminderBackgroundService.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import Foundation
import SwiftUI

final class ReminderBackgroundService {
    let reminder: RandomReminder
    let tickInterval: ReminderTickInterval
    let activationProbability: Float
    
    var onReminderActivation: () -> Void
    var thread: Thread? = nil
    var running: Bool = true
    var finished: Bool = false
    
    init(reminder: RandomReminder, every tickInterval: ReminderTickInterval, onReminderActivation: @escaping () -> Void = {}) {
        self.reminder = reminder
        self.tickInterval = tickInterval
        self.onReminderActivation = onReminderActivation
        activationProbability = Float(reminder.counts.totalOccurences) * Float(tickInterval.seconds()) / reminder.durationInSeconds()
    }
    
    func start() {
        thread = Thread { [unowned self] in
            let endRemindersDate = reminder.interval.latest.addMinutes(1)
            let tickIntervalSeconds = tickInterval.seconds()
            
            while running && Date() < endRemindersDate {
                let activateReminder = activateReminder()
                if activateReminder && reminder.counts.occurenceIsFinal {
                    FancyLogger.info("Activated final reminder for '\(reminder)'")
                    onReminderActivation()
                    stop()
                } else if activateReminder {
                    FancyLogger.info("Activated '\(reminder)'!")
                    onReminderActivation()
                } else {
                    FancyLogger.info("Retrying '\(reminder)'")
                    Thread.sleep(forTimeInterval: tickIntervalSeconds)
                }
            }
            
            if !finished {
                FancyLogger.info("Reminder '\(reminder)' did not finish")
                onReminderActivation()
                stop()
            }
        }
        thread!.start()
    }
    
    func stop() {
        running = false
        finished = true
        thread!.cancel()
        thread = nil
        reminder.reset()
    }
    
    private func activateReminder() -> Bool {
        Float.random(in: 0...1) < activationProbability
    }
}
