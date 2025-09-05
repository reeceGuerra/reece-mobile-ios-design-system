//
//  File.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 29/08/25.
// Add comment

import SwiftUI

/// Theme mode selection for color resolution.
public enum RDSThemeMode: CaseIterable, Identifiable, Sendable {
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
    
    public var preferredOverride: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }
    
    public var id: String { self.title }
    
    public static func effectiveScheme(using systemScheme: ColorScheme, themeMode: RDSThemeMode) -> ColorScheme {
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
public enum RDSTheme {
    /// Default is `.system`. Set to `.light` or `.dark` to force.
    public static var mode: RDSThemeMode = .system
}
