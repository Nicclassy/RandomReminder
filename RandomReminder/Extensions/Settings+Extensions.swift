//
//  Settings+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 29/12/2024.
//

import Foundation
import enum Settings.Settings
import SwiftUI

extension Settings.PaneIdentifier {
    static let general = Self("general")
    static let scheduling = Self("scheduling")
    static let reminders = Self("reminders")
    static let about = Self("about")
}
