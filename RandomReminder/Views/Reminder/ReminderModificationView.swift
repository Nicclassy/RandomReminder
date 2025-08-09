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
        // swiftlint:disable:next closure_body_length
        VStack(alignment: .leading, spacing: 20) {
            ReminderContentOptionsView(
                reminder: reminder,
                preferences: preferences,
                fields: fields
            )

            ReminderOptionsView(
                reminder: reminder,
                preferences: preferences,
                viewPreferences: viewPreferences,
                fields: fields
            )

            ReminderDateView(
                reminder: reminder,
                preferences: preferences
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
                    if mode == .edit {
                        NotificationCenter.default.post(name: .updateReminderPreferencesText, object: nil)
                    }
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
                            Button(L10n.Modification.ok) {}
                                .buttonStyle(.borderedProminent)
                        } else if case .warning = validationResult {
                            Button(L10n.Modification.cancel, role: .cancel) {}
                            Button(L10n.Modification.ok) {
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
                    Text(L10n.Modification.cancel)
                        .frame(width: 60)
                })
                .alert(
                    alertTitle,
                    isPresented: $viewPreferences.showCancelAlert,
                    actions: {
                        Button(L10n.Modification.cancel, role: .cancel) {}
                        Button(L10n.Modification.delete, role: .destructive) {
                            viewPreferences.closeView = true
                        }
                    },
                    message: {
                        Text(L10n.Modification.DiscardReminder.message)
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

            let description = reminderToEdit.content.description
            if case .command = description {
                controller.editDescriptionCommand(description)
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
            reminder.description = controller.descriptionCommand
        }
        .frame(width: ViewConstants.reminderWindowWidth, height: ViewConstants.reminderWindowHeight)
        .padding()
    }

    private var alertTitle: String {
        if mode == .create {
            L10n.Modification.DiscardReminder.Create.title
        } else {
            L10n.Modification.DiscardReminder.Edit.title
        }
    }

    private var finishButtonText: String {
        mode == .create ? L10n.Modification.create : L10n.Modification.save
    }

    private func setDefaultTimes() {
        if schedulingPreferences.defaultEarliestTimeEnabled {
            reminder.earliestDate = .dateToday(withTime: schedulingPreferences.defaultEarliestTime)
        }
        if schedulingPreferences.defaultLatestTimeEnabled {
            reminder.latestDate = .dateToday(withTime: schedulingPreferences.defaultLatestTime)
            FancyLogger.info("Latest date: \(reminder.latestDate)")
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
