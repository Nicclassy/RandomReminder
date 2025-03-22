//
//  ReminderManagerView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 18/1/2025.
//

import SwiftUI

func reminderPreview() -> RandomReminder {
    RandomReminder(title: "Hello", text: "You are here!", interval: ReminderDateInterval(earliestDate: Date(), latestDate: Date().addMinutes(1)), totalOccurences: 3)
}

struct ReminderManagerView: View {
    @State private var reminder = reminderPreview()
    
    var body: some View {
        VStack {
            Text("Title: " + reminder.content.title)
            Button("Load reminder") {
                reminder = ReminderSerializer.load(filename: "1.json")!
            }
            Button("Save reminder") {
                ReminderSerializer.save(reminder, filename: reminder.filename())
            }
        }
        .frame(width: 200, height: 100)
        .padding()
    }
}

#Preview {
    ReminderManagerView()
}
