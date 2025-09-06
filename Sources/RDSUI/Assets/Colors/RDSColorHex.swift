//
//  RDSColorHex.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 30/08/25.
//
//  Utilities to parse/format HEX colors, intentionally decoupled from theme/palette.
//  Adds SwiftUI conveniences to build Colors from HEX safely.
//
//  Supported inputs (case-insensitive; leading '#' optional):
//   - RGB   (e.g., #1A2)   -> expands nibbles
//   - RGBA  (e.g., #1A2F)  -> expands nibbles
//   - RRGGBB   (e.g., #11AA22)
//   - RRGGBBAA (e.g., #11AA22FF)
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

// MARK: - Errors

public enum HexColorError: Error, Equatable, Sendable {
    /// The input length is not one of the supported forms (3, 4, 6, 8 hex digits).
    case invalidLength(actual: Int)
    /// The input contains non-hex characters.
    case invalidScan(String)
}

// MARK: - RDSColorHex

/// Utilities to **parse** and **format** colors to/from HEX strings.
/// This type is intentionally pure and does **not** depend on theme/palette policy.
public enum RDSColorHex {

    // MARK: Parsing (string -> components)

    /// Parses a HEX string into normalized RGBA components.
    /// - Parameter hex: HEX string (with or without leading '#').
    /// - Returns: Components in `[0, 1]`. Alpha defaults to `1` when omitted.
    public static func parse(_ hex: String) throws -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }
        let len = s.count
        guard [3, 4, 6, 8].contains(len) else { throw HexColorError.invalidLength(actual: len) }

        func hex2(_ a: Character, _ b: Character) throws -> UInt8 {
            let str = String([a, b])
            guard let v = UInt8(str, radix: 16) else { throw HexColorError.invalidScan(str) }
            return v
        }
        func hex1(_ c: Character) throws -> UInt8 {
            let str = String(c)
            guard let v = UInt8(str, radix: 16) else { throw HexColorError.invalidScan(str) }
            return (v << 4) | v // expand nibble
        }

        let chars = Array(s.uppercased())
        var r: UInt8 = 0, g: UInt8 = 0, b: UInt8 = 0, a: UInt8 = 0xFF

        switch len {
        case 3:
            r = try hex1(chars[0]); g = try hex1(chars[1]); b = try hex1(chars[2])
        case 4:
            r = try hex1(chars[0]); g = try hex1(chars[1]); b = try hex1(chars[2]); a = try hex1(chars[3])
        case 6:
            r = try hex2(chars[0], chars[1]); g = try hex2(chars[2], chars[3]); b = try hex2(chars[4], chars[5])
        case 8:
            r = try hex2(chars[0], chars[1]); g = try hex2(chars[2], chars[3]); b = try hex2(chars[4], chars[5]); a = try hex2(chars[6], chars[7])
        default:
            throw HexColorError.invalidLength(actual: len)
        }

        let div: CGFloat = 255.0
        return (CGFloat(r)/div, CGFloat(g)/div, CGFloat(b)/div, CGFloat(a)/div)
    }

    /// Parses a HEX string into a SwiftUI `Color` in the specified color space.
    /// - Parameters:
    ///   - hex: HEX string.
    ///   - colorSpace: Target color space (defaults to `.sRGB`).
    /// - Returns: A SwiftUI `Color` or `nil` if parsing fails.
    public static func color(from hex: String, colorSpace: Color.RGBColorSpace = .sRGB) -> Color? {
        do {
            let c = try parse(hex)
            return Color(colorSpace, red: c.r, green: c.g, blue: c.b, opacity: c.a)
        } catch {
            #if DEBUG
            print("RDSColorHex.parse error for \(hex): \(error)")
            #endif
            return nil
        }
    }

    // MARK: Formatting (components/Color -> string)

    /// Formats RGBA components to a HEX string.
    public static func string(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0, includeAlpha: Bool = false) -> String {
        @inline(__always) func q(_ v: CGFloat) -> UInt8 {
            let clamped = max(0, min(1, v))
            return UInt8((clamped * 255).rounded())   // ← antes era UInt8(clamped * 255) (truncaba)
        }
        let R = q(r), G = q(g), B = q(b), A = q(a)
        return includeAlpha
            ? String(format: "#%02X%02X%02X%02X", R, G, B, A)
            : String(format: "#%02X%02X%02X", R, G, B)
    }

    /// Formats a SwiftUI `Color` to a HEX string in sRGB.
    /// - Parameters:
    ///   - color: SwiftUI color.
    ///   - includeAlpha: If true, includes `AA`.
    /// - Returns: `#RRGGBB` or `#RRGGBBAA`, or `nil` if the color cannot be resolved.
    public static func string(from color: Color, includeAlpha: Bool = false) -> String? {
        #if canImport(UIKit)
        let ui = UIColor(color)
        var r: CGFloat = .zero, g: CGFloat = .zero, b: CGFloat = .zero, a: CGFloat = .zero
        guard ui.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return string(r: r, g: g, b: b, a: a, includeAlpha: includeAlpha)
        #elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
        let ns = NSColor(color)
        guard let conv = ns.usingColorSpace(.sRGB) else { return nil }
        return string(r: conv.redComponent, g: conv.greenComponent, b: conv.blueComponent, a: conv.alphaComponent, includeAlpha: includeAlpha)
        #else
        // Other SwiftUI platforms without UIKit/AppKit bridging
        return nil
        #endif
    }
}

// MARK: - SwiftUI conveniences

public extension Color {
    /// Returns HEX string for this color using `RDSColorHex`.
    func rdsHexString(includeAlpha: Bool = false) -> String? {
        RDSColorHex.string(from: self, includeAlpha: includeAlpha)
    }

    /// Failable initializer from HEX (e.g., "#112233" or "112233FF").
    init?(rdsHex: String) {
        guard let c = RDSColorHex.color(from: rdsHex) else { return nil }
        self = c
    }

    /// Convenience factory that never fails: returns `.clear` if parsing fails.
    static func rds(_ hex: String) -> Color {
        RDSColorHex.color(from: hex) ?? .clear
    }
}
