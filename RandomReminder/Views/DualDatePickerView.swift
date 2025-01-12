//
//  DualDatePickerView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 24/12/2024.
//

import SwiftUI

struct DualDatePickerView: View {
    let earliestHeading: String
    let latestHeading: String
    let displayedComponents: DatePickerComponents
    
    @EnvironmentObject private var appPreferences: AppPreferences
    
    @Binding var earliestDate: Date
    @Binding var latestDate: Date
    
    // Limiting the chosen dates to be within these ranges has the disadvantage
    // that reminders cannot be across multiple days. However,
    // this has the advantage that the dates are much easier to validate and it is
    // guaranteed that the earliest date is before the latest date
    var earliestDateRange: ClosedRange<Date> {
        Date.distantPast...latestDate.subtractMinutes(1)
    }
    
    var latestDateRange: ClosedRange<Date> {
        earliestDate.addMinutes(1)...Date.distantFuture
    }
    
    var body: some View {
        VStack {
            Grid(alignment: .leading) {
                GridRow {
                    Text(earliestHeading)
                    DatePicker(
                        "",
                        selection: $earliestDate,
                        displayedComponents: displayedComponents
                    )
                    .disabled(appPreferences.quickReminderStarted)
                    .labelsHidden()
                }
                GridRow {
                    Text(latestHeading)
                    DatePicker(
                        "",
                        selection: $latestDate,
                        in: latestDateRange,
                        displayedComponents: displayedComponents
                    )
                    .disabled(appPreferences.quickReminderStarted)
                    .labelsHidden()
                }
            }
        }
        .frame(width: 250, height: 100)
    }
}
