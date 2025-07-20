//
//  Subprocess.swift
//  RandomReminder
//
//  Created by Luca Napoli on 18/6/2025.
//

import Foundation

enum SubprocessResult: Equatable {
    case success
    case error(String)
    case timeout(TimeInterval)
}

struct Subprocess {
    private static let defaultExecutableURL = URL(fileURLWithPath: "/bin/bash")
    private static let timeoutSeconds: TimeInterval = 1

    private let command: String
    private var commandOutput: String?
    private var commandErrors: String?
    private var executed = false

    var stdout: String {
        guard executed else {
            fatalError("Command has not been executed")
        }

        return commandOutput ?? ""
    }

    var stderr: String {
        guard executed else {
            fatalError("Command has not been executed")
        }

        return commandErrors ?? ""
    }
    
    var hasErrors: Bool {
        commandErrors?.isEmpty == false
    }

    init(command: String) {
        self.command = command
    }

    private static func withThrowingTimeout(
        seconds: TimeInterval = timeoutSeconds,
        operation: @escaping () throws -> Void
    ) -> SubprocessResult {
        let semaphore = DispatchSemaphore(value: 0)
        var result: SubprocessResult = .success

        Task.detached(priority: .userInitiated) {
            do {
                try operation()
            } catch {
                result = .error(error.localizedDescription)
            }
            semaphore.signal()
        }

        let timeoutResult = semaphore.wait(timeout: .now() + seconds)
        return timeoutResult == .timedOut ? .timeout(seconds) : result
    }

    @discardableResult
    mutating func run() -> SubprocessResult {
        let process = Process()
        process.arguments = ["-c", command]
        process.executableURL = Self.defaultExecutableURL

        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe

        assert(!executed)
        defer {
            executed = true
            outputPipe.fileHandleForReading.closeFile()
            errorPipe.fileHandleForReading.closeFile()
        }

        let result = Self.withThrowingTimeout {
            try process.run()
            process.waitUntilExit()
        }
        if result != .success {
            return result
        }

        var outputData: Data?
        var errorData: Data?

        do {
            outputData = try outputPipe.fileHandleForReading.readToEnd()
            errorData = try errorPipe.fileHandleForReading.readToEnd()
        } catch {
            return .error(error.localizedDescription)
        }

        commandOutput = if let outputData {
            String(bytes: outputData, encoding: .utf8)
        } else {
            nil
        }
        commandErrors = if let errorData {
            String(bytes: errorData, encoding: .utf8)
        } else {
            nil
        }

        return .success
    }
}
