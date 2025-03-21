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
    private static let reminderIdKey = "reminderId"
    
    private let queue = DispatchQueue(label: Constants.bundleID + ".notificationQueue", qos: .utility)
    private let notificationCentre: UNUserNotificationCenter = .current()
    
    private init() {}
    
    func addReminderNotification(for service: ActiveReminderService) {
        let content = UNMutableNotificationContent()
        let reminder = service.reminder
        content.title = reminder.content.title
        content.subtitle = reminder.content.text
        content.sound = .default
        content.userInfo = [Self.reminderIdKey: reminder.id.value]
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        notificationCentre.add(request)
        queue.async { [self] in
            processNotification(for: service)
        }
    }
    
    private func notificationIsPresent(for reminder: RandomReminder) -> Bool {
        var isActive = false
        let semaphore = DispatchSemaphore(value: 0)
        notificationCentre.getDeliveredNotifications { notifications in
            for notification in notifications {
                let notificationUserInfo = notification.request.content.userInfo
                guard let notificationReminderId = notificationUserInfo[Self.reminderIdKey] as? Int else {
                    FancyLogger.error("Notification does not contain the required userInfo key")
                    continue
                }
                
                if reminder.id == notificationReminderId {
                    isActive = true
                    semaphore.signal()
                    return
                }
            }
            
            semaphore.signal()
        }
        
        semaphore.wait()
        return isActive
    }
    
    private func processNotification(for reminderService: ActiveReminderService) {
        // This is a bit of an inelegant solution but it works.
        // UNNotificationDelegate does not notify the user when
        // a notification has disappeared
        // (there are may ways in which a notification can disappear,
        // but UNNotificationDelegate only informs the program
        // if the user clicks on the notification),
        // so this solution will suffice for now.
        let reminder = reminderService.reminder
        let group = DispatchGroup()
        
        // Hasn't appeared yet. Wait to confirm it appears
        group.enter()
        DispatchQueue.global(qos: .background).async { [self] in
            while !notificationIsPresent(for: reminder) {
                Thread.sleep(forTimeInterval: 0.05)
            }
            group.leave()
        }
        group.wait()
        
        // Has appeared. Wait until it disappears
        reminderService.onNotificationAppear()
        
        group.enter()
        DispatchQueue.global(qos: .background).async { [self] in
            while notificationIsPresent(for: reminder) {
                Thread.sleep(forTimeInterval: 0.5)
            }
            group.leave()
        }
        group.wait()
        
        // Notification has disappeared
        reminderService.onNotificationDisappear()
    }
}
