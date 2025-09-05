//
//  RDSColorExport.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 31/08/25.
//

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

import SwiftUI

/// Utilities for exporting colors from SwiftUI to HEX strings, and resolving
/// platform-specific RGBA components (sRGB) respecting Light/Dark scheme.
public enum RDSColorExport {

    /// Returns "#RRGGBB" or "#RRGGBBAA" for a `SwiftUI.Color` by delegating to `RDSColorHex`.
    ///
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
        return RDSColorHex.string(from: color, scheme: scheme, includeAlpha: includeAlpha)
    }

    // MARK: - Shared RGBA resolver

    /// Resolves a `SwiftUI.Color` into RGBA components (sRGB), honoring the provided color scheme if specified.
    /// - Parameters:
    ///   - color: The input SwiftUI color.
    ///   - scheme: If provided, forces Light/Dark resolution; otherwise uses current system settings.
    /// - Returns: `(red, green, blue, alpha)` in `[0, 1]`, or `nil` if conversion fails.
    internal static func resolvedPlatformColor(
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
        // If you need to explicitly emulate Light/Dark on macOS,
        // map `scheme` to an NSAppearance and resolve with it.
        guard let rgb = ns.usingColorSpace(.sRGB) else { return nil }
        return (rgb.redComponent, rgb.greenComponent, rgb.blueComponent, rgb.alphaComponent)

        #else
        return nil
        #endif
    }
}
