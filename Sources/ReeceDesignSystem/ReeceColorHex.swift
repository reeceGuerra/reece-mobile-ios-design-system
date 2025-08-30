//
//  ReeceColorHex.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 30/08/25.
//

import SwiftUI

public extension Color {
    /// Initialize a SwiftUI Color from a hex string like "#RRGGBB" or "#RRGGBBAA".
    /// - Parameters:
    ///   - hex: A string such as "#0859A8" (RGB) or "#0859A8FF" (RGBA).
    /// - Note: Crashes in debug if the string is invalid.
    init(hex: String) {
        var cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cleaned.hasPrefix("#") {
            cleaned.removeFirst()
        }

        guard cleaned.count == 6 || cleaned.count == 8 else {
            preconditionFailure("Invalid hex string length: \(cleaned)")
        }

        var rgbValue: UInt64 = 0
        guard Scanner(string: cleaned).scanHexInt64(&rgbValue) else {
            preconditionFailure("Unable to scan hex value: \(cleaned)")
        }

        let r, g, b, a: Double
        if cleaned.count == 6 {
            r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
            g = Double((rgbValue & 0x00FF00) >> 8)  / 255.0
            b = Double(rgbValue & 0x0000FF)         / 255.0
            a = 1.0
        } else {
            r = Double((rgbValue & 0xFF000000) >> 24) / 255.0
            g = Double((rgbValue & 0x00FF0000) >> 16) / 255.0
            b = Double((rgbValue & 0x0000FF00) >> 8)  / 255.0
            a = Double((rgbValue & 0x000000FF)         ) / 255.0
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
