//
//  JSONEncoder+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 11/1/2025.
//

import Foundation

extension JSONEncoder {
    static func applicationDefault() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}
