//
//  ReminderCreationView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 13/2/2025.
//

import SwiftUI

struct ReminderCreationView: View {
    @StateObject private var reminderBuilder = ReminderBuilder()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Create new reminder")
                .font(.title2)
            Text("Reminder title:")
            TextField("Title", text: $reminderBuilder.title)
            
            Text("Reminder description:")
            TextField("Description", text: $reminderBuilder.text)
            
            VStack {
                Stepper("Number of reminders: \(reminderBuilder.totalReminders)", value: $reminderBuilder.totalReminders, in: 1...100)
                Toggle("Recurring", isOn: .constant(true))
            }
        }
        .padding()
    }
}

#Preview {
    ReminderCreationView()
}
