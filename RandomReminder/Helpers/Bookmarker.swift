//
//  Bookmarker.swift
//  RandomReminder
//
//  Created by Luca Napoli on 31/5/2025.
//

import Foundation

enum Bookmarker {
    static func saveBookmark(for url: URL, withKey bookmarkKey: String) {
        guard let bookmarkData = try? url.bookmarkData(
            options: .securityScopeAllowOnlyReadAccess,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        ) else {
            fatalError("Cannot save bookmark at \(url)")
        }

        UserDefaults.standard.set(bookmarkData, forKey: bookmarkKey)
    }

    static func resolveBookmark(withKey bookmarkKey: String) {
        guard let bookmarkData = UserDefaults.standard.data(forKey: bookmarkKey) else {
            fatalError("Bookmark data not found for \(bookmarkKey)")
        }

        var isStale = false
        guard let url = try? URL(
            resolvingBookmarkData: bookmarkData,
            options: [.withSecurityScope],
            bookmarkDataIsStale: &isStale
        ) else {
            fatalError("Cannot resolve bookmark \(bookmarkData)")
        }

        if isStale {
            saveBookmark(for: url, withKey: bookmarkKey)
        }
    }

    static func deleteBookmark(withKey bookmarkKey: String) {
        UserDefaults.standard.removeObject(forKey: bookmarkKey)
    }
}
