//
//  RemindersPreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import SwiftUI
import Settings

struct ReminderPreferencesRow: View {
    @State private var reminder: RandomReminder
    
    init(reminder: RandomReminder) {
        self.reminder = reminder
    }
    
    var body: some View {
        HStack {
            Text(reminder.content.title)
            Spacer()
            Text(reminder.preferencesInformation())
                .foregroundStyle(.secondary)
        }
        .padding(.all, 8)
        .padding(.horizontal, 2)
    }
}

struct RemindersPreferencesView: View {
    @StateObject var appPreferences: AppPreferences = .shared
    @StateObject var reminderManager: ReminderManager = .preview
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Divider()
                    .opacity(0)
                ForEach(reminderManager.reminders.enumeratedArray(), id: \.0) { index, reminder in
                    let dividerIsInvisible = index == reminderManager.reminders.endIndex - 1
                    ReminderPreferencesRow(reminder: reminder)
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
        .padding()
    }
}

#Preview {
    RemindersPreferencesView()
}
