//
//  DualTimePickerView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 24/12/2024.
//

import SwiftUI

struct DualTimePickerView: View {
    private let earliestHeading = "Earliest time:"
    private let latestHeading = "Latest time:"
    @EnvironmentObject private var appPreferences: AppPreferences
    
    @Binding var earliestDate: Date
    @Binding var latestDate: Date
    
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
                        displayedComponents: .hourAndMinute
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
                        displayedComponents: .hourAndMinute
                    )
                    .disabled(appPreferences.quickReminderStarted)
                    .labelsHidden()
                }
            }
        }
        .frame(width: 200, height: 100)
    }
}
