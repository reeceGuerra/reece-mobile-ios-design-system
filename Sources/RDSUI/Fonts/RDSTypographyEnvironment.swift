//
//  RDSTypographyEnvironment.swift
//  RDSDesignSystem
//
//  Created by Carlos Guerra Lopez on 02/09/25.
//

import SwiftUI

/// Defines a global default font family for Reece Typography, propagated via SwiftUI environment.
/// Views can override this value locally, and call sites can still pass an explicit `family:`.
public struct RDSFontFamilyKey: EnvironmentKey {
    /// Default DS font family when no environment or explicit override is set.
    public static let defaultValue: RDSFontFamily = .system
}

public extension EnvironmentValues {
    /// Global default font family used by Reece Typography when no explicit override is provided.
    var reeceFontFamily: RDSFontFamily {
        get { self[RDSFontFamilyKey.self] }
        set { self[RDSFontFamilyKey.self] = newValue }
    }
}

public extension View {
    /// Sets the default Reece font family for this view hierarchy.
    /// - Parameter family: The font family to propagate through the environment.
    /// - Returns: A view configured with the given default font family.
    func reeceFontFamily(_ family: RDSFontFamily) -> some View {
        environment(\.reeceFontFamily, family)
    }
}
