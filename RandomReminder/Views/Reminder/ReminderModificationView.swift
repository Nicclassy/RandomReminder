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
}

struct ReminderModificationView: View {
    @Environment(\.dismissWindow) private var dismissWindow
    @ObservedObject private var controller: ReminderModificationController = .shared
    @StateObject var reminder: MutableReminder = .init()
    @StateObject var preferences: ReminderPreferences = .init()
    @StateObject var viewPreferences: ModificationViewPreferences = .init()
    @StateObject var fields: ModificationViewFields = .init()
    @State private var validationResult: ValidationResult = .unset
    let mode: ReminderModificationMode

    var body: some View {
        // swiftlint:disable:next closure_body_length
        VStack(alignment: .leading, spacing: 20) {
            Grid(alignment: .leading) {
                GridRow {
                    Text("Reminder title:")
                    TextField("Title", text: $reminder.title)
                }
                GridRow {
                    Text("Reminder description:")
                    TextField("Description", text: $reminder.text)
                }
                GridRow {
                    Text("Total occurences:")
                    StepperTextField(value: $reminder.totalOccurences, range: totalRemindersRange) { text in
                        DispatchQueue.main.async {
                            fields.occurrencesText = text
                        }
                    }
                    .frame(width: 55)
                }
            }

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

            // swiftlint:disable:next closure_body_length
            HStack {
                let finishButton = Button(action: {
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

                if reminder.title.isEmpty {
                    finishButton
                        .buttonStyle(.automatic)
                        .disabled(true)
                } else {
                    finishButton.buttonStyle(.borderedProminent)
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
                        viewPreferences.closeView = false
                    }
                }
            }
        }
        .onAppear {
            guard controller.openedModificationWindow else {
                controller.openedModificationWindow = true
                return
            }
            guard mode == .edit else { return }
            guard let reminderToEdit = controller.reminder else {
                fatalError("Reminder must be set")
            }

            reminder.copyFrom(reminder: reminderToEdit)
            preferences.copyFrom(reminder: reminderToEdit)
            assert(controller.modificationWindowOpen, "modificationWindowOpen should be set to true")
        }
        .onDisappear {
            reminder.reset()
            preferences.reset()
            controller.modificationWindowOpen = false
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

    private var totalRemindersRange: ClosedRange<Int> {
        ReminderConstants.minReminders...ReminderConstants.maxReminders
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
