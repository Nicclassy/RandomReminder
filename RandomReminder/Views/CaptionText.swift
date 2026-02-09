//
//  CaptionText.swift
//  RandomReminder
//
//  Created by Luca Napoli on 24/12/2024.
//

import Foundation
import SwiftUI

struct CaptionText: View {
    private var caption: String

    var body: some View {
        Text(caption)
            .foregroundStyle(.secondary)
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    init(_ caption: String) {
        self.caption = caption
    }
}
