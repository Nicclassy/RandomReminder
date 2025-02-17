//
//  ReminderCreationView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 13/2/2025.
//

import SwiftUI

struct ReminderCreationView: View {
    @StateObject private var builder = ReminderBuilder()
    @State private var repeatingEnabled = false
    @State private var timesOnly = false
    
    @State private var showTimesOnlyHelpPopover = false
    
    @State private var earliestDate = Date()
    @State private var latestDate = Date().addMinutes(60)
    
    var totalRemindersRange: ClosedRange<Int> {
        ReminderConstants.minReminders...ReminderConstants.maxReminders
    }
    
    var earliestText: String {
        timesOnly ? "Earliest time:" : "Earliest date:"
    }
    
    var latestText: String {
        timesOnly ? "Latest time:" : "Latest date:"
    }
    
    var datePickerComponents: DatePickerComponents {
        timesOnly ? .hourAndMinute : [.date, .hourAndMinute]
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
                    VStack(alignment: .leading) {
                        HStack(spacing: 0) {
                            Toggle("Repeating every", isOn: $repeatingEnabled)
                            Picker("", selection: $builder.repeatInterval) {
                                ForEach(RepeatInterval.allCases, id: \.self) { value in
                                    if value != .none {
                                        Text(String(describing: value)).tag(value)
                                    }
                                }
                            }
                            .disabled(!repeatingEnabled)
                            .frame(width: 120)
                        }
                        HStack {
                            Toggle("Use times only", isOn: $timesOnly)
                            HelpLink() {
                                showTimesOnlyHelpPopover.toggle()
                            }
                            .popover(isPresented: $showTimesOnlyHelpPopover) {
                                Text("The created reminder will occur daily between the specified times.")
                                    .padding()
                            }
                        }
                    }
                }
                .padding(.bottom, 10)
                
                GridRow {
                    Text(earliestText)
                    Text(latestText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                GridRow {
                    let picker = DualDatePicker(
                        displayedComponents: datePickerComponents,
                        earliestDate: $earliestDate, latestDate: $latestDate,
                        enabled: .constant(true)
                    )
                    picker.earliestDatePicker
                    picker.latestDatePicker
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
