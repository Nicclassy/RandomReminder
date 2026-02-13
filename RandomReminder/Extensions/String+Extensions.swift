//
//  String+Extensions.swift
//  RandomReminder
//
//  Created by Luca Napoli on 10/2/2026.
//

import SwiftUI

extension String {
    func width(with font: NSFont) -> CGFloat {
        (self as NSString).size(withAttributes: [.font: font]).width
    }
}
