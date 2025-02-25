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
        totalReminders: Int,
        activationEvents: ReminderActivationEvents? = nil
    ) {
        self.init(
            id: id,
            content: ReminderContent(title: title, text: text),
            reminderInterval: AnyReminderInterval(interval),
            days: days ?? [],
            counts: ReminderCounts(totalReminders: totalReminders),
            state: .enabled,
            activationEvents: activationEvents ?? ReminderActivationEvents()
        )
    }
    
    var description: String {
        content.title
    }
    
    var interval: ReminderInterval {
        // AnyReminderInterval is only for serialisation/deserialisation
        // so instead get the type-erased protocol value for operations
        reminderInterval.value
    }
    
    func durationInSeconds() -> Float {
        Float(interval.earliest.distance(to: interval.latest))
    }
    
    func isPast() -> Bool {
        Date() > interval.latest
    }
    
    func isFinalActivation() -> Bool {
        counts.timesReminded == counts.totalReminders - 1
    }
    
    func activate() {
        counts.timesReminded += 1
    }
    
    func reset() {
        counts.timesReminded = 0
    }
}

extension RandomReminder {
    func filename() -> String {
        URL(string: String(describing: id))!
            .appendingPathExtension(StoredReminders.fileExtension)
            .path()
    }
        
    func timeDifferenceInfo() -> String {
        func pluralisedName(component: Calendar.Component, quantity: UInt) -> String {
            let name = String(describing: component)
            let suffix = quantity != 1 ? "s" : ""
            return "\(quantity) \(name)\(suffix)"
        }
        
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: interval.earliest)
        if let days = components.day, days >= 7 {
            return ">1 week"
        }
        
        var parts: [String] = []
        if let days = components.day?.magnitude, days > 0 {
            parts.append(pluralisedName(component: .day, quantity: days))
        } 
        if let hours = components.hour?.magnitude, hours > 0 {
            parts.append(pluralisedName(component: .hour, quantity: hours))
        } 
        if let minutes = components.minute?.magnitude, minutes > 0 {
            parts.append(pluralisedName(component: .minute, quantity: minutes))
        } 
        if let seconds = components.second?.magnitude, seconds > 0 {
            parts.append(pluralisedName(component: .second, quantity: seconds))
        }
        return parts.listing()
    }
    
    func preferencesInformation() -> String {
        if Date() > interval.earliest {
            "\(counts.timesReminded) reminders left"
        } else if isPast() {
            "\(timeDifferenceInfo()) ago"
        } else {
            "Starting in \(timeDifferenceInfo())"
        }
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
