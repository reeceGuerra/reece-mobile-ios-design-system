//
//  ReeceFonts.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 02/09/25.
//
//  Resolves and configures the font family used by the design system,
//  including italic handling and a known-families enum (e.g., Roboto)
//  to avoid hard-coded strings in the public API.
//
//  Typical usage:
//
//  ```swift
//  import ReeceDesignSystem
//
//  @main
//  struct DemoApp: App {
//      init() {
//          // Use Roboto family you bundled under Resources/Fonts:
//          ReeceFonts.activeFamily = .named(.roboto)
//          ReeceFonts.registerBundledFonts()
//      }
//      var body: some Scene { WindowGroup { ContentView() } }
//  }
//  ```
//

import SwiftUI

// MARK: - Public API

/// Namespace that holds configuration and resolution helpers
/// for the design system font family, including italic handling.
@MainActor
public enum ReeceFonts {

    /// The active font family used by typography tokens across the app.
    ///
    /// - Important: Set this once at app start. If not set, `.systemDefault` is used.
    /// - Note: For `.named(.roboto)` or `.custom(prefix:)`, the runtime expects fonts with
    ///         PostScript names such as:
    ///         - "Roboto-Regular",  "Roboto-Italic"
    ///         - "Roboto-Medium",   "Roboto-MediumItalic"
    ///         - "Roboto-Bold",     "Roboto-BoldItalic"
    ///         - (Optional) "Roboto-Semibold", "Roboto-SemiboldItalic" if you include them.
    public static var activeFamily: ReeceFontFamily = .systemDefault

    /// Registers bundled fonts contained in the package resources.
    ///
    /// Call this if you include font files inside `Resources/Fonts` and selected
    /// `.named(...)` or `.custom(prefix:)` as `activeFamily`.
    ///
    /// - Note: With SwiftPM resources and `Font.custom(..., relativeTo:)`,
    ///         explicit CoreText registration is generally not required on Apple
    ///         platforms as long as the font files are correctly included in the bundle.
    ///         This hook remains for future validation/logging opportunities.
    public static func registerBundledFonts() {
        // Intentionally left empty; SPM resource inclusion is sufficient.
    }

    /// Resolves a SwiftUI `Font` for the current `activeFamily`, including italic intent.
    ///
    /// For system fallback (`.systemDefault`), italic must be applied as a **view modifier**
    /// (e.g., `Text(...).italic()`). This method therefore returns both a `Font` and flags
    /// indicating whether you need to apply `.italic()` and/or `.fontWeight(_:)` at call sites.
    ///
    /// For named/custom families, the method resolves expected PostScript font names and
    /// uses `Font.custom(name:size:relativeTo:)`, which preserves Dynamic Type scaling.
    ///
    /// - Parameters:
    ///   - weight: The semantic weight to use (e.g., `.regular`, `.semibold`).
    ///   - size: The base point size used when resolving **custom/named** fonts.
    ///           Ignored for `.systemDefault` because we rely on `.system(_:design:)`
    ///           for Dynamic Type behavior.
    ///   - relativeTo: The Dynamic Type text style to scale relative to.
    ///   - slant: The italic intent (default: `.normal`).
    /// - Returns: A `ReeceResolvedFont` containing the `Font` plus metadata indicating any
    ///            additional view modifiers needed (italic, system weight).
    public static func resolveFont(
        weight: ReeceFontWeight,
        size: CGFloat,
        relativeTo: Font.TextStyle,
        slant: ReeceFontSlant = .normal
    ) -> ReeceResolvedFont {
        switch activeFamily {
        case .systemDefault:
            // Use system dynamic style; apply weight and (if needed) italic at view level.
            let base = Font.system(relativeTo, design: .default)
            return .init(
                font: base,
                needsViewItalic: (slant == .italic),
                systemWeight: weight.swiftUI
            )

        case .named(let name):
            let name = name.resolveName(for: weight, slant: slant)
            let custom = Font.custom(name, size: size, relativeTo: relativeTo)
            return .init(font: custom, needsViewItalic: false, systemWeight: nil)
        }
    }
}

// MARK: - Families & Traits

/// Known font families supported out of the box by the design system.
///
/// Add new cases here (and in the resolver below) to expose more families
/// without relying on hard-coded strings throughout the codebase.
public enum ReeceKnownFontFamily: String, CaseIterable, Sendable {
    /// Google Roboto family. Expected files (subset):
    /// - Roboto-Regular.ttf / Roboto-Italic.ttf
    /// - Roboto-Medium.ttf  / Roboto-MediumItalic.ttf
    /// - Roboto-Bold.ttf    / Roboto-BoldItalic.ttf
    /// - (Optional) Roboto-Semibold.ttf / Roboto-SemiboldItalic.ttf
    case roboto = "Roboto"

    /// Returns the canonical PostScript font name for a given weight and slant.
    /// Adjust this mapping if your files use different suffix conventions.
    fileprivate func resolveName(for weight: ReeceFontWeight, slant: ReeceFontSlant) -> String {
        let base: String

        switch self {
        case .roboto:
            // Roboto commonly ships Regular / Medium / Bold (no Semibold in classic set).
            // We approximate `.semibold` with "Medium" unless a Semibold face is present.
            switch weight {
            case .black:    base = "Roboto-Black"
            case .bold:     base = "Roboto-Bold"
            case .regular:  base = slant == .normal ? "Roboto-Regular" : "Roboto-"
            case .medium:   base = "Roboto-Medium"
            case .light:    base = "Roboto-Light"
            }
        }

        return slant == .italic ? base + "Italic" : base
    }
}

/// Represents the font family strategy for the design system.
///
/// - `.systemDefault`
///   Uses the platform’s SF family via SwiftUI's `.system` font, enabling
///   Dynamic Type behavior out of the box. Italic must be applied with the
///   view modifier `.italic()`.
///
/// - `.named(ReeceKnownFontFamily)`
///   Uses a predefined family (e.g., `.roboto`) with known PostScript naming.
///
/// - `.custom(prefix:)`
///   Uses a custom name prefix. The prefix is combined with weight and slant
///   to produce PostScript font names (e.g., `"MyBrand-MediumItalic"`).
public enum ReeceFontFamily: Sendable, Equatable {
    case systemDefault
    case named(ReeceKnownFontFamily)

    /// Resolves a concrete PostScript font name for the given semantic weight and slant.
    ///
    /// - Parameters:
    ///   - weight: The semantic weight requested.
    ///   - slant: The slant (normal or italic).
    /// - Returns: The full PostScript font name for `.named` / `.custom`; otherwise `nil` for `.systemDefault`.
    func resolveName(for weight: ReeceFontWeight, slant: ReeceFontSlant) -> String? {
        switch self {
        case .systemDefault:
            return nil
        case .named(let known):
            return known.resolveName(for: weight, slant: slant)
        }
    }
}

/// Semantic font weights used by typography tokens.
///
/// These values map to SwiftUI's `Font.Weight`, keeping API usage consistent
/// across system and custom fonts.
public enum ReeceFontWeight: Sendable {
    case black
    case bold
    case regular
    case medium
    case light

    /// Maps a semantic `ReeceFontWeight` to SwiftUI's `Font.Weight`.
    var swiftUI: Font.Weight {
        switch self {
        case .black:   return .black
        case .bold:     return .bold
        case .regular:  return .regular
        case .medium:   return .medium
        case .light:    return .light
        }
    }
}

/// Slant (upright vs. italic) used when resolving fonts.
///
/// - `.normal`: Upright (roman) shape.
/// - `.italic`: Italic shape. For system fallback, apply `.italic()` as a view modifier.
public enum ReeceFontSlant: Sendable {
    case normal
    case italic
}

// MARK: - Resolution Result

/// A resolved font along with metadata indicating if the caller should
/// also apply SwiftUI view modifiers like `.italic()` or `.fontWeight(_:)`.
///
/// - Note: This is necessary because italic in SwiftUI is a **view modifier**.
///         For system fonts, we can't construct an italic `Font` directly;
///         we signal that the caller should apply `.italic()`. Similarly, we expose
///         the system weight so it can be applied via `.fontWeight(_:)`.
public struct ReeceResolvedFont: Sendable {
    /// The `Font` to apply via `.font(...)`.
    public let font: Font
    /// `true` when the caller should also apply `.italic()` to the view.
    public let needsViewItalic: Bool
    /// Optional system weight to apply when using `.system(_:)`.
    /// This allows the caller to also set `.fontWeight(...)` on the view.
    public let systemWeight: Font.Weight?

    /// Creates a resolved font.
    /// - Parameters:
    ///   - font: The resolved SwiftUI `Font`.
    ///   - needsViewItalic: Whether the caller should apply `.italic()` at the view level.
    ///   - systemWeight: Optional `Font.Weight` for system fallback cases.
    public init(font: Font, needsViewItalic: Bool, systemWeight: Font.Weight?) {
        self.font = font
        self.needsViewItalic = needsViewItalic
        self.systemWeight = systemWeight
    }
}

// MARK: - View Convenience (Optional)

public extension View {
    /// Conditionally applies the SwiftUI `.italic()` modifier based on a boolean flag.
    ///
    /// - Parameter enabled: When `true`, the view is rendered in italic.
    /// - Returns: A view that conditionally applies `.italic()`.
    @ViewBuilder
    func reeceApplyItalicIfNeeded(_ enabled: Bool) -> some View {
        if enabled { self.italic() } else { self }
    }

    /// Conditionally applies `.fontWeight(_:)` when a non-nil weight is provided.
    ///
    /// - Parameter weight: `Font.Weight` to apply; when `nil`, no-op.
    /// - Returns: A view that conditionally applies `.fontWeight(weight)`.
    @ViewBuilder
    func reeceApplySystemWeightIfNeeded(_ weight: Font.Weight?) -> some View {
        if let w = weight { self.fontWeight(w) } else { self }
    }
}

extension Bundle {
    /// The resource bundle for this package/module.
    ///
    /// - Returns: `Bundle.module` when built via SwiftPM; otherwise `.main`.
    @MainActor static var reeceBundle: Bundle = {
        #if SWIFT_PACKAGE
        return .module
        #else
        return .main
        #endif
    }()
}
