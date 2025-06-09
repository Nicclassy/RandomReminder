// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// day
  internal static let day = L10n.tr("Localizable", "day", fallback: "day")
  /// days
  internal static let days = L10n.tr("Localizable", "days", fallback: "days")
  /// Friday
  internal static let friday = L10n.tr("Localizable", "friday", fallback: "Friday")
  /// hour
  internal static let hour = L10n.tr("Localizable", "hour", fallback: "hour")
  /// hours
  internal static let hours = L10n.tr("Localizable", "hours", fallback: "hours")
  /// day
  internal static let mediumDay = L10n.tr("Localizable", "medium-day", fallback: "day")
  /// days
  internal static let mediumDays = L10n.tr("Localizable", "medium-days", fallback: "days")
  /// hr
  internal static let mediumHour = L10n.tr("Localizable", "medium-hour", fallback: "hr")
  /// hrs
  internal static let mediumHours = L10n.tr("Localizable", "medium-hours", fallback: "hrs")
  /// min
  internal static let mediumMinute = L10n.tr("Localizable", "medium-minute", fallback: "min")
  /// mins
  internal static let mediumMinutes = L10n.tr("Localizable", "medium-minutes", fallback: "mins")
  /// month
  internal static let mediumMonth = L10n.tr("Localizable", "medium-month", fallback: "month")
  /// months
  internal static let mediumMonths = L10n.tr("Localizable", "medium-months", fallback: "months")
  /// sec
  internal static let mediumSecond = L10n.tr("Localizable", "medium-second", fallback: "sec")
  /// secs
  internal static let mediumSeconds = L10n.tr("Localizable", "medium-seconds", fallback: "secs")
  /// week
  internal static let mediumWeek = L10n.tr("Localizable", "medium-week", fallback: "week")
  /// weeks
  internal static let mediumWeeks = L10n.tr("Localizable", "medium-weeks", fallback: "weeks")
  /// minute
  internal static let minute = L10n.tr("Localizable", "minute", fallback: "minute")
  /// minutes
  internal static let minutes = L10n.tr("Localizable", "minutes", fallback: "minutes")
  /// Monday
  internal static let monday = L10n.tr("Localizable", "monday", fallback: "Monday")
  /// month
  internal static let month = L10n.tr("Localizable", "month", fallback: "month")
  /// months
  internal static let months = L10n.tr("Localizable", "months", fallback: "months")
  /// Saturday
  internal static let saturday = L10n.tr("Localizable", "saturday", fallback: "Saturday")
  /// second
  internal static let second = L10n.tr("Localizable", "second", fallback: "second")
  /// seconds
  internal static let seconds = L10n.tr("Localizable", "seconds", fallback: "seconds")
  /// d
  internal static let shortDays = L10n.tr("Localizable", "short-days", fallback: "d")
  /// h
  internal static let shortHours = L10n.tr("Localizable", "short-hours", fallback: "h")
  /// m
  internal static let shortMinutes = L10n.tr("Localizable", "short-minutes", fallback: "m")
  /// mo
  internal static let shortMonths = L10n.tr("Localizable", "short-months", fallback: "mo")
  /// Localizable.strings
  ///   RandomReminder
  /// 
  ///   Created by Luca Napoli on 2/1/2025.
  internal static let shortSeconds = L10n.tr("Localizable", "short-seconds", fallback: "s")
  /// w
  internal static let shortWeeks = L10n.tr("Localizable", "short-weeks", fallback: "w")
  /// Sunday
  internal static let sunday = L10n.tr("Localizable", "sunday", fallback: "Sunday")
  /// Thursday
  internal static let thursday = L10n.tr("Localizable", "thursday", fallback: "Thursday")
  /// Tuesday
  internal static let tuesday = L10n.tr("Localizable", "tuesday", fallback: "Tuesday")
  /// Wednesday
  internal static let wednesday = L10n.tr("Localizable", "wednesday", fallback: "Wednesday")
  /// week
  internal static let week = L10n.tr("Localizable", "week", fallback: "week")
  /// weeks
  internal static let weeks = L10n.tr("Localizable", "weeks", fallback: "weeks")
  internal enum DatePicker {
    internal enum EarliestDate {
      /// Earliest date:
      internal static let heading = L10n.tr("Localizable", "date-picker.earliest-date.heading", fallback: "Earliest date:")
    }
    internal enum LatestDate {
      /// Latest date:
      internal static let heading = L10n.tr("Localizable", "date-picker.latest-date.heading", fallback: "Latest date:")
    }
  }
  internal enum Preferences {
    internal enum General {
      /// Launch at Login
      internal static let launchAtLogin = L10n.tr("Localizable", "preferences.general.launch-at-login", fallback: "Launch at Login")
      /// Enable Quick Reminder
      internal static let quickReminderEnabled = L10n.tr("Localizable", "preferences.general.quick-reminder-enabled", fallback: "Enable Quick Reminder")
      internal enum LaunchAtLogin {
        /// Automatically start RandomReminder when you login.
        internal static let caption = L10n.tr("Localizable", "preferences.general.launch-at-login.caption", fallback: "Automatically start RandomReminder when you login.")
      }
      internal enum QuickReminderEnabled {
        /// Show Quick Reminder in the menu bar item's menu.
        internal static let caption = L10n.tr("Localizable", "preferences.general.quick-reminder-enabled.caption", fallback: "Show Quick Reminder in the menu bar item's menu.")
      }
    }
    internal enum Reminders {
      /// %@ ago
      internal static func ago(_ p1: Any) -> String {
        return L10n.tr("Localizable", "preferences.reminders.ago", String(describing: p1), fallback: "%@ ago")
      }
      /// >1 week
      internal static let longerThanOneWeek = L10n.tr("Localizable", "preferences.reminders.longer-than-one-week", fallback: ">1 week")
      /// %d occurences left
      internal static func multipleOccurencesLeft(_ p1: Int) -> String {
        return L10n.tr("Localizable", "preferences.reminders.multiple-occurences-left", p1, fallback: "%d occurences left")
      }
      /// 1 occurence left
      internal static let singleOccurenceLeft = L10n.tr("Localizable", "preferences.reminders.single-occurence-left", fallback: "1 occurence left")
      /// Starting in %@
      internal static func startingIn(_ p1: Any) -> String {
        return L10n.tr("Localizable", "preferences.reminders.starting-in", String(describing: p1), fallback: "Starting in %@")
      }
      /// Starting now
      internal static let startingNow = L10n.tr("Localizable", "preferences.reminders.starting-now", fallback: "Starting now")
    }
    internal enum Tab {
      /// About
      internal static let about = L10n.tr("Localizable", "preferences.tab.about", fallback: "About")
      /// General
      internal static let general = L10n.tr("Localizable", "preferences.tab.general", fallback: "General")
      /// Reminders
      internal static let reminders = L10n.tr("Localizable", "preferences.tab.reminders", fallback: "Reminders")
    }
  }
  internal enum StatusBar {
    /// Preferences
    internal static let preferences = L10n.tr("Localizable", "status-bar.preferences", fallback: "Preferences")
    /// Quit
    internal static let quit = L10n.tr("Localizable", "status-bar.quit", fallback: "Quit")
  }
  internal enum TimePicker {
    internal enum EarliestDefaultTime {
      /// Default earliest time:
      internal static let heading = L10n.tr("Localizable", "time-picker.earliest-default-time.heading", fallback: "Default earliest time:")
    }
    internal enum EarliestTime {
      /// Earliest time:
      internal static let heading = L10n.tr("Localizable", "time-picker.earliest-time.heading", fallback: "Earliest time:")
    }
    internal enum LatestDefaultTime {
      /// Default latest time:
      internal static let heading = L10n.tr("Localizable", "time-picker.latest-default-time.heading", fallback: "Default latest time:")
    }
    internal enum LatestTime {
      /// Latest time:
      internal static let heading = L10n.tr("Localizable", "time-picker.latest-time.heading", fallback: "Latest time:")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
