//
//  ReeceColorContrast.swift
//  ReeceDesignSystem
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

/// Utilities for determining an appropriate foreground (text/icon) color
/// that ensures sufficient contrast over a given background.
public enum ReeceColorContrast {

    /// Returns `.black` or `.white` depending on the background luminance.
    ///
    /// - Parameters:
    ///   - background: The background color (may be dynamic for Light/Dark).
    ///   - scheme: If provided, resolves the color using the given Light/Dark scheme; if `nil`, uses the system setting.
    ///   - threshold: Luminance threshold in `[0, 1]`. Defaults to `0.57`.
    /// - Returns: `.black` if background is light; `.white` if background is dark,
    ///   or `.white` if conversion to sRGB fails.
    public static func onColor(
        for background: Color,
        scheme: ColorScheme? = nil,
        threshold: Double = 0.57
    ) -> Color {
        guard let c = ReeceColorExport.resolvedPlatformColor(from: background, scheme: scheme) else {
            return .white
        }

        // Relative luminance in sRGB
        let r = Double(c.red), g = Double(c.green), b = Double(c.blue)
        let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return luminance > threshold ? .black : .white
    }

    // MARK: - Backward compatibility (deprecated)

    /// Deprecated alias. Use `onColor(for:scheme:threshold:)` instead.
    @available(*, deprecated, message: "Use onColor(for:scheme:threshold:) instead.")
    public static func preferredLabelColor(
        over background: Color,
        scheme: ColorScheme? = nil,
        threshold: Double = 0.57
    ) -> Color {
        onColor(for: background, scheme: scheme, threshold: threshold)
    }
}
