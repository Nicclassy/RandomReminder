//
//  Utilities.swift
//  RandomReminder
//
//  Created by Luca Napoli on 1/8/2025.
//

import AppKit
import Foundation

func withTimeoutDefaultAsync<T>(
    seconds: TimeInterval,
    operation: @escaping () async -> T
) -> T? {
    let semaphore = DispatchSemaphore(value: 0)
    var result: T?

    Task.detached(priority: .userInitiated) {
        result = await operation()
        semaphore.signal()
    }

    let timeoutResult = semaphore.wait(timeout: .now() + seconds)
    return timeoutResult == .timedOut ? nil : result
}

func showAlert(title alertTitle: String, message alertMessage: String, buttonText: String) {
    let alert = NSAlert()
    alert.messageText = alertTitle
    alert.informativeText = alertMessage
    alert.addButton(withTitle: buttonText)
    alert.runModal()
}

func removeFunctionNameParentheses(_ functionName: String) -> String {
    String(describing: functionName.split(separator: "(").first!)
}

func filenameFromPath(_ file: String, includeExtension: Bool = false) -> String {
    let filename = file.split(separator: "/").last!
    return includeExtension ? String(describing: filename) : String(describing: filename.split(separator: ".").first!)
}

func shouldntBeCalled(function: String = #function, file: String = #file, line: Int = #line) -> Never {
    let caller = removeFunctionNameParentheses(function)
    let filename = filenameFromPath(file, includeExtension: true)
    printCallStackFunctionNames()
    fatalError("The function '\(caller)' in '\(filename)' (line \(line)) should not be called")
}
