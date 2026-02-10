//
//  Preview+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 22/4/2025.
//

import Foundation

extension ReminderManager {
    static func previewReminders() -> [RandomReminder] {
        manyReminders()
    }

    private static func oneReminder() -> [RandomReminder] {
        [
            RandomReminder(
                id: 1,
                title: "Single reminder",
                description: .text("Anything you want"),
                interval: ReminderDateInterval(
                    earliest: Date().subtractMinutes(40),
                    latest: Date().addSeconds(10),
                    repeatInterval: .hour,
                    repeatIntervalType: .after,
                    intervalQuantity: 3
                ),
                days: [.friday],
                totalOccurrences: 3
            )
        ]
    }

    private static func oneSoundReminder() -> [RandomReminder] {
        [
            RandomReminder(
                id: 1,
                title: "Makes noise",
                description: .text("How cool is this?"),
                interval: ReminderDateInterval(
                    earliest: Date(),
                    latest: Date().addMinutes(2),
                    repeatInterval: .never
                ),
                totalOccurrences: 6,
                activationEvents: ReminderActivationEvents(
                    audio: ReminderAudioFile(
                        name: "Symphony Jami",
                        url: URL(
                            filePath: "/Users/luca/Documents/Music Videos/Symphony Jami/Symphony No. 2 'Jami', KSS72_ I.mp3"
                        )! // swiftlint:disable:previous line_length
                    )
                )
            )
        ]
    }

    // swiftlint:disable:next function_body_length
    private static func manyReminders() -> [RandomReminder] {
        [
            RandomReminder(
                id: 1,
                title: "Posture check",
                description: .text("Text"),
                interval: ReminderDateInterval(
                    earliest: Date(),
                    latest: Date().addMinutes(3)
                ),
                totalOccurrences: 4
            ),
            RandomReminder(
                id: 2,
                title: "Check RandomReminder on GitHub",
                description: .text("Text"),
                interval: ReminderDateInterval(
                    earliest: Date().subtractMinutes(2).addSeconds(37),
                    latest: Date().addMinutes(5)
                ),
                totalOccurrences: 1
            ),
            RandomReminder(
                id: 3,
                title: "Posture check",
                description: .text("Text"),
                interval: ReminderDateInterval(
                    earliest: Date().addMinutes(2),
                    latest: Date().addMinutes(4)
                ),
                totalOccurrences: 1
            ),
            RandomReminder(
                id: 4,
                title: "Feed the chickens",
                description: .text("Text"),
                interval: ReminderDateInterval(
                    earliest: Date().subtractMinutes(2).addSeconds(5),
                    latest: Date().subtractMinutes(1).addSeconds(12)
                ),
                totalOccurrences: 1
            ),
            RandomReminder(
                id: 5,
                title: "Self check-in",
                description: .text("Text"),
                interval: ReminderDateInterval(
                    earliest: Date().subtractMinutes(30).addSeconds(9),
                    latest: Date().subtractMinutes(31).addSeconds(17)
                ),
                totalOccurrences: 1
            ),
            RandomReminder(
                id: 6,
                title: "Log some important data",
                description: .text("Text"),
                interval: ReminderDateInterval(
                    earliest: Date().subtractMinutes(6000).addSeconds(45),
                    latest: Date().subtractMinutes(6000).addSeconds(47)
                ),
                totalOccurrences: 1
            )
        ]
    }
}
