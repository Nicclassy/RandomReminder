//
//  TimeInfoProvider.swift
//  RandomReminder
//
//  Created by Luca Napoli on 26/2/2025.
//

import Foundation

/// This function will be replaced in the future with proper localizations
func pluralise(_ word: String, _ quantity: Int? = nil) -> String {
    if let quantity {
        quantity == 1 ? word : word + "s"
    } else {
        word + "s"
    }
}

struct TimeInfoProvider {
    private static let orderedCalendarComponents: [Calendar.Component] = [.day, .hour, .minute, .second]
    private static let calendarComponents: Set<Calendar.Component> = [.day, .hour, .minute, .second]

    let reminder: RandomReminder

    static func timeDifferenceInfo(from start: Date, to end: Date = .now) -> String {
        func pluralisedComponent(for component: Calendar.Component, quantity: UInt) -> String {
            let name = String(describing: component)
            let suffix = quantity != 1 ? "s" : ""
            return "\(quantity) \(name)\(suffix)"
        }

        let components = Calendar.current.dateComponents(
            Self.calendarComponents,
            from: end,
            to: start
        )
        if let days = components.day, days >= 7 {
            return ">1 week"
        }

        let infoParts: [String] = Self.orderedCalendarComponents.compactMap { calendarComponent in
            guard let quantity = components.value(for: calendarComponent)?.magnitude, quantity > 0 else {
                return nil
            }

            return pluralisedComponent(for: calendarComponent, quantity: quantity)
        }

        return infoParts.isEmpty ? "0 seconds" : infoParts.listing()
    }

    func preferencesInfo() -> String {
        if reminder.hasPast {
            "\(timeDifferenceInfo()) ago"
        } else if reminder.hasBegun {
            "\(reminder.counts.occurencesLeft) \(pluralise("occurence", reminder.counts.occurencesLeft)) left"
        } else {
            "Starting in \(timeDifferenceInfo())"
        }
    }

    func timeDifferenceInfo() -> String {
        Self.timeDifferenceInfo(from: reminder.interval.earliest)
    }
}
