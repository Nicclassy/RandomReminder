//
//  Collection+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 25/2/2025.
//

import Foundation

extension Collection {
    func enumeratedArray() -> [(index: Index, element: Element)] {
        Array(zip(indices, self))
    }
}
