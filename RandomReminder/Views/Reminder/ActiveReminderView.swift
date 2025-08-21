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
            Text(reminder.content.title)
                .font(.title3)
                .fontWeight(.bold)
                .lineLimit(lineLimit)
                .fixedSize(horizontal: false, vertical: true)
            ScrollView { Text(description) }
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
        }
        .padding()
        .centerWindowOnAppear(switchToWindow: true)
    }

    private var reminder: RandomReminder {
        ActiveReminderManager.shared.activeReminder
    }

    private var description: String {
        ActiveReminderManager.shared.activeReminderDescription
    }
}

private struct ActiveReminderViewPreview: View {
    var body: some View {
        ActiveReminderView()
    }

    init() {
        let reminder = MutableReminder()
        reminder.title = "Active reminder title that is very long and has many characters"
        ActiveReminderManager.shared.activeReminderDescription = (
            "This is a reminder description. " +
                "It is a long description to test the capabilities of extending text.\n\n" +
                "Let us see if the scroll view works and newlines work as desired."
        )
        ActiveReminderManager.shared.activeReminder = reminder.build(preferences: .init())
    }
}

#Preview {
    ActiveReminderViewPreview()
}
