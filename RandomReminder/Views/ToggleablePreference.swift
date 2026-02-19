//
//  ToggleablePreference.swift
//  RandomReminder
//
//  Created by Luca Napoli on 8/2/2026.
//

import SwiftUI

struct ToggleablePreference<Content: View>: View {
    private let title: String?
    private let caption: String?
    @Binding private var isOn: Bool

    @ViewBuilder
    private let content: (() -> Content)?

    var body: some View {
        Toggle(isOn: $isOn) {
            HStack {
                VStack(alignment: .leading) {
                    if let title {
                        Text(title)
                    }
                    if let content {
                        content()
                    }
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

    init(title: String? = nil, caption: String? = nil, isOn: Binding<Bool>, content: @escaping () -> Content) {
        self.title = title
        self.content = content
        self.caption = caption
        self._isOn = isOn
    }
}

extension ToggleablePreference where Content == EmptyView {
    init(title: String? = nil, caption: String? = nil, isOn: Binding<Bool>) {
        self.title = title
        self.content = nil
        self.caption = caption
        self._isOn = isOn
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
