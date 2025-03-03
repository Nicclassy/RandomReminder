//
//  RandomReminder.swift
//  RandomReminder
//
//  Created by Luca Napoli on 28/12/2024.
//

import Foundation

final class RandomReminder: Codable {
    var id: ReminderID
    var content: ReminderContent
    var reminderInterval: AnyReminderInterval
    var days: ReminderDayOptions
    var counts: ReminderCounts
    var state: ReminderState
    var activationEvents: ReminderActivationEvents
    
    init(
        id: ReminderID,
        content: ReminderContent,
        reminderInterval: AnyReminderInterval,
        days: ReminderDayOptions,
        counts: ReminderCounts,
        state: ReminderState,
        activationEvents: ReminderActivationEvents
    ) {
        self.id = id
        self.content = content
        self.reminderInterval = reminderInterval
        self.days = days
        self.counts = counts
        self.state = state
        self.activationEvents = activationEvents
    }
    
    convenience init(
        id: ReminderID = ReminderManager.shared.nextAvailableId(),
        title: String,
        text: String,
        interval: ReminderInterval,
        days: ReminderDayOptions? = nil,
        totalOccurences: Int,
        activationEvents: ReminderActivationEvents? = nil
    ) {
        self.init(
            id: id,
            content: ReminderContent(title: title, text: text),
            reminderInterval: AnyReminderInterval(interval),
            days: days ?? [],
            counts: ReminderCounts(totalOccurences: totalOccurences),
            state: .enabled,
            activationEvents: activationEvents ?? ReminderActivationEvents()
        )
    }
    
    var interval: ReminderInterval {
        // AnyReminderInterval is only for serialisation/deserialisation
        // so instead get the type-erased protocol value for operations
        reminderInterval.value
    }
    
    func durationInSeconds() -> Float {
        Float(interval.earliest.distance(to: interval.latest))
    }
    
    func hasBegun() -> Bool {
        Date() >= interval.earliest
    }
    
    func hasPast() -> Bool {
        interval.isPast
    }
    
    func isFinalActivation() -> Bool {
        counts.occurences == counts.totalOccurences - 1
    }
    
    func activate() {
        counts.occurences += 1
    }
    
    func reset() {
        counts.occurences = 0
    }
}

extension RandomReminder {
    func filename() -> String {
        id.filename()
    }
}

extension RandomReminder: CustomStringConvertible {
    var description: String {
        content.title
    }
}

extension RandomReminder: Equatable, Hashable {
    static func == (lhs: RandomReminder, rhs: RandomReminder) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
