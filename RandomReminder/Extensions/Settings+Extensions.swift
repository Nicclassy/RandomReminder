//
//  Settings+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 29/12/2024.
//

import Foundation
import SwiftUI
import enum Settings.Settings

extension Settings.PaneIdentifier {
    static let general = Self("general")
    static let schedule = Self("schedule")
    static let reminders = Self("reminders")
    static let about = Self("about")
}
