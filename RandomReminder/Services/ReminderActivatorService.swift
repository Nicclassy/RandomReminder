//
//  ReminderActivatorService.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import Foundation

typealias OnReminderActivation = () -> Void
typealias OnReminderFinished = () -> Void

protocol ReminderActivatorService {
    var reminder: RandomReminder { get }
    var running: Bool { get set }
    var terminated: Bool { get set }

    func tick()
}
