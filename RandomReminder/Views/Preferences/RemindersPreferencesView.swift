//
//  RemindersPreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import SwiftUI
import Settings
import Combine

private struct ReminderPreferencesRow: View {
    typealias PublishedTimer = Publishers.Autoconnect<Timer.TimerPublisher>
    
    @State private var reminder: RandomReminder
    @State private var reminderInfo: String
    @State private var showDeleteAlert = false
    
    @Binding private var editing: Bool
    private var timer: PublishedTimer
    
    var body: some View {
        HStack {
            Text(reminder.content.title)
            Spacer()
            if editing {
                Button("Edit") {}
                Button("Delete") {
                    showDeleteAlert = true
                }
                .alert(
                    "Are you sure you want to delete the reminder '\(reminder.content.title)'?",
                    isPresented: $showDeleteAlert
                ) {
                    Button("Cancel", role: .cancel) {}
                    Button("Delete", role: .destructive) {
                        withAnimation {
                            ReminderManager.shared.removeReminder(reminder)
                        }
                        FancyLogger.info("Deleted reminder '\(reminder.content.title)'")
                    }
                } message: {
                    Text("Deleted reminders cannot be recovered.")
                }
            } else {
                Text(reminderInfo)
                    .frame(height: 20)
                    .foregroundStyle(.secondary)
                    .onReceive(timer) { _ in
                        reminderInfo = TimeInfoProvider(reminder: reminder).preferencesInfo()
                    }
            }
        }
        .padding(.all, 10)
        .padding(.horizontal, 5)
    }
    
    init(reminder: RandomReminder, updateTimer timer: PublishedTimer, editing: Binding<Bool>) {
        self.reminder = reminder
        self.reminderInfo = TimeInfoProvider(reminder: reminder).preferencesInfo()
        self.timer = timer
        self._editing = editing
    }
}

private struct ReminderPreferencesRows: View {
    @Binding private var editingReminders: Bool
    private let remindersProvider: () -> [RandomReminder]
    private let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    private let heading: String
    private let rowsBeforeScroll: UInt
    
    var body: some View {
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
        if AppPreferences.shared.showReminderCounts {
            HStack {
                Text(heading).font(.headline)
                Spacer()
                Text("Reminders: \(remindersCount)")
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
                ReminderPreferencesRow(reminder: reminder, updateTimer: timer, editing: $editingReminders)
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
    @StateObject var appPreferences: AppPreferences = .shared
    @StateObject var reminderManager: ReminderManager = .shared
    @State private var editingReminders = false
    
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        Settings.Container(contentWidth: 500) {
            Settings.Section(title: "") {
                VStack(alignment: .leading) {
                    ReminderPreferencesRows(
                        heading: "Upcoming reminders",
                        rowsBeforeScoll: ViewConstants.upcomingRemindersBeforeScroll,
                        editingReminders: $editingReminders,
                        remindersProvider: reminderManager.upcomingReminders()
                    )
                    .padding(.bottom, 10)
                    
                    ReminderPreferencesRows(
                        heading: "Past Reminders",
                        rowsBeforeScoll: ViewConstants.pastRemindersBeforeScroll,
                        editingReminders: $editingReminders,
                        remindersProvider: reminderManager.pastReminders()
                    )
                    .padding(.bottom, 10)
                }
                .padding(.bottom, 5)
                
                HStack {
                    if editingReminders {
                        Button("Create New Reminder") {}
                            .buttonStyle(.automatic)
                            .disabled(true)
                    } else {
                        Button("Create New Reminder") {
                            openWindow(id: WindowIds.createReminder)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    Spacer()
                    if editingReminders {
                        Button(action: {
                            editingReminders.toggle()
                        }, label: {
                            Text("Finish Editing")
                                .frame(width: 100)
                        })
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button(action: {
                            editingReminders.toggle()
                        }, label: {
                            Text("Edit Reminders")
                                .frame(width: 100)
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    RemindersPreferencesView()
}
