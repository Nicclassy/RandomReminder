//
//  NotificationManager.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/3/2025.
//

import Foundation
import Semaphore
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private let schedulingPreferences: SchedulingPreferences = .shared
    private let clock = ContinuousClock()
    private let semaphore = AsyncSemaphore(value: 1)
    private let notificationCentre: UNUserNotificationCenter = .current()

    private init() {}

    func addReminderNotification(for service: ActiveReminderService) {
        let reminder = service.reminder
        FancyLogger.info("Waiting to add request of reminder '\(reminder)' to the queue")
        ActiveReminderManager.shared.markAsWaiting(reminder)

        Task {
            await semaphore.wait()
            defer {
                semaphore.signal()
            }

            let notification = ReminderNotification.create(for: reminder)
            FancyLogger.info("Processing for \(service.reminder)")
            await processNotification(notification, with: service)

            if schedulingPreferences.notificationGapEnabled {
                await notificationGap()
            }
            FancyLogger.error("Finished processing notification for '\(reminder)'")
        }
    }

    private func notificationIsPresent(for reminder: RandomReminder) async -> Bool {
        let notifications = await notificationCentre.deliveredNotifications()
        return notifications.contains { notification in
            if let notificationReminderId = notification.request.content.userInfo["reminderId"] as? Int {
                reminder.id == notificationReminderId
            } else {
                false
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

    private func autoDismissDeadline() -> ContinuousClock.Instant? {
        guard schedulingPreferences.notificationAutoDismissEnabled else {
            return nil
        }

        let seconds = schedulingPreferences.notificationAutoDismissTime
            * Int(schedulingPreferences.notificationAutoDismissTimeUnit.timeInterval)

        return clock.now + .seconds(seconds)
    }

    private func notificationGap() async {
        let notificationGapTimeInterval = schedulingPreferences.notificationGapTimeUnit.timeInterval
        let notificationGap = UInt64(
            schedulingPreferences.notificationGapTime * Int(notificationGapTimeInterval)
        )
        FancyLogger.info("Sleeping for \(notificationGap) seconds")
        try? await Task.sleep(nanoseconds: notificationGap * 1_000_000_000)
    }

    // swiftlint:disable:next function_body_length
    private func processNotification(
        _ notification: ReminderNotification,
        with reminderService: ActiveReminderService
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
        defer {
            ActiveReminderManager.shared.removeWaiting(reminder)
        }

        guard reminderCanOccur(reminder) else {
            return
        }

        guard await !NotificationPermissions.shared.promptIfAlertsNotEnabled() else {
            FancyLogger.info("There is an alert")
            return
        }

        // Eventually, we need to check if the reminder is past. This
        // will be tricky
        let request = notification.createRequest()
        do {
            try await notificationCentre.add(request)
        } catch {
            FancyLogger.error("Error adding notification:", error)
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
            ActiveReminderManager.shared.setActiveReminder(with: notification)
            ActiveReminderManager.shared.removeWaiting(reminder)
            reminderService.start()
            if reminder.activationEvents.showWhenActive {
                NotificationCenter.default.post(name: .openActiveReminderWindow, object: nil)
            }
        }

        let deadline = autoDismissDeadline()
        async let notificationDisappeared: Void = {
            // Now, wait until it disappears
            defer {
                FancyLogger.info("🟦 Notification disappeared 🟦")
            }

            var dismissNotification = false
            while await notificationIsPresent(for: reminder) {
                try? await Task.sleep(nanoseconds: 500_000_000)

                if let deadline, clock.now >= deadline {
                    dismissNotification = true
                    break
                }
            }

            guard dismissNotification else { return }

            notificationCentre.removeDeliveredNotifications(withIdentifiers: [request.identifier])
            if reminder.activationEvents.showWhenActive {
                await MainActor.run {
                    NotificationCenter.default.post(name: .dismissActiveReminderWindow, object: nil)
                }
            }
        }()

        async let activeReminderViewDismissed: Void = {
            defer {
                FancyLogger.info("View dismissed")
            }
            guard reminder.activationEvents.showWhenActive else { return }
            _ = await NotificationCenter.default
                .notifications(named: .dismissActiveReminderWindow)
                .first(where: { _ in true })
        }()

        _ = await (notificationDisappeared, activeReminderViewDismissed)

        // Notification has disappeared
        await MainActor.run {
            ActiveReminderManager.shared.unsetActiveReminder()
            reminderService.stop()
        }
    }
}
