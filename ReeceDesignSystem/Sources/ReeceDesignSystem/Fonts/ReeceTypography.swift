//
//  File.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 02/09/25.
//
//  Token API + Figma bridge API.
//  - Tokens: ReeceTypography.text(_:slant:)
//  - Figma:  ReeceTypography.figma(...), using px + % directly
//

import SwiftUI

// MARK: Tokens

public enum ReeceTextStyleToken: CaseIterable, Sendable {
    case displayXL, displayL, displayM
    case headline, titleL, titleM, titleS
    case bodyL, bodyM, bodyS, label, caption
    case code
}

public struct ReeceTextStyle: Sendable {
    public let size: CGFloat        // base size (pt)
    public let weight: ReeceFontWeight
    public let tracking: CGFloat    // points
    public let relativeTo: Font.TextStyle
    public let slant: ReeceFontSlant
    public let lineHeight: CGFloat? // pt (optional)

    @MainActor public func resolve() -> ReeceResolvedFont {
        ReeceFonts.resolveFont(weight: weight, size: size, relativeTo: relativeTo, slant: slant)
    }
}

@MainActor
public enum ReeceTypography {

    // --- Existing token scale (unchanged defaults) ---
    public static func text(_ token: ReeceTextStyleToken, slant: ReeceFontSlant = .normal) -> ReeceTextStyle {
        switch token {
        case .displayXL: return .init(size: 44, weight: .bold,   tracking: 0.2, relativeTo: .largeTitle, slant: slant, lineHeight: nil)
        case .displayL:  return .init(size: 36, weight: .bold,   tracking: 0.2, relativeTo: .largeTitle, slant: slant, lineHeight: nil)
        case .displayM:  return .init(size: 28, weight: .medium, tracking: 0.2, relativeTo: .title,      slant: slant, lineHeight: nil)

        case .headline:  return .init(size: 20, weight: .medium, tracking: 0.1, relativeTo: .headline, slant: slant, lineHeight: nil)
        case .titleL:    return .init(size: 22, weight: .medium, tracking: 0.1, relativeTo: .title2,   slant: slant, lineHeight: nil)
        case .titleM:    return .init(size: 18, weight: .medium, tracking: 0.1, relativeTo: .title3,   slant: slant, lineHeight: nil)
        case .titleS:    return .init(size: 16, weight: .medium, tracking: 0.1, relativeTo: .headline, slant: slant, lineHeight: nil)

        case .bodyL:     return .init(size: 17, weight: .regular, tracking: 0.0, relativeTo: .body,    slant: slant, lineHeight: nil)
        case .bodyM:     return .init(size: 15, weight: .regular, tracking: 0.0, relativeTo: .body,    slant: slant, lineHeight: nil)
        case .bodyS:     return .init(size: 13, weight: .regular, tracking: 0.0, relativeTo: .callout, slant: slant, lineHeight: nil)
        case .label:     return .init(size: 12, weight: .medium,  tracking: 0.1, relativeTo: .caption, slant: slant, lineHeight: nil)
        case .caption:   return .init(size: 11, weight: .regular, tracking: 0.1, relativeTo: .caption2, slant: slant, lineHeight: nil)

        case .code:      return .init(size: 13, weight: .regular, tracking: 0.0, relativeTo: .body,    slant: slant, lineHeight: nil)
        }
    }

    // --- Figma bridge (px + % inputs) ---

    /// Build a text style directly from Figma fields.
    ///
    /// - Parameters:
    ///   - sizePx: Font size in Figma (px). We treat 1 px ≈ 1 pt by default.
    ///   - lineHeightPx: Optional line height in px. When provided, we approximate
    ///                   using `.lineSpacing(lineHeight - size)`.
    ///   - letterSpacingPercent: Optional letter spacing in percent (e.g., 0.75 for 0.75%).
    ///                           Converted to points as `size * (percent/100)`.
    ///   - weightNumber: Figma weight number (e.g., 700). Mapped via `ReeceFonts.weight(fromFigma:)`.
    ///   - italic: Whether the style is italic.
    ///   - relativeTo: Dynamic Type base; default `.body`.
    public static func figma(
        sizePx: CGFloat,
        lineHeightPx: CGFloat? = nil,
        letterSpacingPercent: CGFloat? = nil,
        weightNumber: Int,
        italic: Bool = false,
        relativeTo: Font.TextStyle = .body
    ) -> ReeceTextStyle {
        let weight = ReeceFonts.weight(fromFigma: weightNumber)
        let trackingPts = (letterSpacingPercent ?? 0) * sizePx / 100.0
        let slant: ReeceFontSlant = italic ? .italic : .normal
        return .init(
            size: sizePx,
            weight: weight,
            tracking: trackingPts,
            relativeTo: relativeTo,
            slant: slant,
            lineHeight: lineHeightPx
        )
    }
}
