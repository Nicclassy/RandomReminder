//
//  ReminderTimerService.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import Foundation
import SwiftUI

final class ReminderActivatorService {
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
        self.probability = Float(reminder.counts.totalOccurences) * interval.seconds() / reminder.durationInSeconds()
    }
    
    func start() {
        self.thread = Thread { [unowned self] in
            let endRemindersDate = self.reminder.interval.latest.addMinutes(1)
            
            while self.running && Date() < endRemindersDate {
                let activateReminder = self.activateReminder()
                if activateReminder && self.reminder.isFinalActivation() {
                    FancyLogger.info("Activated final reminder for '\(self.reminder)'")
                    self.onReminderActivation()
                    self.stop()
                } else if activateReminder {
                    FancyLogger.info("Activated '\(self.reminder)'!")
                    self.onReminderActivation()
                } else {
                    FancyLogger.info("Retrying '\(self.reminder)'")
                    Thread.sleep(forTimeInterval: .init(self.interval.seconds()))
                }
            }
            
            if !self.finished {
                FancyLogger.info("Reminder '\(self.reminder)' did not finish")
                self.onReminderActivation()
                self.finished = true
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
        self.reminder.state = .enabled
    }
    
    private func activateReminder() -> Bool {
        Float.random(in: 0...1) < self.probability
    }
}
