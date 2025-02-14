//
//  ReminderCreationView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 13/2/2025.
//

import SwiftUI

struct ReminderCreationView: View {
    @StateObject private var builder = ReminderBuilder()
    @State private var recurringEnabled = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Create new reminder")
                .font(.title2)
            Text("Reminder title:")
            TextField("Title", text: $builder.title)
            
            Text("Reminder description:")
            TextField("Description", text: $builder.text)
            
            Grid {
                GridRow {
                    Text("Number of reminders:")
                    StepperTextField(value: $builder.totalReminders)
                        .frame(width: 55)
                    HStack(spacing: 0) {
                        Toggle("Recurring every", isOn: $recurringEnabled)
                        Picker("", selection: $builder.repeatInterval) {
                            ForEach(RepeatInterval.allCases, id: \.self) { value in
                                if value != .none {
                                    Text(String(describing: value)).tag(value)
                                }
                            }
                        }
                        .disabled(!recurringEnabled)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ReminderCreationView()
}
