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
    private var timer: PublishedTimer
    
    init(reminder: RandomReminder, updateTimer timer: PublishedTimer) {
        self.reminder = reminder
        self.reminderInfo = TimeInfoProvider(reminder: reminder).preferencesInfo()
        self.timer = timer
    }
    
    var body: some View {
        HStack {
            Text(reminder.content.title)
            Spacer()
            Text(reminderInfo)
                .foregroundStyle(.secondary)
                .onReceive(timer) { _ in
                    reminderInfo = TimeInfoProvider(reminder: reminder).preferencesInfo()
                }
        }
        .padding(.all, 8)
        .padding(.horizontal, 2)
    }
}

struct ReminderPreferencesRows: View {
    private let remindersProvider: () -> [RandomReminder]
    private let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    init(remindersProvider: @autoclosure @escaping () -> [RandomReminder]) {
        self.remindersProvider = remindersProvider
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
                .opacity(0)
            let reminders = remindersProvider()
            ForEach(reminders.enumeratedArray(), id: \.0) { index, reminder in
                let dividerIsInvisible = index == reminders.endIndex - 1
                ReminderPreferencesRow(reminder: reminder, updateTimer: timer)
                Divider()
                    .opacity(dividerIsInvisible ? 0 : 1)
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
    @StateObject var reminderManager: ReminderManager = .preview
    
    var body: some View {
        Settings.Container(contentWidth: 500) {
            Settings.Section(title: "") {
                VStack(alignment: .leading) {
                    Text("Upcoming Reminders")
                        .font(.headline)
                        .padding(.bottom, 5)
                    ReminderPreferencesRows(remindersProvider: reminderManager.reminders.lazy.filter { !$0.hasPast() })
                    
                    Text("Past Reminders")
                        .font(.headline)
                        .padding(.bottom, 5)
                        .padding(.top, 10)
                    ReminderPreferencesRows(remindersProvider: reminderManager.reminders.lazy.filter { $0.hasPast() })
                }
            }
        }
    }
}

#Preview {
    RemindersPreferencesView()
}
