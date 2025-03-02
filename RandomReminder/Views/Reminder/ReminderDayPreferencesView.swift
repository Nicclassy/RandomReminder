//
//  ReminderDayPreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 22/2/2025.
//

import SwiftUI

struct ReminderDayPreferencesView: View {
    @ObservedObject var reminder: ReminderBuilder
    @ObservedObject var preferences: ReminderPreferences
    
    var body: some View {
        VStack(alignment: .leading) {
            Toggle("Remind only on specific days", isOn: $preferences.specificDays)
                .popover(isPresented: $preferences.specificDays) {
                    Grid(alignment: .leading) {
                        let chunkedDays = ReminderDayOptions.allCases.chunked(
                            ofCount: ReminderConstants.reminderDayChunkSize
                        )
                        ForEach(chunkedDays.indices, id: \.self) { i in
                            let chunk = chunkedDays[i]
                            GridRow {
                                ForEach(chunk.indices, id: \.self) { j in
                                    let day = chunk[j]
                                    Toggle(day.name, isOn: .init(
                                        get: { reminder.days.contains(day) },
                                        set: { toggleEnabled in
                                            if toggleEnabled {
                                                reminder.days.insert(day)
                                            } else {
                                                reminder.days.remove(day)
                                            }
                                        }
                                    ))
                                }
                            }
                            .frame(width: 100, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }
        }
        .disabled(preferences.alwaysRunning)
    }
}

#Preview {
    ReminderDayPreferencesView(reminder: .init(), preferences: .init())
}
