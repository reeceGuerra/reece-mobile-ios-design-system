//
//  RDSColorEngine.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 29/08/25.
//

import SwiftUI

/// Shared helpers for color resolution across all `RDSColors` families.
///
/// These utilities are isolated to the **MainActor** because color resolution
/// reads the global theme (`RDSTheme.mode`) and is intended to be used from UI code.
///
/// Usage:
/// ```swift
/// // Internal use only:
/// // RDSColorEngine.pick(light: .red, dark: .blue, using: scheme)
/// ```
///
/// - Important: Keep these helpers lightweight; they are called frequently during view rendering.
@MainActor
enum RDSColorEngine {
    /// Computes the effective `ColorScheme` honoring the global `RDSTheme.mode`.
    ///
    /// - Parameter viewScheme: The SwiftUI `ColorScheme` from the environment.
    /// - Returns: The scheme that should be used to resolve tokens (system/light/dark).
    static func effectiveScheme(from viewScheme: ColorScheme) -> ColorScheme {
        switch RDSTheme.mode {
        case .system: return viewScheme
        case .light:  return .light
        case .dark:   return .dark
        }
    }
    
    /// Picks the light/dark variant based on the effective scheme.
    ///
    /// - Parameters:
    ///   - light: Color used when the effective scheme is `.light`.
    ///   - dark:  Color used when the effective scheme is `.dark`.
    ///   - viewScheme: The caller’s environment `ColorScheme`.
    /// - Returns: `dark` if the effective scheme resolves to `.dark`; otherwise `light`.
    static func pick(light: Color, dark: Color, using viewScheme: ColorScheme) -> Color {
        let scheme = effectiveScheme(from: viewScheme)
        return scheme == .dark ? dark : light
    }
}
