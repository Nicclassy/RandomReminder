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

enum TimeInfoProvider {
    private static let appPreferences: AppPreferences = .shared

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
