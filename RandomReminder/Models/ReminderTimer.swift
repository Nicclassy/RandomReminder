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
    let interval: DispatchTimeInterval
    let timer: DispatchSourceTimer
    
    var running: Bool = false
    var activated: Bool = false
    
    init(reminder: Reminder, every frequency: DispatchTimeInterval, onReminderActivation: @escaping () -> Void = {}) {
        self.reminder = reminder
        self.interval = frequency
        self.probability = frequency.seconds() / reminder.durationInSeconds()
        
        let queue = DispatchQueue(label: "ReminderTimerQueue-\(reminder.id)", qos: .background)
        self.timer = DispatchSource.makeTimerSource(queue: queue)
    }
    
    func activateReminder() -> Bool {
        Float.random(in: 0...1) < self.probability
    }
    
    func activate() {
        self.timer.schedule(deadline: .now(), repeating: interval)
        self.timer.setEventHandler { [weak self] in
            guard let self else { return }
            self.fire()
        }
        self.timer.activate()
    }
    
    func fire() {
        debug("Fired reminder '\(self.reminder.title)' (\(self.reminder.id))")
        if self.activateReminder() {
            debug("Reminder '\(self.reminder.title)' activated!")
            self.timer.cancel()
        } else if Date() >= self.reminder.latestDate {
            debug("Reminder '\(self.reminder.title)' was not activated.")
            self.timer.cancel()
        }
    }
}
