// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
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
    /// Localizable.strings
    ///   RandomReminder
    /// 
    ///   Created by Luca Napoli on 2/1/2025.
    internal static let preferences = L10n.tr("Localizable", "status-bar.preferences", fallback: "Preferences")
    /// Quit
    internal static let quit = L10n.tr("Localizable", "status-bar.quit", fallback: "Quit")
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
