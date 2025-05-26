//
//  SchedulingPreferences.swift
//  RandomReminder
//
//  Created by Luca Napoli on 27/3/2025.
//

import Foundation
import SwiftUI

final class SchedulingPreferences: ObservableObject {
    static let shared = SchedulingPreferences()

    @AppStorage("defaultEarliestTime") var defaultEarliestTime: TimeInterval = 0
    @AppStorage("defaultLatestTime") var defaultLatestTime: TimeInterval = 0
    @AppStorage("notificationGapEnabled") var notificationGapEnabled = false
    @AppStorage("notificationGapTime") var notificationGapTime = 0
    @AppStorage("notificationGapTimeUnit") var notificationGapTimeUnit: TimeUnit = .second

    private init() {}
}
