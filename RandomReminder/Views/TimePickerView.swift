//
//  TimePickerView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 24/12/2024.
//

import SwiftUI

struct TimePickerView: View {
    private let heading: String
    @Binding private var date: Date
    
    init(_ heading: String, selection date: Binding<Date>) {
        self.heading = heading
        self._date = date
    }
    
    var body: some View {
        DatePicker(
            heading,
            selection: $date,
            displayedComponents: .hourAndMinute
        )
        .padding()
    }
    
    static fileprivate var preview: Self {
        let date = Date()
        return Self("Preview", selection: .constant(date))
    }
}

#Preview {
    TimePickerView.preview
}
