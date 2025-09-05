//
//  ReeceColorHex.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 30/08/25.
//

import Foundation
import SwiftUI

// MARK: - Errors

enum HexColorError: Error, Equatable {
    case invalidLength(actual: Int)
    case invalidScan(String)
}

// MARK: - Parsing (HEX -> RGBA)

@usableFromInline
struct HexColorParser {
    /// Parses "#RRGGBB" or "#RRGGBBAA" (case-insensitive, optional leading '#')
    /// and returns normalized RGBA components in [0, 1].
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

// MARK: - Public API

/// Helpers to convert between `SwiftUI.Color` and HEX strings.
public enum ReeceColorHex {
    /// Returns "#RRGGBB" or "#RRGGBBAA" for a `SwiftUI.Color`.
    ///
    /// - Parameters:
    ///   - color: The color to export (may be dynamic for Light/Dark).
    ///   - scheme: If provided, resolves the color using the given scheme; if `nil`, uses the system setting.
    ///   - includeAlpha: Whether to include the alpha component.
    /// - Returns: A HEX string or `nil` if conversion fails.
    public static func string(
        from color: Color,
        scheme: ColorScheme? = nil,
        includeAlpha: Bool = false
    ) -> String? {
        // Delegate component resolution to the shared platform resolver.
        guard let c = ReeceColorExport.resolvedPlatformColor(from: color, scheme: scheme) else {
            return nil
        }
        let R = Int(round(c.red   * 255))
        let G = Int(round(c.green * 255))
        let B = Int(round(c.blue  * 255))
        let A = Int(round(c.alpha * 255))

        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X", R, G, B, A)
        } else {
            return String(format: "#%02X%02X%02X", R, G, B)
        }
    }
}

public extension Color {
    /// Creates a `Color` from "#RRGGBB" or "#RRGGBBAA".
    init(hex: String) {
        do {
            let c = try HexColorParser.rgba(from: hex)
            self.init(red: c.r, green: c.g, blue: c.b, opacity: c.a)
        } catch {
            preconditionFailure("Invalid hex '\(hex)': \(error)")
        }
    }

    /// Convenience to export this color as HEX using the shared helper.
    /// - Parameters:
    ///   - scheme: Optional scheme override (.light / .dark).
    ///   - includeAlpha: If true, returns "#RRGGBBAA"; otherwise "#RRGGBB".
    func reeceHexString(
        scheme: ColorScheme? = nil,
        includeAlpha: Bool = false
    ) -> String? {
        ReeceColorHex.string(from: self, scheme: scheme, includeAlpha: includeAlpha)
    }
}
