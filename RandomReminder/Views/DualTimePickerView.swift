//
//  DualTimePickerView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 24/12/2024.
//

import SwiftUI

struct DualTimePickerView: View {
    let earliestHeading: String = "Earliest time:"
    let latestHeading: String = "Latest time:"
    @Binding var earliestDate: Date
    @Binding var latestDate: Date
    
    var earliestDateRange: ClosedRange<Date> {
        Date.distantPast...max(Date.distantPast, latestDate.subtractMinutes(1))
    }
        
    var latestDateRange: ClosedRange<Date> {
        min(earliestDate.addMinutes(1), Date.distantFuture)...Date.distantFuture
    }
    
    var body: some View {
        VStack {
            DatePicker(
                earliestHeading,
                selection: $earliestDate,
                in: earliestDateRange,
                displayedComponents: .hourAndMinute
            )
            DatePicker(
                latestHeading,
                selection: $latestDate,
                in: latestDateRange,
                displayedComponents: .hourAndMinute
            )
        }
        .padding()
    }
}
