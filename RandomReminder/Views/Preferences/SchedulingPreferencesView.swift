//
//  SchedulingPreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 5/1/2025.
//

import SwiftUI

enum DefaultReminderTimesMode: Codable, EnumRawRepresentable {
    case exact
    case offsets
}

private struct TimeUnitWithQuantityView: View {
    @Binding var quantity: Int
    @Binding var selection: TimeUnit
    let permittedUnits: [TimeUnit]

    var body: some View {
        HStack {
            StepperTextField(
                value: $quantity,
                range: 0...59
            )
            .multilineTextAlignment(.trailing)

            Picker("", selection: $selection) {
                ForEach(permittedUnits, id: \.self) { unit in
                    let unitName = unit.name(for: quantity)
                    Text(unitName).tag(unit)
                }
            }
            .labelsHidden()
            .frame(width: 100)
        }
    }
}

private struct ExactReminderTimesView: View {
    @ObservedObject var schedulingPreferences: SchedulingPreferences = .shared

    var body: some View {
        VStack(alignment: .leading) {
            let picker = DualDatePicker(
                displayedComponents: .hourAndMinute,
                earliestDate: defaultEarliestDate,
                latestDate: defaultLatestDate
            )

            HStack {
                Text(L10n.TimePicker.EarliestDefaultTime.heading)
                Spacer()
                picker.earliestDatePicker
            }
            .padding(.leading, 20)

            VStack(alignment: .leading) {
                HStack {
                    Text(L10n.TimePicker.LatestDefaultTime.heading)
                    Spacer()
                    picker.latestDatePicker
                }

                CaptionText(multilineString {
                    "Reminders will have these times as their initial start/end times "
                    "during the creation process."
                })
                .fixedSize(horizontal: false, vertical: true)
            }
            .onAppear {
                if schedulingPreferences.defaultEarliestTime == 0 {
                    schedulingPreferences.defaultEarliestTime = Date.startOfDay().timeIntervalSince1970
                }

                if schedulingPreferences.defaultLatestTime == 0 {
                    schedulingPreferences.defaultLatestTime = Date.endOfDay().timeIntervalSince1970
                }
            }
            .padding(.leading, 20)
        }
    }

    private var defaultEarliestDate: Binding<Date> {
        Binding(
            get: { Date(timeIntervalSince1970: schedulingPreferences.defaultEarliestTime) },
            set: { schedulingPreferences.defaultEarliestTime = $0.timeIntervalSince1970 }
        )
    }

    private var defaultLatestDate: Binding<Date> {
        Binding(
            get: { Date(timeIntervalSince1970: schedulingPreferences.defaultLatestTime) },
            set: { schedulingPreferences.defaultLatestTime = $0.timeIntervalSince1970 }
        )
    }
}

private struct OffsetReminderTimesView: View {
    private static let offsetUnits: [TimeUnit] = [.minute, .hour, .day]

    @ObservedObject private var schedulingPreferences: SchedulingPreferences = .shared

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Earliest: ")
                    .padding(.top, 5)
                    .padding(.leading, 20)
                Spacer()
                TimeUnitWithQuantityView(
                    quantity: schedulingPreferences.$earliestOffsetQuantity,
                    selection: schedulingPreferences.$earliestOffsetTimeUnit,
                    permittedUnits: Self.offsetUnits
                )
            }

            Spacer().frame(height: 10)

            HStack {
                Text("Latest (from earliest): ")
                    .padding(.leading, 20)
                Spacer()
                TimeUnitWithQuantityView(
                    quantity: latestOffsetQuantity,
                    selection: schedulingPreferences.$latestOffsetTimeUnit,
                    permittedUnits: Self.offsetUnits
                )
            }

            CaptionText(multilineString {
                "The initial earliest time of a reminder during creation is determined by "
                "applying the specified offset to the current time, "
                "and the latest by appling the specified offset to the earliest time."
            })
            .padding(.leading, 20)
            .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var latestOffsetQuantity: Binding<Int> {
        .init(
            get: { max(schedulingPreferences.latestOffsetQuantity, 1) },
            set: { schedulingPreferences.latestOffsetQuantity = max($0, 1) }
        )
    }
}

struct SchedulingPreferencesView: View {
    @ObservedObject var schedulingPreferences: SchedulingPreferences = .shared
    @ObservedObject var appPreferences: AppPreferences = .shared

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Default reminder times mode: ")
                            .padding(.leading, 20)
                            .padding(.bottom, 2)
                        Spacer()
                        Picker("", selection: schedulingPreferences.$defaultReminderTimesMode) {
                            Text("Exact").tag(DefaultReminderTimesMode.exact)
                            Text("Offsets").tag(DefaultReminderTimesMode.offsets)
                        }
                        .labelsHidden()
                        .frame(width: 90)
                    }

                    ViewWithTallerHeightOfTwo(
                        ExactReminderTimesView(),
                        OffsetReminderTimesView(),
                        showFirst: showFirst
                    )
                }
            }

            Spacer().frame(height: ViewConstants.preferencesSpacing)

            Section {
                ToggleablePreference(
                    caption: multilineString {
                        "Reminders never occur simultaneously. "
                        "Control the time between one reminder's occurrence and the next "
                        "when multiple reminders are scheduled to occur."
                    },
                    isOn: schedulingPreferences.$notificationGapEnabled
                ) {
                    VStack(alignment: .leading) {
                        Text("Allow time between reminders")

                        HStack {
                            Text("Minimum time:")
                                .padding(.trailing, -5)
                            TimeUnitWithQuantityView(
                                quantity: $schedulingPreferences.notificationGapTime,
                                selection: $schedulingPreferences.notificationGapTimeUnit,
                                permittedUnits: [.second, .minute, .hour, .day]
                            )
                            .disabled(!schedulingPreferences.notificationGapEnabled)
                        }
                    }
                }
            }

            Section {
                ToggleablePreference(isOn: schedulingPreferences.$notificationAutoDismissEnabled) {
                    VStack(alignment: .leading) {
                        Text("Automatically dismiss reminder notifications")

                        HStack {
                            Text("After")
                                .padding(.trailing, -5)
                            TimeUnitWithQuantityView(
                                quantity: notificationAutoDismissTime,
                                selection: $schedulingPreferences.notificationAutoDismissTimeUnit,
                                permittedUnits: [.second, .minute]
                            )
                            .disabled(!schedulingPreferences.notificationAutoDismissEnabled)
                        }
                    }
                }
            }

            Section {
                Spacer().frame(maxHeight: .infinity)
            }
        }
        .mediumFrame()
        .padding()
    }

    private var notificationAutoDismissTime: Binding<Int> {
        Binding(
            get: { max(schedulingPreferences.notificationAutoDismissTime, 1) },
            set: { schedulingPreferences.notificationAutoDismissTime = max($0, 1) }
        )
    }

    private var showFirst: Binding<Bool> {
        .init(get: { schedulingPreferences.defaultReminderTimesMode == .exact }, set: { _ in })
    }
}

#Preview {
    SchedulingPreferencesView()
}
