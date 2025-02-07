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
    
    @Binding var earliestDate: Date
    @Binding var latestDate: Date
    @Binding var active: Bool
    
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
                    .disabled(!active)
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
                    .disabled(!active)
                    .labelsHidden()
                }
            }
        }
        .frame(width: 250, height: 100)
    }
}
