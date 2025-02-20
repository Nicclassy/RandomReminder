//
//  Array+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 19/2/2025.
//

import Foundation

extension Array {
    func chunked(ofCount: Int) -> [[Element]] {
        stride(from: 0, to: self.count, by: ofCount).map { chunkStart in
            let chunkEnd = Swift.min(chunkStart + ofCount, self.count)
            return Self(self[chunkStart..<chunkEnd])
        }
    }
}
