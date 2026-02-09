//
//  IdentifierQualnameRegistry.swift
//  RandomReminder
//
//  Created by Luca Napoli on 20/12/2025.
//

import Foundation

func kebaber(_ input: String) -> String {
    input
        .split(separator: ".")
        .map { part in
            part.reduce(into: "") { result, letter in
                if letter.isUppercase {
                    if !result.isEmpty {
                        result.append("-")
                    }
                } else {
                    result.append(letter)
                }
            }
        }
        .joined(separator: ".")
}

final class IdentifierQualnameRegistry {
    fileprivate typealias AnIdentifierType = any StaticIdentifier.Type

    static let shared = {
        let registry = IdentifierQualnameRegistry()
        registry.registerTypes(
            A11y.Reminder.self,
            A11y.Reminder.ModificationView.self
        )
        return registry
    }()

    private var typesByName: [String: [AnIdentifierType]] = [:]

    private init() {}

    func registerTypes(_ types: any StaticIdentifier.Type...) {
        var predecessors: [AnIdentifierType] = []
        for type in types {
            let typeName = String(describing: type)
            predecessors.append(type)
            typesByName[typeName] = Array(predecessors)
        }
    }

    func qualname<Identifier: StaticIdentifier>(for value: Identifier) -> String {
        let typeName = String(describing: Identifier.self)
        guard let types = typesByName[typeName] else {
            fatalError("No type found for \(typeName)")
        }

        let valueName = String(describing: value)
        return (types + [valueName])
            .map { String(describing: $0) }
            .joined(separator: ".")
    }
}
