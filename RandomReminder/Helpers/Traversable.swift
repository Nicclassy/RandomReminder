//
//  Traversable.swift
//  RandomReminder
//
//  Created by Luca Napoli on 28/8/2025.
//

import Foundation

protocol Traversable: Equatable, CaseIterable {}

extension Traversable where Self.AllCases.Index == Int {
    var isFirst: Bool {
        self == Self.allCases.first!
    }

    var isLast: Bool {
        self == Self.allCases[Self.allCases.count - 1]
    }

    mutating func backward() {
        let cases = Self.allCases
        let index = cases.firstIndex(of: self)!
        self = index == 0 ? self : cases[index - 1]
    }

    mutating func forward() {
        let cases = Self.allCases
        let index = cases.firstIndex(of: self)!
        self = index == cases.count - 1 ? self : cases[index + 1]
    }
}
