//
//  Sequence+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 24/2/2025.
//

import Foundation

extension Sequence where Element: OptionSet {
    func combine() -> Element {
        reduce(Element()) { $0.union($1) }
    }
}
