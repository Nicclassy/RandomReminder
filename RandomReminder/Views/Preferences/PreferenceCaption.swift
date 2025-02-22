//
//  PreferenceCaption.swift
//  RandomReminder
//
//  Created by Luca Napoli on 24/12/2024.
//

import Foundation
import SwiftUI

struct PreferenceCaption: View {
    private var caption: String
    
    init(_ caption: String) {
        self.caption = caption
    }
    
    var body: some View {
        Text(caption)
            .foregroundStyle(.secondary)
            .font(.caption)
    }
}
