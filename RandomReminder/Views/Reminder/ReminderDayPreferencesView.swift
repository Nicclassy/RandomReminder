//
//  ReminderDayPreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 22/2/2025.
//

import SwiftUI

struct ReminderDayPreferencesView: View {
    @ObservedObject var reminder: MutableReminder
    @ObservedObject var preferences: ReminderPreferences
    
    var body: some View {
        VStack(alignment: .leading) {
            Toggle("Remind only on specific days", isOn: $preferences.specificDays)
                .onChange(of: preferences.specificDays) {
                    preferences.showSpecificDaysPopover = $1
                }
                .popover(isPresented: $preferences.showSpecificDaysPopover) {
                    VStack(alignment: .leading) {
                        Grid(alignment: .leading) {
                            let chunkedDays = ReminderDayOptions.allCases.chunked(
                                ofCount: ReminderConstants.reminderDayChunkSize
                            )
                            ForEach(chunkedDays.indices, id: \.self) { i in
                                let chunk = chunkedDays[i]
                                GridRow {
                                    ForEach(chunk.indices, id: \.self) { j in
                                        let day = chunk[j]
                                        Toggle(day.name, isOn: Binding(
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
                        .padding(.bottom, 10)
                        
                        HStack {
                            Button(action: {
                                preferences.showSpecificDaysPopover = false
                            }) {
                                Text("Done")
                                    .frame(width: 50)
                            }
                            .buttonStyle(.borderedProminent)
                            Button(action: {
                                reminder.days = []
                            }) {
                                Text("Reset")
                                    .frame(width: 50)
                            }
                        }
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
