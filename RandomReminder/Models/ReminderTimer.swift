//
//  ReminderTimer.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import Foundation
import SwiftUI

class ReminderTimer: ObservableObject {
    let reminder: Reminder
    let probability: Float
    let interval: ReminderTimeInterval
    
    var onReminderActivation: () -> Void
    var thread: Thread? = nil
    var running: Bool = true
    var activated: Bool = false
    
    init(reminder: Reminder, every interval: ReminderTimeInterval, onReminderActivation: @escaping () -> Void = {}) {
        self.reminder = reminder
        self.interval = interval
        self.onReminderActivation = onReminderActivation
        self.probability = interval.seconds() / reminder.durationInSeconds()
    }
    
    func start() {
        self.thread = Thread { [unowned self] in
            while self.running && Date() < self.reminder.latestDate {
                if self.activateReminder() {
                    debug("Activated '\(self.reminder.title)'!")
                    self.onReminderActivation()
                    self.stop()
                } else {
                    debug("Failed activation of \(self.reminder.title)")
                    Thread.sleep(forTimeInterval: .init(self.interval.seconds()))
                }
            }
            
            if !self.activated {
                self.onReminderActivation()
                self.stop()
            }
        }
        self.thread!.start()
    }
    
    func stop() {
        self.running = false
        self.activated = true
        self.thread?.cancel()
        self.thread = nil
    }
    
    private func activateReminder() -> Bool {
        Float.random(in: 0...1) < self.probability
    }
}
