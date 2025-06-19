//
//  Subprocess.swift
//  RandomReminder
//
//  Created by Luca Napoli on 18/6/2025.
//

import Foundation

enum SubprocessResult {
    case success
    case error(String)
    case timeout
}

struct Subprocess {
    private static let defaultExecutableURL = URL(fileURLWithPath: "/bin/bash")
    
    private let command: String
    private var executed = false
    private var commandOutput: String?
    private var commandErrors: String?
    
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
    
    init(command: String) {
        self.command = command
    }
    
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
        
        do {
            try process.run()
            process.waitUntilExit()
        } catch let error {
            return .error(error.localizedDescription)
        }
        
        var outputData: Data?
        var errorData: Data?
        do {
            outputData = try outputPipe.fileHandleForReading.readToEnd()
            errorData = try errorPipe.fileHandleForReading.readToEnd()
        } catch let error {
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
