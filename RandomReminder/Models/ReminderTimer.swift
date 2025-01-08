//
//  ReminderTimer.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import Foundation
import SwiftUI

final class ReminderTimer: ObservableObject {
    var reminder: RandomReminder
    let interval: ReminderTickInterval
    let probability: Float
    
    var onReminderActivation: () -> Void
    var thread: Thread? = nil
    var running: Bool = true
    var finished: Bool = false
    
    init(reminder: RandomReminder, every interval: ReminderTickInterval, onReminderActivation: @escaping () -> Void = {}) {
        self.reminder = reminder
        self.interval = interval
        self.onReminderActivation = onReminderActivation
        self.probability = Float(reminder.totalReminders) * interval.seconds() / reminder.durationInSeconds()
    }
    
    func start() {
        // Start when appropriate time
        self.thread = Thread { [unowned self] in
            let endRemindersDate = self.reminder.interval.latest.addMinutes(1)
            
            while self.running && Date() < endRemindersDate {
                let activateReminder = self.activateReminder()
                let activateFinalReminder = (
                    activateReminder
                    && self.reminder.timesReminded == self.reminder.totalReminders - 1
                )
                if activateFinalReminder {
                    debug("Activated final reminder for '\(self.reminder.title)'")
                    self.onReminderActivation()
                    self.stop()
                } else if activateReminder {
                    debug("Activated '\(self.reminder.title)'!")
                    self.onReminderActivation()
                } else {
                    debug("Retrying '\(self.reminder.title)'")
                    Thread.sleep(forTimeInterval: .init(self.interval.seconds()))
                }
            }
            
            if !self.finished {
                debug("Reminder '\(self.reminder.title)' did not finish")
                self.finished = true
                self.onReminderActivation()
                self.stop()
            }
        }
        self.thread!.start()
    }
    
    func stop() {
        self.running = false
        self.finished = true
        self.thread!.cancel()
        self.thread = nil
        self.reminder.reset()
    }
    
    private func activateReminder() -> Bool {
        Float.random(in: 0...1) < self.probability
    }
}
