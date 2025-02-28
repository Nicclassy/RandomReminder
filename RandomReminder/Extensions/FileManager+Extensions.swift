//
//  FileManager+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 18/1/2025.
//

import Foundation

extension FileManager {
    func directoryExists(atPath: String) -> Bool {
        var isDirectory: ObjCBool = true
        let exists = fileExists(atPath: atPath, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
}
