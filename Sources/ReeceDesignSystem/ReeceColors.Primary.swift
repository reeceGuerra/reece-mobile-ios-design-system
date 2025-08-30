//
//  ReeceColors.Primary.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 29/08/25.
//

import SwiftUI

/// Base namespace for color tokens.
/// Other files can extend this enum (e.g., Background, Feedback).
public enum ReeceColors {}

@MainActor
public extension ReeceColors {
    /// Primary brand color resolved with theme mode (system/light/dark).
    /// Usage:
    ///   @Environment(\.colorScheme) var scheme
    ///   let color = ReeceColors.primary(using: scheme)
    static func primary(using viewScheme: ColorScheme) -> Color {
        ReeceColorSupport.pick(
            light: Palette.primaryLight,
            dark:  Palette.primaryDark,
            using: viewScheme
        )
    }
}

// MARK: - Base palette (replace with brand tokens later)
private enum Palette {
    static let primaryLight = Color(red: 0.03, green: 0.35, blue: 0.66) // ~#0859A8
    static let primaryDark  = Color(red: 0.72, green: 0.86, blue: 1.00)
}
