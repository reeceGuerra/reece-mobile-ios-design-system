//
//  RDSColorExport.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 31/08/25.
//
//  - Remove ColorScheme dependency (no scheme parameter).
//  - Keep export utilities focused on extracting RGBA/HEX from a resolved `Color` (SRP).
//

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

import SwiftUI

/// Utilities to export SwiftUI `Color` values as RGBA or HEX strings.
///
/// This utility does **not** decide Light/Dark policy. If you need a specific
/// look for export, resolve the `Color` beforehand (e.g., using `RDSColorEngine`
/// with your theme policy) and then pass the resolved `Color` here.
public enum RDSColorExport {
    
    // MARK: - RGBA
    
    /// Extracts RGBA components (0...1) from a SwiftUI `Color` in sRGB.
    /// - Parameter color: The already-resolved SwiftUI `Color`.
    /// - Returns: Tuple `(r, g, b, a)` in `[0, 1]` or `nil` if components cannot be resolved.
    public static func rgba(from color: Color) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {
        #if canImport(UIKit)
        // iOS / tvOS / visionOS (UIKit-backed)
        let ui = UIColor(color)
        var r: CGFloat = .zero, g: CGFloat = .zero, b: CGFloat = .zero, a: CGFloat = .zero
        guard ui.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return (r, g, b, a)
        
        #elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
        // macOS (AppKit-backed)
        let ns = NSColor(color)
        guard let rgb = ns.usingColorSpace(.sRGB) else { return nil }
        return (rgb.redComponent, rgb.greenComponent, rgb.blueComponent, rgb.alphaComponent)
        
        #else
        // Other SwiftUI platforms without UIKit/AppKit bridging
        return nil
        #endif
    }
    
    // MARK: - HEX
    
    /// Exports a SwiftUI `Color` as a HEX string in sRGB.
    /// - Parameters:
    ///   - color: The already-resolved SwiftUI `Color`.
    ///   - includeAlpha: If `true`, returns `#RRGGBBAA`; otherwise `#RRGGBB`.
    /// - Returns: HEX string or `nil` if the color cannot be resolved.
    public static func hex(from color: Color, includeAlpha: Bool = false) -> String? {
        // Delegate to RDSColorHex to avoid duplicating formatting logic.
        return RDSColorHex.string(from: color, includeAlpha: includeAlpha)
    }
}
