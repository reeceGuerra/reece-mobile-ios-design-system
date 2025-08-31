//
//  ReeceColorHex.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 30/08/25.
//

import Foundation
import SwiftUI

enum HexColorError: Error, Equatable {
    case invalidLength(actual: Int)
    case invalidScan(String)
}

@usableFromInline
struct HexColorParser {
    @inline(__always)
    static func rgba(from input: String) throws -> (r: Double, g: Double, b: Double, a: Double) {
        var cleaned = input.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cleaned.hasPrefix("#") { cleaned.removeFirst() }

        guard cleaned.count == 6 || cleaned.count == 8 else {
            throw HexColorError.invalidLength(actual: cleaned.count)
        }

        var rgbValue: UInt64 = 0
        guard Scanner(string: cleaned).scanHexInt64(&rgbValue) else {
            throw HexColorError.invalidScan(cleaned)
        }

        if cleaned.count == 6 {
            let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
            let g = Double((rgbValue & 0x00FF00) >> 8)  / 255.0
            let b = Double((rgbValue & 0x0000FF)      ) / 255.0
            return (r, g, b, 1.0)
        } else {
            let r = Double((rgbValue & 0xFF000000) >> 24) / 255.0
            let g = Double((rgbValue & 0x00FF0000) >> 16) / 255.0
            let b = Double((rgbValue & 0x0000FF00) >> 8)  / 255.0
            let a = Double((rgbValue & 0x000000FF)      ) / 255.0
            return (r, g, b, a)
        }
    }
}

public extension Color {
    init(hex: String) {
        do {
            let c = try HexColorParser.rgba(from: hex)
            self.init(red: c.r, green: c.g, blue: c.b, opacity: c.a)
        } catch {
            preconditionFailure("Invalid hex '\(hex)': \(error)")
        }
    }
}
