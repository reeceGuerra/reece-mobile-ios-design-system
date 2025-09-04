//
//  ReeceTypographyEnvironment.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 04/09/25.
//

//
//  ReeceTypographyEnvironment.swift
//  ReeceDesignSystem
//
//  Created by Reece Mobile iOS Design System.
//  Copyright ©
//
import SwiftUI

/// # Reece Typography Environment
///
/// Provides a global, app-wide way to select a default `ReeceFontFamily` for all
/// typography APIs in the Reece Design System, while still allowing:
/// 1. **Local overrides** (per call site) by passing an explicit `family:` parameter, and
/// 2. **Token-level exceptions** via a future `preferredFamily` on `ReeceTextSpec` (e.g., a `code`
///    token can force a monospaced/system face regardless of the global default).
///
/// ## Motivation
/// Many teams want to set a single font family (e.g., `Roboto`) at the application root and
/// avoid repeating the `family:` argument everywhere. SwiftUI’s `Environment` is the safest
/// and most ergonomic way to accomplish this in a cross-platform manner.
///
/// ## Resolution priority (highest → lowest)
/// 1. **Explicit per-call override**: `family: .roboto`
/// 2. **Token preferred family**: `spec.preferredFamily` (if the token declares one)
/// 3. **Environment default**: `\.reeceFontFamily` (set at `View` or app root)
/// 4. **System fallback**: `.system`
///
/// > The modifier/builder code that renders text should respect this priority whenever it
/// > resolves the effective font family.
///
/// ## Usage
/// Set the global default font family once at the app entry:
/// ```swift
/// @main
/// struct MyApp: App {
///   var body: some Scene {
///     WindowGroup {
///       RootView()
///         .reeceFontFamily(.roboto) // <- Global default
///     }
///   }
/// }
/// ```
///
/// Locally override for special cases:
/// ```swift
/// Text("Monospace snippet")
///   .reeceText(.code, family: .system) // explicit call-site override
/// ```
///
/// Or, if a token itself should always use a specific family:
/// ```swift
/// // In your token spec mapping (example):
/// // spec.preferredFamily = .system
/// ```
///
/// ## Platform notes
/// - Pure SwiftUI implementation (no UIKit/AppKit dependency).
/// - Designed for iOS 17+ / macOS 14+, matching the package’s deployment targets.
/// - Backwards compatible: if you do nothing, `.system` remains the default.
///
/// ## Testing guidance
/// - Verify that views inherit the global value set via `.reeceFontFamily(_:)`.
/// - Verify that an explicit `family:` parameter at a call site supersedes the environment.
/// - Verify that a token’s `preferredFamily` (if present) supersedes the environment but is
///   itself superseded by an explicit call-site override.
///
/// ## See also
/// - `ReeceTextModifier` / `ReeceTextBuilder` (should read from `\.reeceFontFamily`)
/// - `ReeceTextSpec.preferredFamily` (optional token-level exception)
@available(iOS 17, macOS 14, *)
public struct ReeceFontFamilyKey: EnvironmentKey {
    /// The package-wide fallback if no global or local override is provided.
    /// Keep this as `.system` to ensure predictable, platform-consistent behavior.
    public static let defaultValue: ReeceFontFamily = .system
}

@available(iOS 17, macOS 14, *)
public extension EnvironmentValues {
    /// Global, app-wide default `ReeceFontFamily` used by the Reece Typography APIs
    /// when no explicit `family:` override is provided and the token does not specify
    /// a `preferredFamily`.
    var reeceFontFamily: ReeceFontFamily {
        get { self[ReeceFontFamilyKey.self] }
        set { self[ReeceFontFamilyKey.self] = newValue }
    }
}

@available(iOS 17, macOS 14, *)
public extension View {
    /// Sets the global default `ReeceFontFamily` for this view hierarchy.
    ///
    /// - Parameter family: The font family to use by default for typography in this subtree.
    /// - Returns: A view that propagates `family` through the SwiftUI environment.
    ///
    /// ### Example
    /// ```swift
    /// RootView()
    ///   .reeceFontFamily(.roboto)
    /// ```
    ///
    /// Use explicit overrides at call sites to opt out for specific strings:
    /// ```swift
    /// Text("System-only label")
    ///   .reeceText(.labelMedium, family: .system)
    /// ```
    func reeceFontFamily(_ family: ReeceFontFamily) -> some View {
        environment(\.reeceFontFamily, family)
    }
}
