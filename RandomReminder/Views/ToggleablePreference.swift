//
//  ToggleablePreference.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/2/2026.
//

import SwiftUI

struct ToggleablePreference: View {
    let title: String
    var caption: String?
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                    if let caption {
                        CaptionText(caption)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer(minLength: 0)
            }
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 10) {
        ToggleablePreference(title: "Captionless text", isOn: .constant(true))
        ToggleablePreference(
            title: "Text",
            caption: "This is caption text that is sufficiently long enough to disappear but it doesn't",
            isOn: .constant(true)
        )
    }
    .frame(width: 300, height: 50)
    .padding()
}
