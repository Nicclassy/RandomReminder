//
//  Date+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 24/12/2024.
//

import Foundation

extension Date {
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }
    
    func addMinutes(_ minutes: Int) -> Self {
        Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func subtractMinutes(_ minutes: Int) -> Self {
        Calendar.current.date(byAdding: .minute, value: -minutes, to: self)!
    }
}
