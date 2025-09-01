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

/// Utilities for determining appropriate foreground (text/icon) color
/// to ensure contrast over a given background.
public enum ReeceColorContrast {

    /// Returns `.black` or `.white` depending on the luminance of the background.
    ///
    /// - Parameters:
    ///   - background: The background color (may be dynamic depending on Light/Dark).
    ///   - scheme: If provided, forces resolution with Light/Dark; if `nil`, uses the system setting.
    ///   - threshold: Luminance threshold [0,1]. Default is `0.57`.
    /// - Returns: `.black` if background is light; `.white` if background is dark
    ///   (or if conversion to sRGB fails).
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
}
