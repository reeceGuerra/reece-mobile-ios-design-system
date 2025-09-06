//
//  RDSColorEngine.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 29/08/25.
//  - Introduce RDSColorSchemeProviding (DIP).
//  - Add default adapter RDSThemeColorSchemeProvider (SRP).
//  - Make scheme resolution swappable (testable, OCP).
//

import SwiftUI

// MARK: - Abstractions

/// Abstraction for resolving the **effective** color scheme used by the design system.
///
/// Conformers decide how to compute the final scheme (e.g., based on a global theme mode,
/// system appearance, or custom logic). This decouples color resolution from a concrete theme.
@MainActor
public protocol RDSColorSchemeProviding: Sendable {
    /// Resolves the effective scheme given the caller's environment `ColorScheme`.
    /// - Parameter viewScheme: The `ColorScheme` from the view environment.
    func effectiveScheme(viewScheme: ColorScheme) -> ColorScheme
}

/// Default adapter that bridges to the current `RDSTheme` mode.
///
/// Keeps backwards compatibility: if you rely on `RDSTheme.mode` today,
/// this provider preserves that behavior while allowing you to swap implementations in tests.
public struct RDSThemeColorSchemeProvider: RDSColorSchemeProviding {
    public init() {}
    public func effectiveScheme(viewScheme: ColorScheme) -> ColorScheme {
        // NOTE: If RDSTheme provides a different API, adapt here.
        // This call is intentionally the only place that knows about RDSTheme.
        RDSTheme.mode.resolve(viewScheme)
    }
}

// MARK: - Engine

/// Shared helpers for color resolution across all `RDSColors` families.
///
/// These utilities are isolated to the **MainActor** because color resolution
/// is intended to be used from UI code. The effective scheme is delegated to a
/// pluggable provider (`RDSColorSchemeProviding`) for testability and extension.
@MainActor
public enum RDSColorEngine {
    
    // MARK: Provider
    
    /// Current provider used to resolve the effective color scheme.
    /// Defaults to `RDSThemeColorSchemeProvider`.
    private static var schemeProvider: RDSColorSchemeProviding = RDSThemeColorSchemeProvider()
    
    /// Overrides the color scheme provider globally (e.g., in tests).
    /// - Parameter provider: A new provider to resolve the effective scheme.
    public static func use(_ provider: RDSColorSchemeProviding) {
        schemeProvider = provider
    }
    
    /// Restores the default provider that bridges to `RDSTheme`.
    public static func useDefaultProvider() {
        schemeProvider = RDSThemeColorSchemeProvider()
    }
    
    // MARK: Resolution
    
    /// Computes the effective scheme using the configured provider.
    /// - Parameter viewScheme: Caller’s environment `ColorScheme`.
    /// - Returns: The effective `ColorScheme` for color picking.
    public static func effectiveScheme(from viewScheme: ColorScheme) -> ColorScheme {
        schemeProvider.effectiveScheme(viewScheme: viewScheme)
    }
    
    /// Picks the light/dark variant based on the effective scheme.
    ///
    /// - Parameters:
    ///   - light: Color used when the effective scheme is `.light`.
    ///   - dark:  Color used when the effective scheme is `.dark`.
    ///   - viewScheme: The caller’s environment `ColorScheme`.
    /// - Returns: `dark` if the effective scheme resolves to `.dark`; otherwise `light`.
    public static func pick(light: Color, dark: Color, using viewScheme: ColorScheme) -> Color {
        let scheme = effectiveScheme(from: viewScheme)
        return scheme == .dark ? dark : light
    }
}
