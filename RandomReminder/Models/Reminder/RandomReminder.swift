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
    let days: ReminderDayOptions
    let activationEvents: ReminderActivationEvents
    var reminderInterval: AnyReminderInterval
    var counts: ReminderCounts
    var state: ReminderState

    var interval: ReminderInterval {
        // AnyReminderInterval is only for serialisation/deserialisation
        // so instead get the type-erased protocol value for operations
        reminderInterval.value
    }

    var hasBegun: Bool {
        state == .started
    }

    var hasPast: Bool {
        state == .finished
    }

    var hasRepeats: Bool {
        interval.hasRepeats
    }

    var hasAudio: Bool {
        activationEvents.audio != nil
    }

    var eponymous: Bool {
        interval.earliest != interval.latest
    }

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
        description: ReminderDescription,
        interval: ReminderInterval,
        days: ReminderDayOptions? = nil,
        totalOccurences: Int,
        activationEvents: ReminderActivationEvents? = nil
    ) {
        self.init(
            id: id,
            content: ReminderContent(title: title, description: description),
            reminderInterval: AnyReminderInterval(interval),
            days: days ?? .allOptions(),
            counts: ReminderCounts(totalOccurences: totalOccurences),
            state: .upcoming,
            activationEvents: activationEvents ?? ReminderActivationEvents()
        )
    }

    func hasEnded(after date: Date) -> Bool {
        date >= interval.latest
    }

    func hasStarted(after date: Date) -> Bool {
        date >= interval.earliest
    }

    func advanceToNextRepeat() {
        // This is the only time we modify reminderInterval—
        // and this function would never be called in
        // situations that result in race conditions—
        // so thankfully we need not have thread-safety
        // mechanisms for the reminderInterval property
        let nextInterval = interval.nextRepeat()
        reminderInterval = AnyReminderInterval(nextInterval)
        state = .upcoming
    }

    func durationInSeconds() -> Float {
        Float(interval.earliest.distance(to: interval.latest))
    }
}

extension RandomReminder {
    func compare(with other: RandomReminder) -> Bool {
        if hasPast != other.hasPast {
            hasPast
        } else if hasBegun != other.hasBegun {
            hasBegun
        } else if hasBegun && other.hasBegun {
            counts.occurences < other.counts.occurences
        } else if !hasBegun && !other.hasBegun {
            interval.earliest < other.interval.earliest
        } else if hasPast && other.hasPast {
            interval.latest < other.interval.latest
        } else {
            content.title < other.content.title
        }
    }

    func filename() -> String {
        URL(string: String(describing: id))!
            .appendingPathExtension(StoredReminders.fileExtension)
            .path()
    }
}

extension RandomReminder: CustomStringConvertible {
    private static let titleOnly = true

    var description: String {
        Self.titleOnly ? content.title : reflectedDescription
    }

    var reflectedDescription: String {
        let mirror = Mirror(reflecting: self)
        let properties = mirror.children
            .map { "\($0.label ?? "?") = \($0.value)" }
            .joined(separator: ", ")
        return "\(type(of: self)) { \(properties) }"
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
