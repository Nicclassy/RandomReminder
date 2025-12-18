//
//  CommandController.swift
//  RandomReminder
//
//  Created by Luca Napoli on 16/12/2025.
//

import SwiftUI

enum ReminderCommand: CaseIterable {
    case descriptionCommand
    case activationCommand
}

final class CommandController {
    static let shared = CommandController()
    fileprivate let notificationNamesByCommand: [ReminderCommand: Notification.Name] = {
        var mapping: [ReminderCommand: Notification.Name] = [:]
        for command in ReminderCommand.allCases {
            let notificationName = Notification.Name(String(describing: command))
            mapping[command] = notificationName
        }
        return mapping
    }()

    private var valuesByCommand: [ReminderCommand: Any] = [:]
    var commandType: ReminderCommand = .descriptionCommand

    func value<Value>(for command: ReminderCommand) -> Value {
        guard let commandValue = valuesByCommand[command] as? Value else {
            fatalError("Command \(command) does not have a stored value")
        }

        return commandValue
    }

    func set(value: some Any, for command: ReminderCommand) {
        valuesByCommand[command] = value
        let notificationName = notificationNamesByCommand[command]!
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
}

extension View {
    func onReceive(_ command: ReminderCommand, perform: @escaping (Notification) -> Void) -> some View {
        let notificationName = CommandController.shared.notificationNamesByCommand[command]!
        return onReceive(
            NotificationCenter.default.publisher(for: notificationName, object: nil),
            perform: perform
        )
    }
}
