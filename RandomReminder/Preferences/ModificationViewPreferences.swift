//
//  ModificationViewPreferences.swift
//  RandomReminder
//
//  Created by Luca Napoli on 16/5/2025.
//

import Foundation

@Observable
final class ModificationViewPreferences {
    var viewAppeared = false
    var closeView = false
    var refreshView = false
    var showReminderAlert = false
    var showSpecificDaysPopover = false
    var showTimesOnlyPopover = false
    var showCancelAlert = false
    var showFileImporter = false
    var showOptionsPopover = false

    func reset() {
        showReminderAlert = false
        showSpecificDaysPopover = false
        showTimesOnlyPopover = false
        showCancelAlert = false
        showFileImporter = false
        showOptionsPopover = false
    }
}
