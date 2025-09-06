//
//  PaletteFamily.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 01/09/25.
//

//  - Clarify contract & usage with RDSColorEngine (DIP).
//  - Add thorough docstrings and usage examples.
//  - Preserve public API and behavior.
//

import SwiftUI

// MARK: - Abstractions

/// Contract for a color family that exposes a tone scale and light/dark palettes.
///
/// Conformers provide two dictionaries (`light` / `dark`) keyed by a `Tone` type
/// that represents the design's tone steps (e.g., `.t10`, `.t60`, `.t100`).
///
/// Families **do not** decide which palette to use; that policy is centralized in
/// ``RDSColorEngine`` which resolves the effective `ColorScheme` via a pluggable
/// provider (see `RDSColorSchemeProviding`). This keeps families focused (SRP) and
/// the selection policy swappable (DIP/OCP).
///
/// ### Example
/// ```swift
/// enum PrimaryDarkBlue: RDSPaletteFamily {
///     enum Tone: Hashable, Sendable { case t10, t60, t100 }
///     static let light: [Tone: Color] = [ .t10: Color(...), .t60: ..., .t100: ... ]
///     static let dark:  [Tone: Color] = [ .t10: Color(...), .t60: ..., .t100: ... ]
/// }
///
/// // In a SwiftUI view:
/// let c = PrimaryDarkBlue.color(.t60, using: colorScheme) // picks via RDSColorEngine
/// ```
@MainActor
public protocol RDSPaletteFamily {
    associatedtype Tone: Hashable & Sendable
    static var light: [Tone: Color] { get }
    static var dark:  [Tone: Color] { get }
}

@MainActor
public extension RDSPaletteFamily {
    /// Resolves the effective color for the given tone & scheme using `RDSColorEngine`.
    ///
    /// - Parameters:
    ///   - tone: Design tone key (e.g., `.t10`, `.t60`, `.t100`).
    ///   - scheme: The caller's environment `ColorScheme` (e.g., `@Environment(\.colorScheme)`).
    /// - Returns: The resolved `Color`. Returns `.clear` as a safe fallback if a tone is missing.
    static func color(_ tone: Tone, using scheme: ColorScheme) -> Color {
        guard let light = light[tone], let dark = dark[tone] else {
            assertionFailure("Missing tone \(tone) in \(Self.self)")
            return Color.clear // safe fallback in release
        }
        return RDSColorEngine.pick(light: light, dark: dark, using: scheme)
    }
}
