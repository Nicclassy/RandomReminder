//
//  ReminderCommandOptionsView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 14/1/2026.
//

import SwiftUI

struct ReminderCommandOptionsView: View {
    @Environment(\.openWindow) private var openWindow

    @Bindable var reminder: MutableReminder
    @Bindable var preferences: ReminderPreferences
    @Bindable var viewPreferences: ModificationViewPreferences
    @Bindable var fields: ModificationViewFields

    private let commandController: CommandController = .shared

    var body: some View {
        HStack(spacing: ViewConstants.horizontalSpacing) {
            Toggle(
                "Run a command when the reminder occurs",
                isOn: $preferences.activationCommandEnabled
            )
            Button(reminder.activationEvents.command.value.isEmpty ? "Enter command" : "Edit command") {
                commandController.set(value: reminder.activationEvents.command, for: .activationCommand)
                commandController.commandType = .activationCommand
                openWindow(id: WindowIds.reminderCommand)
            }
            .disabled(!preferences.activationCommandEnabled)
        }
    }
}

#Preview {
    ReminderCommandOptionsView(
        reminder: .init(),
        preferences: .init(),
        viewPreferences: .init(),
        fields: .init()
    )
}
