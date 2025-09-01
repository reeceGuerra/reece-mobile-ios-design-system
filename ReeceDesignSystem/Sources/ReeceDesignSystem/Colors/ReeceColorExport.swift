//
//  ReeceColorExport.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 31/08/25.
//

// Sources/ReeceDesignSystem/Colors/ReeceColorExport.swift
#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

import SwiftUI

public enum ReeceColorExport {
    /// Returns "#RRGGBB" or "#RRGGBBAA" for a `SwiftUI.Color`.
    /// - Parameters:
    ///   - color: A SwiftUI color (may be dynamic with Light/Dark variants).
    ///   - scheme: If provided, resolves the color using the given Light/Dark scheme; if `nil`, uses the system setting.
    ///   - includeAlpha: If `true`, includes the alpha component.
    /// - Returns: HEX string or `nil` if conversion to sRGB fails.
    public static func hexString(
        for color: Color,
        scheme: ColorScheme? = nil,
        includeAlpha: Bool = false
    ) -> String? {
        guard let c = resolvedPlatformColor(from: color, scheme: scheme) else { return nil }
        let R = Int(round(c.red   * 255))
        let G = Int(round(c.green * 255))
        let B = Int(round(c.blue  * 255))
        let A = Int(round(c.alpha * 255))
        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X", R, G, B, A)
        } else {
            return String(format: "#%02X%02%02X", R, G, B)
        }
    }

    /// Resolves a `SwiftUI.Color` into RGBA (sRGB) honoring the provided color scheme if specified.
    /// - Note: `internal` so it can be reused by other modules (e.g., contrast helpers).
    static func resolvedPlatformColor(
        from color: Color,
        scheme: ColorScheme?
    ) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        #if canImport(UIKit)
        // iOS / tvOS / watchOS
        let uiBase = UIColor(color)
        let traits = scheme.map { UITraitCollection(userInterfaceStyle: $0 == .dark ? .dark : .light) }
        let ui = traits.map { uiBase.resolvedColor(with: $0) } ?? uiBase

        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard ui.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return (r, g, b, a)

        #elseif canImport(AppKit)
        // macOS
        let ns = NSColor(color)
        // If you want to emulate Light/Dark explicitly on macOS, map `scheme` to an NSAppearance and resolve with it.
        guard let rgb = ns.usingColorSpace(.sRGB) else { return nil }
        return (rgb.redComponent, rgb.greenComponent, rgb.blueComponent, rgb.alphaComponent)

        #else
        return nil
        #endif
    }
}
