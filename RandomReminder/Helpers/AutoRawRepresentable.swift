//
//  AutoRawRepresentable.swift
//  RandomReminder
//
//  Created by Luca Napoli on 22/5/2025.
//
// All credits go to https://nilcoalescing.com/blog/SaveCustomCodableTypesInAppStorageOrSceneStorage/
// for how make types conform to @AppStorage

import Foundation

protocol AutoRawRepresentable: Codable, RawRepresentable {}

extension AutoRawRepresentable {
    var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            fatalError("Cannot encode \(self)")
        }
        return result
    }

    init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(Self.self, from: data)
        else {
            return nil
        }
        self = result
    }
}
