//
//  RDSTheme.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 29/08/25.
//

import SwiftUI

/// Theme mode selection for color resolution.
public enum RDSThemeMode: CaseIterable, Identifiable, Sendable {
    case system
    case light
    case dark

    // MARK: - Presentation

    /// Human-readable title (useful for settings/UI).
    public var title: String {
        switch self {
        case .system: return "System"
        case .light:  return "Light"
        case .dark:   return "Dark"
        }
    }

    /// Optional explicit override for the target `ColorScheme`.
    /// `nil` means “follow the system”.
    public var preferredOverride: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }

    // MARK: - Identifiable

    public var id: String { self.title }

    // MARK: - Resolution

    /// Resolves this mode into a concrete SwiftUI `ColorScheme`.
    ///
    /// - Parameter viewScheme: The caller’s environment scheme (e.g., `@Environment(\.colorScheme)`).
    /// - Returns: The effective scheme used by the design system.
    public func resolve(_ viewScheme: ColorScheme) -> ColorScheme {
        switch self {
        case .system: return viewScheme
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}

/// Global theme configuration for the package.
/// Apps can override `mode` at runtime (e.g., on settings changes).
@MainActor
public enum RDSTheme {
    /// Default is `.system`. Set to `.light` or `.dark` to force.
    public static var mode: RDSThemeMode = .system
}
