//
//  ReminderPreferences.swift
//  RandomReminder
//
//  Created by Luca Napoli on 22/2/2025.
//

import Foundation
import SwiftUI

final class ReminderPreferences: ObservableObject {
    @Published var repeatingEnabled = false
    @Published var timesOnly = false
    @Published var alwaysRunning = false
    
    @Published var specificDays = false
    
    @Published var showTimesOnlyPopover = false
    @Published var showFileImporter = false
}
