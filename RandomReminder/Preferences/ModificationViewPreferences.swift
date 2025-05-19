//
//  ModificationViewPreferences.swift
//  RandomReminder
//
//  Created by Luca Napoli on 16/5/2025.
//

import Foundation

final class ModificationViewPreferences: ObservableObject {
    @Published var closeView = false
    @Published var showReminderAlert = false
    @Published var showSpecificDaysPopover = false
    @Published var showTimesOnlyPopover = false
    @Published var showCancelAlert = false
    @Published var showFileImporter = false

    func reset() {
        showReminderAlert = false
        showSpecificDaysPopover = false
        showTimesOnlyPopover = false
        showCancelAlert = false
        showFileImporter = false
    }
}
