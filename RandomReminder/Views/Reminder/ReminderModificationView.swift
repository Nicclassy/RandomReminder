//
//  ReminderModificationView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 13/2/2025.
//

import SwiftUI

private enum ReminderModificationStep: Traversable {
    case content
    case create
}

enum ReminderModificationMode {
    case create
    case edit
}

@Observable
final class ModificationViewFields {
    var occurrencesText = ""
    var intervalQuantityText = ""

    func reset() {
        occurrencesText = ""
        intervalQuantityText = ""
    }
}

private struct CancelButton: View {
    @Bindable var viewPreferences: ModificationViewPreferences
    let mode: ReminderModificationMode

    var body: some View {
        Button(
            action: {
                viewPreferences.showCancelAlert = true
            },
            label: {
                Text(L10n.Modification.cancel)
                    .frame(width: ViewConstants.modificationButtonSize)
            }
        )
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
    }

    private var alertTitle: String {
        if mode == .create {
            L10n.Modification.DiscardReminder.Create.title
        } else {
            L10n.Modification.DiscardReminder.Edit.title
        }
    }
}

private struct ReminderContentView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    @Binding var reminder: MutableReminder
    @Bindable var preferences: ReminderPreferences
    @Bindable var viewPreferences: ModificationViewPreferences
    @Bindable var fields: ModificationViewFields

    private let commandController: CommandController = .shared
    let mode: ReminderModificationMode
    let showNavigationButtons: Bool
    var onNextButtonClicked: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading) {
            ReminderContentOptionsView(
                reminder: reminder,
                preferences: preferences,
                fields: fields
            )

            Spacer().frame(height: ViewConstants.optionsSpacing)
            ReminderAudioOptionsView(
                reminder: reminder,
                preferences: preferences,
                viewPreferences: viewPreferences,
                useAudioFile: $preferences.useAudioFile
            )

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

            if showNavigationButtons {
                Spacer()
                HStack {
                    CancelButton(
                        viewPreferences: viewPreferences,
                        mode: mode
                    )
                    Spacer()
                    Button(
                        action: onNextButtonClicked,
                        label: {
                            Text("Next")
                                .frame(width: ViewConstants.modificationButtonSize)
                        }
                    )
                    .disabled(reminder.title.isEmpty)
                    .if(!reminder.title.isEmpty) { it in
                        it.buttonStyle(.borderedProminent)
                    }
                }
            } else {
                Spacer().frame(height: ViewConstants.optionsSpacing)
            }
        }
    }
}

private struct ReminderCreateView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    @Binding var reminder: MutableReminder
    @Binding var validationResult: ValidationResult
    @Bindable var preferences: ReminderPreferences
    @Bindable var viewPreferences: ModificationViewPreferences
    @Bindable var fields: ModificationViewFields
    private let schedulingPreferences: SchedulingPreferences = .shared

    let mode: ReminderModificationMode
    let buttonIsCancel: Bool
    let createNewReminder: () -> Void
    let onCreateButtonClicked: () -> Void
    let onBackButtonClicked: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: ViewConstants.horizontalSpacing) {
                ReminderDateView(
                    reminder: reminder,
                    preferences: preferences
                )

                ReminderOptionsView(
                    reminder: reminder,
                    preferences: preferences,
                    viewPreferences: viewPreferences,
                    fields: fields
                )
            }

            Spacer()
            HStack {
                if buttonIsCancel {
                    CancelButton(
                        viewPreferences: viewPreferences,
                        mode: mode
                    )
                } else {
                    Button(
                        action: onBackButtonClicked,
                        label: {
                            Text("Back")
                                .frame(width: ViewConstants.modificationButtonSize)
                        }
                    )
                }
                Spacer()
                createButton
            }
        }
    }

    @ViewBuilder
    var createButton: some View {
        Button(
            action: onCreateButtonClicked,
            label: {
                Text(finishButtonText)
                    .frame(width: ViewConstants.modificationButtonSize)
            }
        )
        .disabled(createButtonIsDisabled)
        .if(!createButtonIsDisabled) { it in
            it.buttonStyle(.borderedProminent)
        }
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
    }

    private var createButtonIsDisabled: Bool {
        reminder.title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }

    private var finishButtonText: String {
        mode == .create ? L10n.Modification.create : L10n.Modification.save
    }
}

struct ReminderModificationView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    @State var reminder: MutableReminder = .init()
    @State var preferences: ReminderPreferences = .init()
    @State var viewPreferences: ModificationViewPreferences = .init()
    @State var fields: ModificationViewFields = .init()
    @State private var validationResult: ValidationResult = .unset
    @State private var step: ReminderModificationStep = .content
    @State private var singleCreationView = false
    @ObservedObject private var controller: ReminderModificationController = .shared

    private let schedulingPreferences: SchedulingPreferences = .shared
    private let commandController: CommandController = .shared
    let mode: ReminderModificationMode

    var body: some View {
        activeView
            .onAppear {
                singleCreationView = AppPreferences.shared.singleModificationView
                guard mode == .edit else {
                    reminder.resetDates()
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
                    commandController.set(value: description, for: .descriptionCommand)
                }
            }
            .onDisappear {
                reminder.reset()
                preferences.reset()
                fields.reset()
                dismissWindow(id: WindowIds.reminderCommand)
                controller.modificationWindowOpen = false
            }
            .onChange(of: viewPreferences.closeView) {
                // For some reason, dismissing the window after the alert has closed
                // or in this closure does not work.
                // Therefore, it is necessary to close the window itself instead
                if viewPreferences.closeView {
                    NSApp.keyWindow?.close()
                    dismissWindow(id: WindowIds.reminderCommand)
                    viewPreferences.closeView = false
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .refreshModificationWindow)) { _ in
                viewPreferences.refreshView.toggle()
            }
            .onReceive(.descriptionCommand) { _ in
                reminder.description = commandController.value(for: .descriptionCommand)
            }
            .onReceive(.activationCommand) { _ in
                reminder.activationEvents.command = commandController.value(for: .activationCommand)
            }
            .onReceive(NotificationCenter.default.publisher(for: .openActiveReminderWindow)) { _ in
                openWindow(id: WindowIds.activeReminder)
            }
            .onReceive(NotificationCenter.default.publisher(for: .dismissActiveReminderWindow)) { _ in
                dismissWindow(id: WindowIds.activeReminder)
            }
            .navigationTitle(windowTitle)
            .frame(width: ViewConstants.reminderWindowWidth, height: windowHeight)
            .padding()
    }

    private var contentView: ReminderContentView {
        ReminderContentView(
            reminder: $reminder,
            preferences: preferences,
            viewPreferences: viewPreferences,
            fields: fields,
            mode: mode,
            showNavigationButtons: !singleCreationView,
            onNextButtonClicked: {
                step.forward()
            }
        )
    }

    private var createView: ReminderCreateView {
        ReminderCreateView(
            reminder: $reminder,
            validationResult: $validationResult,
            preferences: preferences,
            viewPreferences: viewPreferences,
            fields: fields,
            mode: mode,
            buttonIsCancel: singleCreationView,
            createNewReminder: createNewReminder,
            onCreateButtonClicked: create,
            onBackButtonClicked: {
                step.backward()
            }
        )
    }

    @ViewBuilder
    private var activeView: some View {
        if singleCreationView {
            VStack {
                contentView
                createView
            }
        } else {
            if step == .content {
                contentView
            } else {
                createView
            }
        }
    }

    private var windowHeight: CGFloat {
        if singleCreationView {
            ViewConstants.reminderWindowHeight * 2
        } else {
            ViewConstants.reminderWindowHeight
        }
    }

    private var windowTitle: String {
        if singleCreationView {
            WindowTitles.createReminder
        } else {
            step == .content ? WindowTitles.createFirstStep : WindowTitles.createFinalStep
        }
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

    private func create() {
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
    ReminderModificationView(
        reminder: .init(),
        preferences: .init(),
        viewPreferences: .init(),
        mode: .create
    )
}
