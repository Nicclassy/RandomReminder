//
//  StaticIdentifier.swift
//  RandomReminder
//
//  Created by Luca Napoli on 20/12/2025.
//

import SwiftUI

struct StaticIdentifierAccessibility: ViewModifier {
    let identifier: StaticIdentifier

    func body(content: Content) -> some View {
        content
            .accessibilityIdentifier(identifier.description)
    }
}

protocol StaticIdentifier {}

extension StaticIdentifier {
    var description: String {
        kebaber(IdentifierQualnameRegistry.shared.qualname(for: self))
    }
}

extension View {
    func accessibilityIdentifier(_ identifier: StaticIdentifier) -> some View {
        modifier(StaticIdentifierAccessibility(identifier: identifier))
    }
}
