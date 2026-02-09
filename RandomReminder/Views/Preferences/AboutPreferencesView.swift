//
//  AboutPreferencesView.swift
//  RandomReminder
//
//  Created by Luca Napoli on 23/12/2024.
//

import SwiftUI

struct AboutPreferencesView: View {
    @StateObject var appPreferences: AppPreferences = .shared

    var body: some View {
        VStack {
            Text("About placeholder text")
        }
        .mediumFrame()
    }
}

#Preview {
    AboutPreferencesView()
}
