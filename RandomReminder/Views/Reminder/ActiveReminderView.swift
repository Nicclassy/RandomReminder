//
//  ActiveReminderView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 10/8/2025.
//

import SwiftUI

// swiftlint:disable:next file_types_order
struct ActiveReminderView: View {
    private let lineLimit = 2

    var body: some View {
        VStack(alignment: .leading) {
            Text(activeReminderNotification.title)
                .font(.title3)
                .fontWeight(.bold)
                .lineLimit(lineLimit)
                .fixedSize(horizontal: false, vertical: true)
            ScrollView {
                if activeReminderNotification.subtitle.didNotSuccessfullyGenerate {
                    Text(activeReminderNotification.subtitle.text)
                        .foregroundStyle(.red)
                } else {
                    Text(activeReminderNotification.subtitle.text)
                }
            }
            Button(
                action: {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .dismissActiveReminderWindow, object: nil)
                    }
                },
                label: {
                    Text("OK")
                        .frame(maxWidth: .infinity)
                }
            )
            .buttonStyle(.borderedProminent)
            .frame(width: 90)
        }
        .frame(width: ViewConstants.mediumWindowWidth, height: ViewConstants.mediumWindowHeight)
        .padding()
    }

    private var activeReminderNotification: ReminderNotification {
        ActiveReminderManager.shared.activeReminderNotification
    }
}

private struct ActiveReminderViewPreview: View {
    var body: some View {
        ActiveReminderView()
    }

    init(success: Bool) {
        let title = "Active reminder title that is very long and has many characters"
        let description = multilineString {
            "This is a reminder description. "
            "It is a long description to test the capabilities of extending text.\n\n"
            "Let us see if the scroll view works and newlines work as desired."
        }

        var notification: ReminderNotification!
        if success {
            let reminder = MutableReminder()
            reminder.title = title
            reminder.description = .text(description)
            notification = ReminderNotification.create(for: reminder.build(preferences: .init()))
        } else {
            notification = ReminderNotification(
                title: title,
                subtitle: .failure(description + "\n\nThis one failed."),
                reminder: MutableReminder().build(preferences: .init())
            )
        }

        ActiveReminderManager.shared.activeReminderNotification = notification
    }
}

#Preview("Successful notification") {
    ActiveReminderViewPreview(success: true)
}

#Preview("Failed notification") {
    ActiveReminderViewPreview(success: false)
}
