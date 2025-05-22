//
//  EnumRawRepresentable.swift
//  RandomReminder
//
//  Created by Luca Napoli on 22/5/2025.
//

import Foundation

protocol EnumRawRepresentable: Codable, RawRepresentable {}

extension EnumRawRepresentable where Self: CaseIterable {
    var rawValue: String {
        String(describing: self)
    }

    init?(rawValue: String) {
        guard let result = Self.allCases.first(where: { $0.rawValue == rawValue }) else {
            fatalError("Could not convert \(rawValue) into \(Self.self)")
        }

        self = result
    }
}
