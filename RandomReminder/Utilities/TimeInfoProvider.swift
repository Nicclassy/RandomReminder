//
//  TimeInfoProvider.swift
//  RandomReminder
//
//  Created by Luca Napoli on 26/2/2025.
//

import Foundation

struct TimeInfoProvider {
    let reminder: RandomReminder
    
    static let calendarComponents: Set<Calendar.Component> = [.day, .hour, .minute, .second]
    
    func timeDifferenceInfo() -> String {
        func pluralisedName(for component: Calendar.Component, quantity: UInt) -> String {
            let name = String(describing: component)
            let suffix = quantity != 1 ? "s" : ""
            return "\(quantity) \(name)\(suffix)"
        }
        
        let components = Calendar.current.dateComponents(Self.calendarComponents, from: Date(), to: reminder.interval.earliest)
        if let days = components.day, days >= 7 {
            return ">1 week"
        }
        
        let infoParts: [String] = Self.calendarComponents.compactMap { calendarComponent in
            guard let quantity = components.value(for: calendarComponent)?.magnitude, quantity > 0 else {
                return nil
            }
            
            return pluralisedName(for: calendarComponent, quantity: quantity)
        }
        
        return infoParts.isEmpty ? "0 seconds" : infoParts.listing()
    }
    
    func preferencesInfo() -> String {
        if reminder.hasPast() {
            "\(timeDifferenceInfo()) ago"
        } else if reminder.hasBegun() {
            "\(reminder.counts.totalReminders - reminder.counts.timesReminded) reminders left"
        } else {
            "Starting in \(timeDifferenceInfo())"
        }
    }
}
