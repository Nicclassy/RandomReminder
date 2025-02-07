//
//  RandomReminder.swift
//  RandomReminder
//
//  Created by Luca Napoli on 28/12/2024.
//

import Foundation

final class RandomReminder: Codable, CustomStringConvertible {
    var id: ReminderID
    var content: ReminderContent
    var reminderInterval: AnyReminderInterval
    var counts: ReminderCounts
    var state: ReminderState
    var activationEvents: [ReminderActivationEvent]
    
    init(
        id: ReminderID,
        content: ReminderContent,
        reminderInterval: AnyReminderInterval,
        counts: ReminderCounts,
        state: ReminderState,
        activationEvents: [ReminderActivationEvent]
    ) {
        self.id = id
        self.content = content
        self.reminderInterval = reminderInterval
        self.counts = counts
        self.state = state
        self.activationEvents = activationEvents
    }
    
    convenience init(
        id: ReminderID = ReminderManager.shared.nextAvailableId(),
        title: String,
        text: String,
        interval: ReminderInterval,
        totalReminders: Int,
        activationEvents: [ReminderActivationEvent]? = nil
    ) {
        self.init(
            id: id,
            content: ReminderContent(title: title, text: text),
            reminderInterval: AnyReminderInterval(interval),
            counts: ReminderCounts(totalReminders: totalReminders),
            state: .enabled,
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
    
    func activate() {
        self.counts.timesReminded += 1
    }
    
    func reset() {
        self.counts.timesReminded = 0
    }
}

extension RandomReminder {
    func filename() -> String {
        URL(string: String(describing: self.id))!
            .appendingPathExtension(StoredReminders.fileExtension)
            .path()
    }
}

extension RandomReminder: Hashable, Equatable {
    static func == (lhs: RandomReminder, rhs: RandomReminder) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
