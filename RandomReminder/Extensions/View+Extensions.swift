//
//  View+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 7/7/2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`(_ condition: Bool, transform: (Self) -> some View) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    func mediumFrame() -> some View {
        frame(width: ViewConstants.mediumWindowWidth, height: ViewConstants.mediumWindowHeight)
    }

    func readWidth(_ perform: @escaping (CGFloat) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .onAppear {
                        perform(geometryProxy.size.width)
                    }
            }
        )
    }

    func readHeight(_ perform: @escaping (CGFloat) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .onAppear {
                        perform(geometryProxy.size.height)
                    }
            }
        )
    }
}
