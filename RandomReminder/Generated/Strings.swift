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
  internal enum Modification {
    /// Back
    internal static let back = L10n.tr("Localizable", "modification.back", fallback: "Back")
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "modification.cancel", fallback: "Cancel")
    /// Create
    internal static let create = L10n.tr("Localizable", "modification.create", fallback: "Create")
    /// Delete
    internal static let delete = L10n.tr("Localizable", "modification.delete", fallback: "Delete")
    /// Next
    internal static let next = L10n.tr("Localizable", "modification.next", fallback: "Next")
    /// OK
    internal static let ok = L10n.tr("Localizable", "modification.ok", fallback: "OK")
    /// Save
    internal static let save = L10n.tr("Localizable", "modification.save", fallback: "Save")
    internal enum Audio {
      /// OR
      internal static let alternativeOption = L10n.tr("Localizable", "modification.audio.alternative-option", fallback: "OR")
      /// Audio file
      internal static let audioFile = L10n.tr("Localizable", "modification.audio.audio-file", fallback: "Audio file")
      /// Play audio when the reminder occurs
      internal static let play = L10n.tr("Localizable", "modification.audio.play", fallback: "Play audio when the reminder occurs")
      internal enum Change {
        /// Choose an audio file
        internal static let noFileSelected = L10n.tr("Localizable", "modification.audio.change.no-file-selected", fallback: "Choose an audio file")
        /// Change audio file from %@
        internal static func pickerIsNotShown(_ p1: Any) -> String {
          return L10n.tr("Localizable", "modification.audio.change.picker-is-not-shown", String(describing: p1), fallback: "Change audio file from %@")
        }
        /// Change audio file
        internal static let pickerIsShown = L10n.tr("Localizable", "modification.audio.change.picker-is-shown", fallback: "Change audio file")
      }
    }
    internal enum Content {
      /// Delete description command
      internal static let deleteDescriptionCommand = L10n.tr("Localizable", "modification.content.delete-description-command", fallback: "Delete description command")
      /// Reminder description:
      internal static let reminderDescription = L10n.tr("Localizable", "modification.content.reminder-description", fallback: "Reminder description:")
      /// Reminder title:
      internal static let reminderTitle = L10n.tr("Localizable", "modification.content.reminder-title", fallback: "Reminder title:")
      /// Total occurrences:
      internal static let totalOccurrences = L10n.tr("Localizable", "modification.content.total-occurrences", fallback: "Total occurrences:")
      internal enum ReminderTitle {
        /// Title
        internal static let text = L10n.tr("Localizable", "modification.content.reminder-title.text", fallback: "Title")
      }
    }
    internal enum DiscardReminder {
      /// All entered information will be lost.
      internal static let message = L10n.tr("Localizable", "modification.discard-reminder.message", fallback: "All entered information will be lost.")
      internal enum Create {
        /// Are you sure you want to discard this reminder?
        internal static let title = L10n.tr("Localizable", "modification.discard-reminder.create.title", fallback: "Are you sure you want to discard this reminder?")
      }
      internal enum Edit {
        /// Are you sure you want to stop editing this reminder?
        internal static let title = L10n.tr("Localizable", "modification.discard-reminder.edit.title", fallback: "Are you sure you want to stop editing this reminder?")
      }
    }
    internal enum Options {
      /// Always running
      internal static let alwaysRunning = L10n.tr("Localizable", "modification.options.always-running", fallback: "Always running")
      /// Non-random
      internal static let nonRandom = L10n.tr("Localizable", "modification.options.non-random", fallback: "Non-random")
      /// Repeat
      internal static let `repeat` = L10n.tr("Localizable", "modification.options.repeat", fallback: "Repeat")
      /// Show in window when active
      internal static let showInWindowWhenActive = L10n.tr("Localizable", "modification.options.show-in-window-when-active", fallback: "Show in window when active")
      /// Use times only
      internal static let timesOnly = L10n.tr("Localizable", "modification.options.times-only", fallback: "Use times only")
      internal enum TimesOnly {
        /// The created reminder will occur daily between the specified times.
        internal static let popoverText = L10n.tr("Localizable", "modification.options.times-only.popover-text", fallback: "The created reminder will occur daily between the specified times.")
      }
    }
  }
  internal enum NotificationPermissions {
    internal enum Launch {
      internal enum AlertStyle {
        /// Notifications for RandomReminder are currently set to 'Banner'. Although notifications will function correctly, it is recommended to change this setting to 'Alerts'.
        internal static let banner = L10n.tr("Localizable", "notification-permissions.launch.alert-style.banner", fallback: "Notifications for RandomReminder are currently set to 'Banner'. Although notifications will function correctly, it is recommended to change this setting to 'Alerts'.")
        /// Notifications for RandomReminder are allowed but currently set to 'None'. RandomReminder will not be able to function properly without notifications appearing. It is recommended to change this setting to 'Alerts'.
        internal static let `none` = L10n.tr("Localizable", "notification-permissions.launch.alert-style.none", fallback: "Notifications for RandomReminder are allowed but currently set to 'None'. RandomReminder will not be able to function properly without notifications appearing. It is recommended to change this setting to 'Alerts'.")
      }
      internal enum AuthorisationStatus {
        /// Notifications are disabled for RandomReminder. Enable notifications in System Settings to receive notifications for reminders.
        internal static let denied = L10n.tr("Localizable", "notification-permissions.launch.authorisation-status.denied", fallback: "Notifications are disabled for RandomReminder. Enable notifications in System Settings to receive notifications for reminders.")
        /// Notifications are yet to be set for RandomReminder. Enable notifications in System Settings to receive notifications for reminders.
        internal static let notDetermined = L10n.tr("Localizable", "notification-permissions.launch.authorisation-status.not-determined", fallback: "Notifications are yet to be set for RandomReminder. Enable notifications in System Settings to receive notifications for reminders.")
      }
    }
    internal enum Notification {
      internal enum AlertStyle {
        /// RandomReminder attempted to deliver a notification but notifications are set to 'None'. Change this in Settings to allow future notifications.
        internal static let `none` = L10n.tr("Localizable", "notification-permissions.notification.alert-style.none", fallback: "RandomReminder attempted to deliver a notification but notifications are set to 'None'. Change this in Settings to allow future notifications.")
      }
      internal enum AuthorisationStatus {
        /// RandomReminder attempted to deliver a notification but notifications are disabled. Change this in Settings to allow future notifications.
        internal static let denied = L10n.tr("Localizable", "notification-permissions.notification.authorisation-status.denied", fallback: "RandomReminder attempted to deliver a notification but notifications are disabled. Change this in Settings to allow future notifications.")
        /// RandomReminder attempted to deliver a notification but notifications are not set. Change this in Settings to allow future notifications.
        internal static let notDetermined = L10n.tr("Localizable", "notification-permissions.notification.authorisation-status.not-determined", fallback: "RandomReminder attempted to deliver a notification but notifications are not set. Change this in Settings to allow future notifications.")
      }
    }
  }
  internal enum Preferences {
    internal enum General {
      /// Launch at Login
      internal static let launchAtLogin = L10n.tr("Localizable", "preferences.general.launch-at-login", fallback: "Launch at Login")
      /// Randomise audio playback start
      internal static let randomiseAudioPlayback = L10n.tr("Localizable", "preferences.general.randomise-audio-playback", fallback: "Randomise audio playback start")
      /// Show reminder counts
      internal static let showReminderCounts = L10n.tr("Localizable", "preferences.general.show-reminder-counts", fallback: "Show reminder counts")
      /// Time Format
      internal static let timeFormat = L10n.tr("Localizable", "preferences.general.time-format", fallback: "Time Format")
      internal enum LaunchAtLogin {
        /// Automatically start RandomReminder when you login.
        internal static let caption = L10n.tr("Localizable", "preferences.general.launch-at-login.caption", fallback: "Automatically start RandomReminder when you login.")
      }
      internal enum RandomiseAudioPlayback {
        /// Start playback from a random point in reminders' audio files.
        internal static let caption = L10n.tr("Localizable", "preferences.general.randomise-audio-playback.caption", fallback: "Start playback from a random point in reminders' audio files.")
      }
      internal enum ShowReminderCounts {
        /// Show the number of reminders in each category in the category's heading.
        internal static let caption = L10n.tr("Localizable", "preferences.general.show-reminder-counts.caption", fallback: "Show the number of reminders in each category in the category's heading.")
      }
      internal enum TimeFormat {
        /// hours, minutes, seconds
        internal static let long = L10n.tr("Localizable", "preferences.general.time-format.long", fallback: "hours, minutes, seconds")
        /// hrs, mins, secs
        internal static let medium = L10n.tr("Localizable", "preferences.general.time-format.medium", fallback: "hrs, mins, secs")
        /// h, m, s
        internal static let short = L10n.tr("Localizable", "preferences.general.time-format.short", fallback: "h, m, s")
      }
    }
    internal enum Reminders {
      /// %@ ago
      internal static func ago(_ p1: Any) -> String {
        return L10n.tr("Localizable", "preferences.reminders.ago", String(describing: p1), fallback: "%@ ago")
      }
      /// Create New Reminder
      internal static let createNew = L10n.tr("Localizable", "preferences.reminders.create-new", fallback: "Create New Reminder")
      /// Edit Reminders
      internal static let edit = L10n.tr("Localizable", "preferences.reminders.edit", fallback: "Edit Reminders")
      /// Finish Editing
      internal static let finishEditing = L10n.tr("Localizable", "preferences.reminders.finish-editing", fallback: "Finish Editing")
      /// >1 week
      internal static let longerThanOneWeek = L10n.tr("Localizable", "preferences.reminders.longer-than-one-week", fallback: ">1 week")
      /// %d occurrences left
      internal static func multipleOccurrencesLeft(_ p1: Int) -> String {
        return L10n.tr("Localizable", "preferences.reminders.multiple-occurrences-left", p1, fallback: "%d occurrences left")
      }
      /// Occurring in %@
      internal static func occurringIn(_ p1: Any) -> String {
        return L10n.tr("Localizable", "preferences.reminders.occurring-in", String(describing: p1), fallback: "Occurring in %@")
      }
      /// Occurring now
      internal static let occurringNow = L10n.tr("Localizable", "preferences.reminders.occurring-now", fallback: "Occurring now")
      /// Past Reminders
      internal static let past = L10n.tr("Localizable", "preferences.reminders.past", fallback: "Past Reminders")
      /// Reminders: %d
      internal static func remindersCount(_ p1: Int) -> String {
        return L10n.tr("Localizable", "preferences.reminders.reminders-count", p1, fallback: "Reminders: %d")
      }
      /// 1 occurrence left
      internal static let singleOccurrenceLeft = L10n.tr("Localizable", "preferences.reminders.single-occurrence-left", fallback: "1 occurrence left")
      /// Starting in %@
      internal static func startingIn(_ p1: Any) -> String {
        return L10n.tr("Localizable", "preferences.reminders.starting-in", String(describing: p1), fallback: "Starting in %@")
      }
      /// Starting now
      internal static let startingNow = L10n.tr("Localizable", "preferences.reminders.starting-now", fallback: "Starting now")
      /// Upcoming Reminders
      internal static let upcoming = L10n.tr("Localizable", "preferences.reminders.upcoming", fallback: "Upcoming Reminders")
      internal enum Rows {
        /// Cancel
        internal static let cancel = L10n.tr("Localizable", "preferences.reminders.rows.cancel", fallback: "Cancel")
        /// Delete
        internal static let delete = L10n.tr("Localizable", "preferences.reminders.rows.delete", fallback: "Delete")
        /// Are you sure you want to delete the reminder '%@'?
        internal static func deleteAlert(_ p1: Any) -> String {
          return L10n.tr("Localizable", "preferences.reminders.rows.delete-alert", String(describing: p1), fallback: "Are you sure you want to delete the reminder '%@'?")
        }
        /// Deleted reminders cannot be recovered.
        internal static let deleteCaption = L10n.tr("Localizable", "preferences.reminders.rows.delete-caption", fallback: "Deleted reminders cannot be recovered.")
        /// Edit
        internal static let edit = L10n.tr("Localizable", "preferences.reminders.rows.edit", fallback: "Edit")
        /// Active
        internal static let notificationIsPresent = L10n.tr("Localizable", "preferences.reminders.rows.notification-is-present", fallback: "Active")
        /// Waiting
        internal static let notificationIsWaiting = L10n.tr("Localizable", "preferences.reminders.rows.notification-is-waiting", fallback: "Waiting")
        /// Paused
        internal static let paused = L10n.tr("Localizable", "preferences.reminders.rows.paused", fallback: "Paused")
        /// Resumes on %@
        internal static func resumesOn(_ p1: Any) -> String {
          return L10n.tr("Localizable", "preferences.reminders.rows.resumes-on", String(describing: p1), fallback: "Resumes on %@")
        }
      }
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
      /// Earliest time:
      internal static let heading = L10n.tr("Localizable", "time-picker.earliest-default-time.heading", fallback: "Earliest time:")
    }
    internal enum EarliestTime {
      /// Earliest time:
      internal static let heading = L10n.tr("Localizable", "time-picker.earliest-time.heading", fallback: "Earliest time:")
    }
    internal enum LatestDefaultTime {
      /// Latest time:
      internal static let heading = L10n.tr("Localizable", "time-picker.latest-default-time.heading", fallback: "Latest time:")
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
