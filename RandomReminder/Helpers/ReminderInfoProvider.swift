//
//  ReminderInfoProvider.swift
//  RandomReminder
//
//  Created by Luca Napoli on 2/2/2026.
//

import Foundation

struct ReminderInfoProvider {
    private static let orderedCalendarComponents: [Calendar.Component] = [.day, .hour, .minute, .second]
    private static let calendarComponents: Set<Calendar.Component> = [.day, .hour, .minute, .second]
    private static let appPreferences: AppPreferences = .shared

    let reminder: RandomReminder

    private static func timeDifferenceInfo(from start: Date, to end: Date = .now) -> String {
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

            let componentName = componentName(calendarComponent, for: Int(exactly: quantity)!)
            if Self.appPreferences.timeFormat == .short {
                return "\(quantity)\(componentName)"
            }
            return "\(quantity) \(componentName)"
        }

        return infoParts.listing()
    }

    func preferencesInfo() -> String {
        if reminder.hasPast {
            return if case let .finalActivation(date) = reminder.activationState {
                L10n.Preferences.Reminders.ago(timeDifferenceInfo(from: date))
            } else {
                L10n.Preferences.Reminders.ago(timeDifferenceInfo())
            }
        }

        if reminder.hasBegun {
            return if reminder.counts.occurrencesLeft == 1 {
                L10n.Preferences.Reminders.singleOccurrenceLeft
            } else {
                L10n.Preferences.Reminders.multipleOccurrencesLeft(reminder.counts.occurrencesLeft)
            }
        }

        let info = timeDifferenceInfo()
        if !reminder.eponymous {
            return if info.isEmpty {
                L10n.Preferences.Reminders.occurringNow
            } else {
                L10n.Preferences.Reminders.occurringIn(info)
            }
        }

        return if info.isEmpty {
            L10n.Preferences.Reminders.startingNow
        } else {
            L10n.Preferences.Reminders.startingIn(info)
        }
    }

    func timeDifferenceInfo(from date: Date? = nil) -> String {
        Self.timeDifferenceInfo(from: reminder.hasPast ? date ?? reminder.interval.latest : reminder.interval.earliest)
    }
}
