//
//  File.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 29/08/25.
//

import SwiftUI

/// Theme mode selection for color resolution.
public enum ReeceThemeMode: CaseIterable, Identifiable, Sendable {
    case system
    case light
    case dark
    
    public var title: String {
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
    
    public var id: String { self.title }
    
    public static func effectiveScheme(using systemScheme: ColorScheme, themeMode: ReeceThemeMode) -> ColorScheme {
        switch themeMode {
        case .system: return systemScheme
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}

/// Global theme configuration for the package.
/// Apps can override `mode` at runtime (e.g., on settings changes).
@MainActor
public enum ReeceTheme {
    /// Default is `.system`. Set to `.light` or `.dark` to force.
    public static var mode: ReeceThemeMode = .system
}
