//
//  ReeceColorSupport.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 29/08/25.
//

import SwiftUI

/// Shared helpers for color resolution across all ReeceColors.* files.
@MainActor
enum ReeceColorSupport {
    /// Computes the effective scheme considering the global ReeceTheme.mode.
    static func effectiveScheme(from viewScheme: ColorScheme) -> ColorScheme {
        switch ReeceTheme.mode {
        case .system: return viewScheme
        case .light:  return .light
        case .dark:   return .dark
        }
    }

    /// Picks light/dark variant based on the effective scheme.
    static func pick(light: Color, dark: Color, using viewScheme: ColorScheme) -> Color {
        let scheme = effectiveScheme(from: viewScheme)
        return scheme == .dark ? dark : light
    }
}
