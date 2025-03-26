//
//  DualDatePickerView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 24/12/2024.
//

import SwiftUI

struct DualDatePicker {
    let displayedComponents: DatePickerComponents
    @Binding var earliestDate: Date
    @Binding var latestDate: Date
    
    private var earliestDateRange: ClosedRange<Date> {
        Date.distantPast...latestDate.subtractMinutes(1)
    }
    
    private var latestDateRange: ClosedRange<Date> {
        earliestDate.addMinutes(1)...Date.distantFuture
    }
    
    var earliestDatePicker: some View {
        DatePicker(
            "",
            selection: $earliestDate,
            displayedComponents: displayedComponents
        )
        .labelsHidden()
    }
    
    var latestDatePicker: some View {
        DatePicker(
            "",
            selection: $latestDate,
            in: latestDateRange,
            displayedComponents: displayedComponents
        )
        .labelsHidden()
    }
}

struct DualDatePickerView: View {
    let earliestHeading: String
    let latestHeading: String
    let picker: DualDatePicker
    
    var body: some View {
        VStack {
            Grid(alignment: .leading) {
                GridRow {
                    Text(earliestHeading)
                    picker.earliestDatePicker
                }
                GridRow {
                    Text(latestHeading)
                    picker.latestDatePicker
                }
            }
        }
        .frame(width: 250, height: 100)
    }
    
    init(earliestHeading: String, latestHeading: String, picker: DualDatePicker) {
        self.earliestHeading = earliestHeading
        self.latestHeading = latestHeading
        self.picker = picker
    }
    
    init(
        earliestHeading: String, latestHeading: String, 
        displayedComponents: DatePickerComponents, 
        earliestDate: Binding<Date>, latestDate: Binding<Date>
    ) {
        self.init(
            earliestHeading: earliestHeading,
            latestHeading: latestHeading,
            picker: DualDatePicker(
                displayedComponents: displayedComponents, 
                earliestDate: earliestDate,
                latestDate: latestDate
            )
        )
    }
}
