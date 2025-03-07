//
//  RandomReminder.swift
//  RandomReminder
//
//  Created by Luca Napoli on 28/12/2024.
//

import Foundation

final class RandomReminder: Codable {
    let id: ReminderID
    let content: ReminderContent
    let reminderInterval: AnyReminderInterval
    let days: ReminderDayOptions
    let activationEvents: ReminderActivationEvents
    var counts: ReminderCounts
    var state: ReminderState
    
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
    
    var hasBegun: Bool {
        Date() >= interval.earliest
    }
    
    var hasPast: Bool {
        interval.isPast
    }
    
    func durationInSeconds() -> Float {
        Float(interval.earliest.distance(to: interval.latest))
    }
    
    func activate() {
        counts.occurences += 1
    }
    
    func reset() {
        counts.occurences = 0
        state = .enabled
    }
}

extension RandomReminder {
    func compare(with other: RandomReminder) -> Bool {
        if hasPast != other.hasPast { hasPast }
        else if hasBegun != other.hasBegun { hasBegun }
        else if hasBegun && other.hasBegun { counts.occurences < other.counts.occurences }
        else if !hasBegun && !other.hasBegun { interval.earliest < other.interval.earliest }
        else if hasPast && other.hasPast { interval.latest < other.interval.latest }
        else { content.title < other.content.title }
    }
    
    func filename() -> String {
        URL(string: String(describing: id))!
            .appendingPathExtension(StoredReminders.fileExtension)
            .path()
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
