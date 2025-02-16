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
    
    @State private var earliestDate: Date = Date()
    @State private var latestDate: Date = Date().addMinutes(60)
    
    var totalRemindersRange: ClosedRange<Int> {
        ReminderConstants.minReminders...ReminderConstants.maxReminders
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Create new reminder")
                .font(.title2)
            Text("Reminder title:")
            TextField("Title", text: $builder.title)
            
            Text("Reminder description:")
            TextField("Description", text: $builder.text)
            
            Grid(alignment: .leading) {
                GridRow {
                    HStack {
                        Text("Number of reminders:")
                        StepperTextField(value: $builder.totalReminders, range: totalRemindersRange)
                            .frame(width: 55)
                    }
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
                        .frame(width: 120)
                    }
                }
                
                GridRow {
                    Text("Earliest date:")
                    Text("Latest date:")
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                GridRow {
                    let picker = DualDatePicker(
                        displayedComponents: [.date, .hourAndMinute],
                        earliestDate: $earliestDate, latestDate: $latestDate,
                        active: .constant(true)
                    )
                    
                    VStack {
                        picker.earliestDatePicker
                    }
                    VStack {
                        picker.latestDatePicker
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .border(.blue)
        .padding()
    }
}

#Preview {
    ReminderCreationView()
}
