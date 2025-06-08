//
//  TimeInfoProvider.swift
//  RandomReminder
//
//  Created by Luca Napoli on 26/2/2025.
//

import Foundation

struct TimeInfoProvider {
    private static let orderedCalendarComponents: [Calendar.Component] = [.day, .hour, .minute, .second]
    private static let calendarComponents: Set<Calendar.Component> = [.day, .hour, .minute, .second]

    let reminder: RandomReminder

    static func timeDifferenceInfo(from start: Date, to end: Date = .now) -> String {
        func componentName(_ component: Calendar.Component, for quantity: Int) -> String {
            guard let unit = TimeUnit(rawValue: String(describing: component)) else {
                fatalError("Cannot convert \(component) into a TimeUnit")
            }
            return unit.name(for: quantity)
        }

        let components = Calendar.current.dateComponents(
            Self.calendarComponents,
            from: end,
            to: start
        )
        if let days = components.day, days >= 7 {
            return L10n.Preferences.Reminders.longerThanOneWeek
        }

        let infoParts: [String] = Self.orderedCalendarComponents.compactMap { calendarComponent in
            guard let quantity = components.value(for: calendarComponent)?.magnitude, quantity > 0 else {
                return nil
            }

            return componentName(calendarComponent, for: Int(exactly: quantity)!)
        }

        return infoParts.listing()
    }

    func preferencesInfo() -> String {
        if reminder.hasPast {
            return L10n.Preferences.Reminders.ago(timeDifferenceInfo())
        }
        if reminder.hasBegun {
            if reminder.counts.occurencesLeft == 1 {
                return L10n.Preferences.Reminders.singleOccurenceLeft
            }
            return L10n.Preferences.Reminders.multipleOccurencesLeft(reminder.counts.occurencesLeft)
        }
        
        let info = timeDifferenceInfo()
        if info.isEmpty {
            return L10n.Preferences.Reminders.startingNow
        }
        return L10n.Preferences.Reminders.startingIn(info)
    }

    func timeDifferenceInfo() -> String {
        Self.timeDifferenceInfo(from: reminder.interval.earliest)
    }
}
