//
//  ReminderModificationView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 13/2/2025.
//

import SwiftUI

enum ReminderModificationMode {
    case create
    case edit
}

final class ModificationViewFields: ObservableObject {
    @Published var occurrencesText: String = ""
    @Published var intervalQuantityText: String = ""

    func reset() {
        occurrencesText = ""
        intervalQuantityText = ""
    }
}

struct ReminderModificationView: View {
    @Environment(\.dismissWindow) private var dismissWindow

    @StateObject var reminder: MutableReminder = .init()
    @StateObject var preferences: ReminderPreferences = .init()
    @StateObject var viewPreferences: ModificationViewPreferences = .init()
    @StateObject var fields: ModificationViewFields = .init()
    @State private var validationResult: ValidationResult = .unset

    @ObservedObject private var controller: ReminderModificationController = .shared
    private let schedulingPreferences: SchedulingPreferences = .shared
    let mode: ReminderModificationMode

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ReminderContentView(
                reminder: reminder,
                fields: fields
            )
            ReminderScheduleOptionsView(
                reminder: reminder,
                preferences: preferences,
                viewPreferences: viewPreferences,
                fields: fields
            )
            ReminderAudioOptionsView(
                reminder: reminder,
                preferences: preferences,
                viewPreferences: viewPreferences,
                useAudioFile: $preferences.useAudioFile
            )

            HStack {
                Button(action: {
                    let validator = ReminderValidator(
                        reminder: reminder,
                        preferences: preferences,
                        fields: fields
                    )

                    validationResult = validator.validate()
                    switch validationResult {
                    case .success, .unset:
                        break
                    case .error, .warning:
                        viewPreferences.showReminderAlert = true
                        return
                    }

                    createNewReminder()
                    dismissWindow(id: mode == .create ? WindowIds.createReminder : WindowIds.editReminder)
                }, label: {
                    Text(finishButtonText)
                        .frame(width: 60)
                })
                .alert(
                    validationResult.alertText,
                    isPresented: $viewPreferences.showReminderAlert,
                    actions: {
                        if case .error = validationResult {
                            Button("OK") {}
                                .buttonStyle(.borderedProminent)
                        } else if case .warning = validationResult {
                            Button("Cancel", role: .cancel) {}
                            Button("OK") {
                                createNewReminder()
                                viewPreferences.closeView = true
                            }
                        }
                    },
                    message: {
                        Text(validationResult.messageText)
                    }
                )
                .disabled(reminder.title.isEmpty)
                .if(!reminder.title.isEmpty) { it in
                    it.buttonStyle(.borderedProminent)
                }

                Button(action: {
                    viewPreferences.showCancelAlert = true
                }, label: {
                    Text("Cancel")
                        .frame(width: 60)
                })
                .alert(
                    "Are you sure you want to discard this reminder?",
                    isPresented: $viewPreferences.showCancelAlert,
                    actions: {
                        Button("Cancel", role: .cancel) {}
                        Button("Delete", role: .destructive) {
                            viewPreferences.closeView = true
                        }
                    },
                    message: {
                        Text("All entered information will be lost.")
                    }
                )
                .onChange(of: viewPreferences.closeView) {
                    // For some reason, dismissing the window after the alert has closed
                    // or in this closure does not work.
                    // Therefore, it is necessary to close the window itself instead
                    if viewPreferences.closeView {
                        NSApp.keyWindow?.close()
                        dismissWindow(id: WindowIds.descriptionCommand)
                        viewPreferences.closeView = false
                    }
                }
            }
        }
        .onAppear {
            guard mode == .edit else {
                setDefaultTimes()
                return
            }
            guard let reminderToEdit = controller.reminder else {
                fatalError("Reminder must be set")
            }

            reminder.copyFrom(reminder: reminderToEdit)
            preferences.copyFrom(reminder: reminderToEdit)

            let command = if case let .command(value) = reminderToEdit.content.description {
                value
            } else {
                ReminderDescriptionView.defaultCommand
            }

            controller.descriptionCommand = command
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .editDescriptionCommand, object: nil)
            }
        }
        .onDisappear {
            reminder.reset()
            preferences.reset()
            fields.reset()
            dismissWindow(id: WindowIds.descriptionCommand)
            controller.modificationWindowOpen = false
        }
        .onReceive(NotificationCenter.default.publisher(for: .refreshModificationWindow)) { _ in
            FancyLogger.info("Refresh modification window toggled")
            viewPreferences.refreshView.toggle()
        }
        .onReceive(NotificationCenter.default.publisher(for: .descriptionCommandSet)) { _ in
            reminder.description = .command(controller.descriptionCommand)
        }
        .frame(width: ViewConstants.reminderWindowWidth, height: ViewConstants.reminderWindowHeight)
        .padding()
    }

    private var cancelAlertText: String {
        if mode == .create {
            "Are you sure you want to discard this reminder?"
        } else {
            "Are you sure you want to stop editing this reminder?"
        }
    }

    private var finishButtonText: String {
        mode == .create ? "Create" : "Save"
    }

    private func setDefaultTimes() {
        if schedulingPreferences.defaultEarliestTimeEnabled {
            reminder.earliestDate = .dateToday(withTime: schedulingPreferences.defaultEarliestTime)
        }
        if schedulingPreferences.defaultLatestTimeEnabled {
            reminder.latestDate = .dateToday(withTime: schedulingPreferences.defaultLatestTime)
        }
    }

    private func createNewReminder() {
        let newReminder = reminder.build(preferences: preferences)
        if mode == .edit {
            guard let previousReminder = controller.reminder else {
                fatalError("A reminder should be stored here")
            }

            ReminderManager.shared.removeReminder(previousReminder)
        }

        ReminderManager.shared.addReminder(newReminder)
        controller.postRefreshRemindersNotification()
        FancyLogger.info("Created new reminder/edited reminder \(String(reflecting: reminder))")
    }
}

#Preview {
    ReminderModificationView(reminder: .init(), preferences: .init(), viewPreferences: .init(), mode: .create)
}
