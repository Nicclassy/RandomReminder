//
//  RandomReminder.swift
//  RandomReminder
//
//  Created by Luca Napoli on 28/12/2024.
//

import Foundation

func reminderID() -> Int {
    defer {
        ReminderID.id += 1
    }
    return ReminderID.id
}

class ReminderID {
    static var quickReminder = 0
    static var id = 1
}

struct RandomReminder: Codable, CustomStringConvertible {
    var id: Int
    var content: ReminderContent
    var reminderInterval: AnyReminderInterval
    var counts: ReminderCounts
    var state: ReminderState
    var activationEvents: [ReminderActivationEvent]
    
    init(id: Int, 
         content: ReminderContent,
         reminderInterval: AnyReminderInterval,
         counts: ReminderCounts,
         state: ReminderState,
         activationEvents: [ReminderActivationEvent]) {
        self.id = id
        self.content = content
        self.reminderInterval = reminderInterval
        self.counts = counts
        self.state = state
        self.activationEvents = activationEvents
    }
    
    init(title: String,
         text: String,
         interval: ReminderInterval,
         totalReminders: Int,
         activationEvents: [ReminderActivationEvent]? = nil) {
        self.init(
            id: reminderID(),
            content: ReminderContent(title: title, text: text),
            reminderInterval: AnyReminderInterval(interval),
            counts: ReminderCounts(totalReminders: totalReminders),
            state: .disabled,
            activationEvents: activationEvents ?? []
        )
    }
    
    var description: String {
        self.content.title
    }
    
    var interval: ReminderInterval {
        // AnyReminderInterval is only for serialisation/deserialisation
        // so instead get the type-erased protocol value for operations
        self.reminderInterval.value
    }
    
    func durationInSeconds() -> Float {
        Float(self.interval.earliest.distance(to: self.interval.latest))
    }
    
    func isFinalActivation() -> Bool {
        self.counts.timesReminded == self.counts.totalReminders - 1
    }
    
    mutating func activate() {
        self.counts.timesReminded += 1
    }
    
    mutating func reset() {
        self.counts.timesReminded = 0
    }
}
