//
//  TimeInfoProvider.swift
//  RandomReminder
//
//  Created by Luca Napoli on 26/2/2025.
//

import Foundation

enum TimeFormat: Codable, EnumRawRepresentable {
    case short
    case medium
    case long
}

struct TimeInfoProvider {
    private static let orderedCalendarComponents: [Calendar.Component] = [.day, .hour, .minute, .second]
    private static let calendarComponents: Set<Calendar.Component> = [.day, .hour, .minute, .second]
    private static let appPreferences: AppPreferences = .shared

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
            return if reminder.counts.occurencesLeft == 1 {
                L10n.Preferences.Reminders.singleOccurenceLeft
            } else {
                L10n.Preferences.Reminders.multipleOccurencesLeft(reminder.counts.occurencesLeft)
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
        Self.timeDifferenceInfo(from: date ?? reminder.interval.earliest)
    }
}

extension TimeInfoProvider {
    static func seconds(plural: Bool) -> String {
        if appPreferences.timeFormat == .short {
            L10n.shortSeconds
        } else if appPreferences.timeFormat == .medium {
            plural ? L10n.mediumSeconds : L10n.mediumSecond
        } else {
            plural ? L10n.seconds : L10n.second
        }
    }

    static func minutes(plural: Bool) -> String {
        if appPreferences.timeFormat == .short {
            L10n.shortMinutes
        } else if appPreferences.timeFormat == .medium {
            plural ? L10n.mediumMinutes : L10n.mediumMinute
        } else {
            plural ? L10n.minutes : L10n.minute
        }
    }

    static func hours(plural: Bool) -> String {
        if appPreferences.timeFormat == .short {
            L10n.shortHours
        } else if appPreferences.timeFormat == .medium {
            plural ? L10n.mediumHours : L10n.mediumHour
        } else {
            plural ? L10n.hours : L10n.hour
        }
    }

    static func days(plural: Bool) -> String {
        if appPreferences.timeFormat == .short {
            L10n.shortDays
        } else if appPreferences.timeFormat == .medium {
            plural ? L10n.mediumDays : L10n.mediumDay
        } else {
            plural ? L10n.days : L10n.day
        }
    }

    static func weeks(plural: Bool) -> String {
        if appPreferences.timeFormat == .short {
            L10n.shortWeeks
        } else if appPreferences.timeFormat == .medium {
            plural ? L10n.mediumWeeks : L10n.mediumWeek
        } else {
            plural ? L10n.weeks : L10n.week
        }
    }

    static func months(plural: Bool) -> String {
        if appPreferences.timeFormat == .short {
            L10n.shortMonths
        } else if appPreferences.timeFormat == .medium {
            plural ? L10n.mediumMonths : L10n.mediumMonth
        } else {
            plural ? L10n.months : L10n.month
        }
    }
}
