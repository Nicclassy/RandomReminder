//
//  RandomReminder+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 12/1/2025.
//

import Foundation

extension RandomReminder {
    func filename() -> String {
        URL(string: String(describing: self.id))!
            .appendingPathExtension(StoredReminders.fileExtension)
            .path()
    }
}
