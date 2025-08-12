//
//  RemindersPreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import Combine
import Settings
import SwiftUI

private struct ReminderPreferencesRow: View {
    fileprivate typealias PublishedTimer = Publishers.Autoconnect<Timer.TimerPublisher>

    @State private var reminder: RandomReminder
    @State private var reminderInfo: String
    @State private var timeInfoProvider: TimeInfoProvider
    @State private var showDeleteAlert = false

    @ObservedObject private var controller: ReminderModificationController = .shared
    @Environment(\.openWindow) private var openWindow
    @Binding private var editing: Bool

    private var timer: PublishedTimer
    private var parentNumberOfRows: Int
    private var parentRowsBeforeScroll: UInt

    var body: some View {
        HStack {
            Text(reminder.content.title)
            Spacer()
            if editing {
                Button(L10n.Preferences.Reminders.Rows.edit) {
                    FancyLogger.info("Edit window opened")
                    ReminderModificationController.shared.reminder = reminder
                    openWindow(id: WindowIds.editReminder)
                    controller.modificationWindowOpen = true
                }
                .disabled(controller.modificationWindowOpen)

                Button(L10n.Preferences.Reminders.Rows.delete) {
                    showDeleteAlert = true
                }
                .disabled(controller.modificationWindowOpen)
                .alert(
                    L10n.Preferences.Reminders.Rows.deleteAlert(reminder.content.title),
                    isPresented: $showDeleteAlert
                ) {
                    Button(L10n.Preferences.Reminders.Rows.cancel, role: .cancel) {}
                    Button(L10n.Preferences.Reminders.Rows.delete, role: .destructive) {
                        if parentNumberOfRows > Int(parentRowsBeforeScroll) {
                            withAnimation(.default) {
                                controller.postRefreshRemindersNotification()
                                ReminderManager.shared.removeReminder(reminder)
                            }
                        } else {
                            // We do not want to animate the rows if the reminder is deleted
                            // when there are few rows, because this animation looks very strange
                            controller.postRefreshRemindersNotification()
                            ReminderManager.shared.removeReminder(reminder)
                        }

                        FancyLogger.info("Deleted reminder '\(reminder.content.title)'")
                    }
                } message: {
                    Text(L10n.Preferences.Reminders.Rows.deleteCaption)
                }
            } else {
                Text(reminderInfo)
                    .frame(height: 20)
                    .foregroundStyle(.secondary)
                    .onReceive(timer) { _ in
                        updateText()
                    }
                    .onReceive(NotificationCenter.default.publisher(for: .updateReminderPreferencesText)) { _ in
                        updateText()
                    }
            }
        }
        .padding(.all, 10)
        .padding(.horizontal, 5)
    }

    init(
        reminder: RandomReminder,
        updateTimer timer: PublishedTimer,
        parentNumberOfRows: Int,
        parentRowsBeforeScroll: UInt,
        editing: Binding<Bool>
    ) {
        let timeInfoProvider = TimeInfoProvider(reminder: reminder)
        self.reminder = reminder
        self.timeInfoProvider = timeInfoProvider
        self.reminderInfo = timeInfoProvider.preferencesInfo()
        self.timer = timer
        self.parentNumberOfRows = parentNumberOfRows
        self.parentRowsBeforeScroll = parentRowsBeforeScroll
        self._editing = editing
    }

    private func updateText() {
        let todaysDay = ReminderManager.shared.todaysDay
        reminderInfo = if ActiveReminderManager.shared.reminderIsActive(reminder) {
            L10n.Preferences.Reminders.Rows.notificationIsPresent
        } else if SchedulingPreferences.shared.remindersArePaused {
            L10n.Preferences.Reminders.Rows.paused
        } else if reminder.eponymous && !reminder.days.contains(todaysDay) && !reminder.hasPast {
            L10n.Preferences.Reminders.Rows.resumesOn(reminder.days.nextOccurringDay())
        } else {
            timeInfoProvider.preferencesInfo()
        }
    }
}

private struct ReminderPreferencesRows: View {
    @ObservedObject private var appPreferences: AppPreferences = .shared
    @Binding private var editingReminders: Bool
    private let remindersProvider: () -> [RandomReminder]
    private let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()

    private let heading: String
    private let rowsBeforeScroll: UInt

    var body: some View {
        Group {
            let reminders = remindersProvider()
            if !reminders.isEmpty {
                VStack(alignment: .leading) {
                    rowsHeading(remindersCount: reminders.count)
                        .padding(.bottom, 5)
                    if reminders.count > rowsBeforeScroll {
                        ScrollView {
                            rows(reminders: reminders)
                        }
                        .frame(height: frameHeight(for: reminders.count))
                    } else {
                        rows(reminders: reminders)
                            .frame(height: frameHeight(for: reminders.count))
                    }
                }
            }
        }
    }

    init(
        heading: String,
        rowsBeforeScoll: UInt,
        editingReminders: Binding<Bool>,
        remindersProvider: @autoclosure @escaping () -> [RandomReminder]
    ) {
        self.heading = heading
        self.rowsBeforeScroll = rowsBeforeScoll
        self.remindersProvider = remindersProvider
        self._editingReminders = editingReminders
    }

    @ViewBuilder
    private func rowsHeading(remindersCount: Int) -> some View {
        if appPreferences.showReminderCounts {
            HStack {
                Text(heading).font(.headline)
                Spacer()
                Text(L10n.Preferences.Reminders.remindersCount(remindersCount))
            }
        } else {
            Text(heading).font(.headline)
        }
    }

    private func frameHeight(for numberOfRows: Int) -> CGFloat {
        ViewConstants.reminderRowHeight * CGFloat(
            min(UInt(numberOfRows), rowsBeforeScroll)
        )
    }

    private func rows(reminders: [RandomReminder]) -> some View {
        VStack {
            Divider().opacity(0)
            ForEach(reminders.enumeratedArray(), id: \.1.id) { index, reminder in
                let dividerIsInvisible = index == reminders.endIndex - 1
                ReminderPreferencesRow(
                    reminder: reminder,
                    updateTimer: timer,
                    parentNumberOfRows: reminders.count,
                    parentRowsBeforeScroll: rowsBeforeScroll,
                    editing: $editingReminders
                )
                Divider().opacity(dividerIsInvisible ? 0 : 1)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.quaternary)
                .stroke(.quaternary, lineWidth: 1)
        )
    }
}

struct RemindersPreferencesView: View {
    @State private var editingReminders = false
    @ObservedObject private var controller: ReminderModificationController = .shared
    private let reminderManager: ReminderManager = .shared

    @Environment(\.openWindow) private var openWindow

    var body: some View {
        Settings.Container(contentWidth: 500) {
            Settings.Section(title: "") {
                VStack(alignment: .leading) {
                    ReminderPreferencesRows(
                        heading: L10n.Preferences.Reminders.upcoming,
                        rowsBeforeScoll: ViewConstants.upcomingRemindersBeforeScroll,
                        editingReminders: $editingReminders,
                        remindersProvider: reminderManager.upcomingReminders()
                    )
                    .padding(.bottom, 10)

                    ReminderPreferencesRows(
                        heading: L10n.Preferences.Reminders.past,
                        rowsBeforeScoll: ViewConstants.pastRemindersBeforeScroll,
                        editingReminders: $editingReminders,
                        remindersProvider: reminderManager.pastReminders()
                    )
                    .padding(.bottom, 10)
                }
                .padding(.bottom, 5)

                HStack {
                    Button(L10n.Preferences.Reminders.createNew) {
                        openWindow(id: WindowIds.createReminder)
                        controller.modificationWindowOpen = true
                    }
                    .if(!controller.modificationWindowOpen && !editingReminders) { it in
                        it.buttonStyle(.borderedProminent)
                    }
                    .if(controller.modificationWindowOpen || editingReminders) { it in
                        it.disabled(true)
                    }
                    Spacer()
                    if editingReminders {
                        Button(action: {
                            editingReminders.toggle()
                        }, label: {
                            Text(L10n.Preferences.Reminders.finishEditing)
                                .frame(width: 100)
                        })
                        .if(!controller.modificationWindowOpen) { it in
                            it.buttonStyle(.borderedProminent)
                        }
                        .disabled(controller.modificationWindowOpen)
                    } else {
                        Button(action: {
                            editingReminders.toggle()
                        }, label: {
                            Text(L10n.Preferences.Reminders.edit)
                                .frame(width: 100)
                        })
                        .disabled(controller.modificationWindowOpen)
                    }
                }
            }
        }
        .onDisappear {
            if editingReminders {
                FancyLogger.info("Finishing editing")
                editingReminders.toggle()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .refreshReminders)) { _ in
            FancyLogger.info("Refresh reminders notification received")
            withAnimation {
                controller.refreshReminders.toggle()
            }
        }
    }
}

#Preview {
    RemindersPreferencesView()
}
