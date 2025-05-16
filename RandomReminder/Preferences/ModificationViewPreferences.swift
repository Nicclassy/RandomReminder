//
//  ModificationViewPreferences.swift
//  RandomReminder
//
//  Created by Luca Napoli on 16/5/2025.
//

import Foundation

final class ModificationViewPreferences: ObservableObject {
    @Published var closeView = false
    @Published var showReminderErrorAlert = false
    @Published var showSpecificDaysPopover = false
    @Published var showTimesOnlyPopover = false
    @Published var showCancelAlert = false
    @Published var showFileImporter = false

    func reset() {
        showReminderErrorAlert = false
        showSpecificDaysPopover = false
        showTimesOnlyPopover = false
        showCancelAlert = false
        showFileImporter = false
    }
}
