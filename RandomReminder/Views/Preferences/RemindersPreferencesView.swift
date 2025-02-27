//
//  RemindersPreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import SwiftUI
import Settings
import Combine

struct ReminderPreferencesRow: View {
    typealias PublishedTimer = Publishers.Autoconnect<Timer.TimerPublisher>
    
    @State private var reminder: RandomReminder
    @State private var reminderInfo: String
    @State private var showDeleteAlert = false
    
    @Binding private var editing: Bool
    private var timer: PublishedTimer
    
    init(reminder: RandomReminder, updateTimer timer: PublishedTimer, editing: Binding<Bool>) {
        self.reminder = reminder
        self.reminderInfo = TimeInfoProvider(reminder: reminder).preferencesInfo()
        self.timer = timer
        self._editing = editing
    }
    
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
                    Button("Delete", role: .destructive) {
                        withAnimation {
                            ReminderManager.shared.removeReminder(reminder)
                        }
                        FancyLogger.info("Deleted reminder '\(reminder.content.title)'")
                    }
                    Button("Cancel", role: .cancel) {}
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
        .padding(.all, 8)
        .padding(.horizontal, 2)
    }
}

struct ReminderPreferencesRows: View {
    @Binding private var editingReminders: Bool
    private let remindersProvider: () -> [RandomReminder]
    private let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    private let heading: String
    
    init(heading: String, editingReminders: Binding<Bool>, remindersProvider: @autoclosure @escaping () -> [RandomReminder]) {
        self.heading = heading
        self.remindersProvider = remindersProvider
        self._editingReminders = editingReminders
    }
    
    var body: some View {
        let reminders = remindersProvider()
        if !reminders.isEmpty {
            VStack(alignment: .leading) {
                Text(heading)
                    .font(.headline)
                    .padding(.bottom, 5)
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
    }
}

struct RemindersPreferencesView: View {
    @StateObject var appPreferences: AppPreferences = .shared
    @StateObject var reminderManager: ReminderManager = .shared
    @State private var editingReminders = false
    
    var body: some View {
        Settings.Container(contentWidth: 500) {
            Settings.Section(title: "") {
                VStack(alignment: .leading) {
                    ReminderPreferencesRows(
                        heading: "Upcoming reminders",
                        editingReminders: $editingReminders,
                        remindersProvider: reminderManager.upcomingReminders()
                    )
                    .padding(.bottom, 10)
                    
                    ReminderPreferencesRows(
                        heading: "Past Reminders",
                        editingReminders: $editingReminders,
                        remindersProvider: reminderManager.pastReminders()
                    )
                }
                .padding(.bottom, 15)
                
                HStack {
                    if editingReminders {
                        Button("Create New Reminder") {}
                            .buttonStyle(.automatic)
                            .disabled(true)
                    } else {
                        Button("Create New Reminder") {}
                            .buttonStyle(.borderedProminent)
                    }
                    Spacer()
                    if editingReminders {
                        // TODO: Size buttons the same
                        Button("Stop Editing") {
                            editingReminders.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button("Edit Reminders") {
                            editingReminders.toggle()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RemindersPreferencesView()
}
