//
//  MultilineStringBuilder.swift
//  RandomReminder
//
//  Created by Luca Napoli on 16/8/2025.
//

import Foundation

@resultBuilder
struct MultilineStringBuilder {
    static func buildBlock(_ components: String...) -> String {
        components.joined(separator: "")
    }
}

func multilineString(@MultilineStringBuilder _ content: () -> String) -> String {
    content()
}
