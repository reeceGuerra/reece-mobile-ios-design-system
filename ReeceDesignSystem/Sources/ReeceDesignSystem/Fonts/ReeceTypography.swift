//
//  File.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 02/09/25.
//
//
//  Defines text style tokens and their concrete values (size, weight, tracking,
//  and scaling behavior) and exposes a simple API to resolve tokens to SwiftUI fonts.
//  Custom/named fonts keep Dynamic Type support using `Font.custom(..., relativeTo:)`.
//
//  Key points:
//  - Use `ReeceTypography.text(_:, slant:)` to obtain a `ReeceTextStyle`
//  - Call `ReeceTextStyle.resolve()` to get a `ReeceResolvedFont`
//  - Or use `Text.reeceText(_:, slant:, color:)` convenience modifier
//

import SwiftUI

/// Public tokens that describe how text should look across the product.
///
/// Choose a token based on intent/role rather than a specific pixel value.
/// This lets the design system tweak the underlying metrics centrally.
public enum ReeceTextStyleToken: CaseIterable, Sendable {

    // MARK: Display / Marketing

    /// Very large, used sparingly for hero moments.
    case displayXL
    /// Large display for marketing headers.
    case displayL
    /// Medium display for prominent headlines.
    case displayM

    // MARK: App Structure

    /// Section or screen-level headline inside the app.
    case headline
    /// Title for important elements (large).
    case titleL
    /// Title for mid-importance elements (medium).
    case titleM
    /// Title for small sub-sections (small).
    case titleS

    // MARK: Body & UI

    /// Primary reading size (large).
    case bodyL
    /// Primary reading size (default).
    case bodyM
    /// Secondary reading size or dense UIs.
    case bodyS
    /// Labels, chips, taglines with medium weight.
    case label
    /// Ancillary small text, disclaimers, timestamps.
    case caption

    // MARK: Monospace

    /// Fixed-width font for code snippets.
    case code
}

/// Concrete style values resolved from a token.
///
/// Use this structure to obtain the SwiftUI `Font` and to feed any additional
/// rendering attributes, like tracking (letter spacing).
public struct ReeceTextStyle: Sendable {

    /// Base point size used when resolving custom or named families.
    /// - Note: With `.systemDefault`, the actual rendered size is driven by
    ///         the platform’s text style referenced by `relativeTo`.
    public let size: CGFloat

    /// Semantic weight for the style.
    public let weight: ReeceFontWeight

    /// Letter spacing (tracking) in points.
    public let tracking: CGFloat

    /// Text style to scale relative to for Dynamic Type.
    public let relativeTo: Font.TextStyle

    /// Desired slant (upright or italic).
    public let slant: ReeceFontSlant

    /// Resolves a `ReeceResolvedFont` for the current `ReeceFonts.activeFamily`.
    ///
    /// - Returns: A `ReeceResolvedFont` containing the `Font` and metadata
    ///            for italic and (system) weight application at the view level.
    @MainActor public func resolve() -> ReeceResolvedFont {
        ReeceFonts.resolveFont(
            weight: weight,
            size: size,
            relativeTo: relativeTo,
            slant: slant
        )
    }
}

/// Resolves tokens to concrete `ReeceTextStyle` values.
///
/// Centralizes all typography metrics, making it easy to modify them without
/// touching call-sites.
@MainActor
public enum ReeceTypography {

    /// Returns the `ReeceTextStyle` for a given token.
    ///
    /// - Parameters:
    ///   - token: The high-level text role (e.g. `.bodyM`, `.headline`).
    ///   - slant: Optional slant to apply (default: `.normal`).
    /// - Returns: A `ReeceTextStyle` carrying size, weight, tracking, `relativeTo`, and `slant`.
    /// - Example:
    ///   ```swift
    ///   let style = ReeceTypography.text(.bodyM, slant: .italic)
    ///   let resolved = style.resolve()
    ///   Text("Hello").font(resolved.font)
    ///   ```
    public static func text(_ token: ReeceTextStyleToken, slant: ReeceFontSlant = .normal) -> ReeceTextStyle {
        switch token {

        // Display / Marketing
        case .displayXL: return .init(size: 44, weight: .bold,     tracking: 0.2, relativeTo: .largeTitle, slant: slant)
        case .displayL:  return .init(size: 36, weight: .bold,     tracking: 0.2, relativeTo: .largeTitle, slant: slant)
        case .displayM:  return .init(size: 28, weight: .medium, tracking: 0.2, relativeTo: .title,      slant: slant)

        // App structure
        case .headline:  return .init(size: 20, weight: .medium, tracking: 0.1, relativeTo: .headline, slant: slant)
        case .titleL:    return .init(size: 22, weight: .medium, tracking: 0.1, relativeTo: .title2,   slant: slant)
        case .titleM:    return .init(size: 18, weight: .medium, tracking: 0.1, relativeTo: .title3,   slant: slant)
        case .titleS:    return .init(size: 16, weight: .medium,   tracking: 0.1, relativeTo: .headline, slant: slant)

        // Body & UI
        case .bodyL:     return .init(size: 17, weight: .regular,  tracking: 0.0, relativeTo: .body,    slant: slant)
        case .bodyM:     return .init(size: 15, weight: .regular,  tracking: 0.0, relativeTo: .body,    slant: slant)
        case .bodyS:     return .init(size: 13, weight: .regular,  tracking: 0.0, relativeTo: .callout, slant: slant)
        case .label:     return .init(size: 12, weight: .medium,   tracking: 0.1, relativeTo: .caption, slant: slant)
        case .caption:   return .init(size: 11, weight: .regular,  tracking: 0.1, relativeTo: .caption2, slant: slant)

        // Monospace
        case .code:      return .init(size: 13, weight: .regular,  tracking: 0.0, relativeTo: .body,    slant: slant)
        }
    }
}
