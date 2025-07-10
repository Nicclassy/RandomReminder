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

    private var presentReminder: RandomReminder?
    private let schedulingPreferences: SchedulingPreferences = .shared
    private let queue = DispatchQueue(label: Constants.bundleID + ".notificationQueue", qos: .utility)
    private let notificationCentre: UNUserNotificationCenter = .current()

    private init() {}

    func addReminderNotification(for service: ActiveReminderService) {
        FancyLogger.info("Waiting to add request of reminder '\(service.reminder)' to the queue")
        queue.async { [self] in
            let reminder = service.reminder
            let content = UNMutableNotificationContent()

            let (title, subtitle) = notificationTitleAndSubtitle(for: reminder)
            content.title = title
            if let subtitle {
                content.subtitle = subtitle
            }
            content.sound = .default
            content.userInfo = ["reminderId": reminder.id.value]

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            let semaphore = DispatchSemaphore(value: 0)
            Task {
                FancyLogger.error("Processing for \(service.reminder)")
                await processNotification(for: service, with: request)
                semaphore.signal()
            }
            semaphore.wait()
        }
    }

    func reminderNotificationIsPresent(for reminder: RandomReminder) -> Bool {
        reminder == presentReminder
    }

    private func notificationTitleAndSubtitle(for reminder: RandomReminder) -> (title: String, subtitle: String?) {
        switch reminder.content.description {
        case let .text(subtitle):
            return (reminder.content.title, subtitle)
        case let .command(command, generatesTitle):
            var subprocess = Subprocess(command: command)
            let result = subprocess.run()
            if result != .success {
                FancyLogger.error("Command '\(command)' did not succeed, instead got \(result)")
            }

            guard generatesTitle else {
                return (reminder.content.title, subprocess.stdout)
            }

            let parts = subprocess.stdout.split(separator: "\n", maxSplits: 1).map(String.init)
            guard let title = parts.first else {
                return (reminder.content.title, nil)
            }
            let subtitle = parts.count == 1 ? nil : parts[1]
            return (title, subtitle)
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

    private func reminderCanOccur(_ reminder: RandomReminder) -> Bool {
        guard ReminderManager.shared.reminderExists(reminder) else {
            FancyLogger.info("Reminder '\(reminder)' no longer exists")
            return false
        }

        guard !ReminderModificationController.shared.isEditingReminder(with: reminder.id) else {
            FancyLogger.info("Reminder '\(reminder)' cannot occur because it is being edited")
            return false
        }

        guard !reminder.hasPast else {
            FancyLogger.info("Reminder '\(reminder)' had a scheduled notification but has past")
            return false
        }

        guard ReminderManager.shared.reminderCanActivate(reminder) else {
            FancyLogger.info("Reminder '\(reminder)' cannot activate and therefore cannot occur")
            return false
        }

        return true
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
        // At least by using a Task instead of GCD based synchronisation,
        // we can use Task.sleep instead of Thread.sleep for waiting for things.
        // This isn't a major issue, but when a (Thread.)sleep for 1 hour might be required
        // between notifications, it might be problematic
        let reminder = reminderService.reminder
        guard reminderCanOccur(reminder) else {
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
            presentReminder = reminder
            FancyLogger.info("🟩 Notification appeared 🟩")
            reminderService.onNotificationAppear()
        }
        // Now, wait until it disappears

        while await notificationIsPresent(for: reminder) {
            try? await Task.sleep(nanoseconds: 500_000_000)
        }

        // Notification has disappeared
        await MainActor.run {
            presentReminder = nil
            reminderService.onNotificationDisappear()
            FancyLogger.info("🟦 Notification disappeared 🟦")
        }

        if schedulingPreferences.notificationGapEnabled {
            let notificationGapTimeInterval = Int(schedulingPreferences.notificationGapTimeUnit.timeInterval)
            let notificationGap = UInt64(
                schedulingPreferences.notificationGapTime * notificationGapTimeInterval
            )
            FancyLogger.info("Sleeping for \(notificationGap) seconds")
            try? await Task.sleep(nanoseconds: notificationGap * 1_000_000_000)
        }
        FancyLogger.error("Finished processing notification for '\(reminder)'")
    }
}
