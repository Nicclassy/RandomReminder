//
//  NotificationManager.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/3/2025.
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private let schedulingPreferences: SchedulingPreferences = .shared
    private let queue = DispatchQueue(label: Constants.bundleID + ".notificationQueue", qos: .utility)
    private let notificationCentre: UNUserNotificationCenter = .current()

    private init() {}

    func addReminderNotification(for service: ActiveReminderService) {
        let content = UNMutableNotificationContent()
        let reminder = service.reminder

        content.title = reminder.content.title
        let subtitle = if case let .text(text) = reminder.content.description {
            text
        } else if case let .command(text) = reminder.content.description {
            text
        } else {
            fatalError("Unreachable code")
        }
        if !subtitle.isEmpty {
            content.subtitle = subtitle
                + " (\(reminder.counts.occurences)/\(reminder.counts.totalOccurences))"
        }
        content.sound = .default
        content.userInfo = ["reminderId": reminder.id.value]

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        FancyLogger.info("Waiting to add request of reminder '\(reminder)' to the queue")

        queue.async { [self] in
            FancyLogger.error("Processing for \(service.reminder)")
            let semaphore = DispatchSemaphore(value: 0)
            Task {
                await processNotification(for: service, with: request)
                semaphore.signal()
            }
            semaphore.wait()
        }
    }

    private func notificationIsPresent(for reminder: RandomReminder) async -> Bool {
        await withCheckedContinuation { continuation in
            notificationCentre.getDeliveredNotifications { notifications in
                for notification in notifications {
                    let notificationUserInfo = notification.request.content.userInfo
                    guard let notificationReminderId = notificationUserInfo["reminderId"] as? Int else {
                        FancyLogger.warn("Notification does not contain the required userInfo key")
                        continue
                    }

                    if reminder.id == notificationReminderId {
                        continuation.resume(returning: true)
                        return
                    }
                }

                continuation.resume(returning: false)
            }
        }
    }

    private func processNotification(
        for reminderService: ActiveReminderService,
        with request: UNNotificationRequest
    ) async {
        // An important point before this lengthy explanation.
        // Swift really should have a way to do something when a notification appears/
        // when it disappears. But it does not!
        // So here we are!

        // This is a bit of an inelegant solution but it works.
        // UNNotificationDelegate does not notify the user when
        // a notification has disappeared
        // (there are may ways in which a notification can disappear,
        // but UNNotificationDelegate only informs the program
        // if the user clicks on the notification, not if they swipe it/click X),
        // so this solution will suffice for now.
        let reminder = reminderService.reminder
        guard !ReminderModificationController.shared.isEditingReminder(with: reminder.id) else {
            // Do not remind
            FancyLogger.info("Cannot reminder '\(reminder)' because it is being edited")
            return
        }

        // Eventually, we need to check if the reminder is past. This
        // will be tricky

        do {
            try await notificationCentre.add(request)
        } catch {
            FancyLogger.error("Error adding notifiation:", error)
            return
        }

        // May not have appeared yet. Wait to confirm it appears.
        // This may not seem necessary, but there is sometimes a delay
        // between when the notification request is added
        // and when it actually appears.
        while await !notificationIsPresent(for: reminder) {
            try? await Task.sleep(nanoseconds: 50_000_000)
        }

        // Has appeared
        await MainActor.run {
            FancyLogger.info("🟩 Notification appeared 🟩")
            reminderService.onNotificationAppear()
        }
        // Now, wait until it disappears

        while await notificationIsPresent(for: reminder) {
            try? await Task.sleep(nanoseconds: 500_000_000)
        }

        // Notification has disappeared
        await MainActor.run {
            reminderService.onNotificationDisappear()
            FancyLogger.info("🟦 Notification disappeared 🟦")
        }

        if schedulingPreferences.notificationGapEnabled {
            let notificationGap = UInt64(
                schedulingPreferences.notificationGapTime
                    * Int(schedulingPreferences.notificationGapTimeUnit.timeInterval)
            )
            FancyLogger.info("Sleeping for \(notificationGap) seconds")
            try? await Task.sleep(nanoseconds: notificationGap * 1_000_000_000)
        }
        FancyLogger.error("Finished processing notification for '\(reminder)'")
    }
}
