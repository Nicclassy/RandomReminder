//
//  ReminderNotification.swift
//  RandomReminder
//
//  Created by Luca Napoli on 14/2/2026.
//

import Foundation
import UserNotifications

struct ReminderNotification {
    enum Subtitle {
        case regular(String)
        case generated(String)
        case empty
        case failure(String)
        
        var didNotSuccessfullyGenerate: Bool {
            if case .failure = self { true } else { false }
        }
        
        var text: String {
            switch self {
            case let .regular(text), let .generated(text), let .failure(text):
                text
            case .empty:
                " "
            }
        }
    }
    
    let title: String
    let subtitle: Subtitle
    let reminder: RandomReminder
    
    static func create(for reminder: RandomReminder) -> Self {
        switch reminder.content.description {
        case let .text(subtitle):
            return .init(
                title: reminder.content.title,
                subtitle: subtitle.isEmpty ? .empty : .regular(subtitle),
                reminder: reminder
            )

        case let .command(command, generatesTitle):
            var subprocess = Subprocess(command: command)
            let result = subprocess.run()
            guard case .success = result else {
                FancyLogger.error("Command '\(command)' did not succeed, instead got \(result)")
                return .init(
                    title: reminder.content.title,
                    subtitle: .failure(subprocess.stderr),
                    reminder: reminder
                )
            }

            guard generatesTitle else {
                return .init(
                    title: reminder.content.title,
                    subtitle: .generated(subprocess.stdout),
                    reminder: reminder
                )
            }

            // If it generates title: first line = title, remainder = subtitle (optional)
            let parts = subprocess.stdout.split(separator: "\n", maxSplits: 1).map(String.init)
            let title = parts.first ?? reminder.content.title
            return .init(
                title: title,
                subtitle: parts.count > 1 ? .generated(parts[1]) : .empty,
                reminder: reminder
            )
        }
    }
    
    func createRequest() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle.text
        content.sound = .default
        content.userInfo = ["reminderId": reminder.id.value]

        return UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
    }
}
