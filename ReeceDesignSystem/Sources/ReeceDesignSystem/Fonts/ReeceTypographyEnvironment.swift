//
//  ReeceTypographyEnvironment.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 04/09/25.
//

import SwiftUI

/// Defines a global default font family for Reece Typography, propagated via SwiftUI environment.
/// Views can override this value locally, and call sites can still pass an explicit `family:`.
@available(iOS 17, macOS 14, *)
public struct ReeceFontFamilyKey: EnvironmentKey {
    /// Default DS font family when no environment or explicit override is set.
    public static let defaultValue: ReeceFontFamily = .system
}

@available(iOS 17, macOS 14, *)
public extension EnvironmentValues {
    /// Global default font family used by Reece Typography when no explicit override is provided.
    var reeceFontFamily: ReeceFontFamily {
        get { self[ReeceFontFamilyKey.self] }
        set { self[ReeceFontFamilyKey.self] = newValue }
    }
}

@available(iOS 17, macOS 14, *)
public extension View {
    /// Sets the default Reece font family for this view hierarchy.
    /// - Parameter family: The font family to propagate through the environment.
    /// - Returns: A view configured with the given default font family.
    func reeceFontFamily(_ family: ReeceFontFamily) -> some View {
        environment(\.reeceFontFamily, family)
    }
}
