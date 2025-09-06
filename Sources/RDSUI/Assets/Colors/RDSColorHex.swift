//
//  RDSColorHex.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 30/08/25.
//

//
//  RDSColorHex.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 30/08/25.
//  Refactored by ChatGPT (SOLID):
//  - Keep hex parsing/formatting pure (SRP).
//  - Document error cases and supported formats.
//  - Avoid any dependency on theme/scheme policy (DIP).
//

import Foundation
import SwiftUI

// MARK: - Errors

/// Errors thrown during HEX parsing.
public enum HexColorError: Error, Equatable {
    /// The input length is not one of the supported forms (3, 4, 6, 8 hex digits).
    case invalidLength(actual: Int)
    /// The input contains non-hex characters.
    case invalidScan(String)
}

// MARK: - RDSColorHex

/// Utilities to **parse** and **format** colors to/from HEX strings.
///
/// This type is intentionally pure and does **not** depend on theme, palette,
/// or color-scheme policy. Use it from tests and tools without SwiftUI runtime.
public enum RDSColorHex {
    
    // MARK: Parsing
    
    /// Parses a HEX string into RGBA components.
    ///
    /// Supported forms (case-insensitive, leading `#` optional):
    /// - `RGB` (12-bit, e.g., `#1A2`)
    /// - `RGBA` (16-bit, e.g., `#1A2F`)
    /// - `RRGGBB` (24-bit, e.g., `#11AA22`)
    /// - `RRGGBBAA` (32-bit, e.g., `#11AA22FF`)
    ///
    /// - Parameter hex: The HEX string to parse.
    /// - Returns: Tuple of normalized components in `[0, 1]`. Alpha defaults to `1` when omitted.
    public static func parse(_ hex: String) throws -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }
        
        let len = s.count
        guard [3,4,6,8].contains(len) else {
            throw HexColorError.invalidLength(actual: len)
        }
        
        func hex2(_ c1: Character, _ c2: Character) throws -> UInt8 {
            let str = String([c1, c2])
            guard let v = UInt8(str, radix: 16) else { throw HexColorError.invalidScan(str) }
            return v
        }
        func hex1(_ c: Character) throws -> UInt8 {
            let str = String(c)
            guard let v = UInt8(str, radix: 16) else { throw HexColorError.invalidScan(str) }
            // Expand 4-bit (0xA) to 8-bit (0xAA)
            return (v << 4) | v
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
            throw HexColorError.invalidLength(actual: len) // safeguarded above
        }
        
        let div: CGFloat = 255.0
        return (CGFloat(r)/div, CGFloat(g)/div, CGFloat(b)/div, CGFloat(a)/div)
    }
    
    /// Parses a HEX string into a SwiftUI `Color` in the specified color space.
    /// - Parameters:
    ///   - hex: The HEX string to parse.
    ///   - colorSpace: Target color space (defaults to `.sRGB`).
    /// - Returns: A SwiftUI `Color` or `nil` if parsing fails.
    public static func color(from hex: String, colorSpace: Color.RGBColorSpace = .sRGB) -> Color? {
        do {
            let c = try parse(hex)
            return Color(colorSpace, red: c.r, green: c.g, blue: c.b, opacity: c.a)
        } catch {
            #if DEBUG
            print("RDSColorHex: parse error for \(hex): \(error)")
            #endif
            return nil
        }
    }
    
    // MARK: Formatting
    
    /// Formats RGBA components into a HEX string.
    /// - Parameters:
    ///   - r: Red (0...1)
    ///   - g: Green (0...1)
    ///   - b: Blue (0...1)
    ///   - a: Alpha (0...1)
    ///   - includeAlpha: If true, includes the `AA` suffix.
    /// - Returns: `#RRGGBB` or `#RRGGBBAA`.
    public static func string(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0, includeAlpha: Bool = false) -> String {
        func clamp8(_ x: CGFloat) -> UInt8 { UInt8(max(0, min(255, round(x * 255)))) }
        let R = clamp8(r), G = clamp8(g), B = clamp8(b), A = clamp8(a)
        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X", R, G, B, A)
        } else {
            return String(format: "#%02X%02X%02X", R, G, B)
        }
    }
    
    /// Formats a SwiftUI `Color` to a HEX string in the specified color space.
    /// - Parameters:
    ///   - color: SwiftUI color.
    ///   - colorSpace: Color space used to resolve channels (defaults to `.sRGB`).
    ///   - includeAlpha: If true, includes `AA`.
    /// - Returns: `#RRGGBB` or `#RRGGBBAA`, or `nil` if the color cannot be resolved.
    public static func string(from color: Color, colorSpace: Color.RGBColorSpace = .sRGB, includeAlpha: Bool = false) -> String? {
        #if canImport(UIKit)
        // UIKit bridge for system colors (iOS)
        let ui = UIColor(color)
        var r: CGFloat = .zero, g: CGFloat = .zero, b: CGFloat = .zero, a: CGFloat = .zero
        guard ui.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return string(r: r, g: g, b: b, a: a, includeAlpha: includeAlpha)
        #elseif canImport(AppKit)
        // AppKit bridge (macOS)
        let ns = NSColor(color)
        guard let conv = ns.usingColorSpace(.sRGB) else { return nil }
        return string(r: conv.redComponent, g: conv.greenComponent, b: conv.blueComponent, a: conv.alphaComponent, includeAlpha: includeAlpha)
        #else
        // Fallback: best effort using provided color space
        // NOTE: SwiftUI Color doesn't expose raw components cross-platform without UIKit/AppKit.
        return nil
        #endif
    }
}

// MARK: - SwiftUI convenience

public extension Color {
    /// Convenience to export this color as HEX using `RDSColorHex` helpers.
    /// - Parameters:
    ///   - includeAlpha: If true, returns `#RRGGBBAA`; otherwise `#RRGGBB`.
    /// - Returns: HEX string or `nil` when resolution fails.
    func rdsHexString(includeAlpha: Bool = false) -> String? {
        RDSColorHex.string(from: self, includeAlpha: includeAlpha)
    }
}
