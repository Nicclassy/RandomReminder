//
//  OptionSet+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 24/2/2025.
//

import Foundation

extension OptionSet where Self: CaseIterable {
    static func allOptions() -> Self {
        .allCases.combine()
    }
}
