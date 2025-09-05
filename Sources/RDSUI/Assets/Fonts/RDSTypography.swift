//
//  RDSTypography.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 02/09/25.
//
//  Overview
//  --------
//  Design-driven typography spec and tokens.
//  • Accepts font size in pixels (px) from design and converts to points (pt).
//  • Accepts line height in px and uses a scale-independent multiple (lhPx/fontPx).
//  • Accepts letter spacing as percent (%) of font size.
//  • Uses numeric weight mapping → RDSFontWeight.
//  • Supports slant (normal/italic).
//
//  No UIKit dependency
//  -------------------
//  We avoid UIKit to keep this module SwiftUI-only. When no explicit design scale is
//  provided, we default to 1.0 (i.e., 1 px == 1 pt). Call sites may override the scale
//  (e.g., 2.0 or 3.0) if they need it.
//

import SwiftUI

// MARK: - Spec

/// Immutable, design-driven typographic specification.
public struct RDSTextSpec: Sendable {
    /// Design font size in pixels (px). If `pointSizeOverride` is set, it wins.
    public let designFontSizePx: CGFloat?
    /// Optional explicit point size in pt (skips px→pt conversion).
    public let pointSizeOverride: CGFloat?
    /// Typeface weight (domain enum defined in RDSFonts.swift).
    public let weight: RDSFontWeight
    /// Font slant (e.g., `.normal`, `.italic`).
    public let slant: RDSFontSlant
    /// Dynamic Type anchor (e.g., `.body`, `.headline`).
    public let relativeTo: Font.TextStyle
    /// Design line height in pixels (px).
    public let designLineHeightPx: CGFloat?
    /// Letter spacing as percent (%) of font size (nil = default).
    public let letterSpacingPercent: CGFloat?
    /// Optional token-level font family override.
    /// If set, this takes precedence over the environment default unless
    /// a call site passes an explicit `family:`.
    public let preferredFamily: RDSFontFamily?

    // MARK: Base metrics

    /// Returns the base point size (pre–Dynamic Type).
    /// If `pointSizeOverride` exists, it wins; otherwise `px / scale`.
    /// - Parameter scale: Design px→pt scale (defaults to 1.0 if nil).
    /// - Returns: Point size in pt.
    public func basePointSize(usingScale scale: CGFloat?) -> CGFloat {
        if let pt = pointSizeOverride { return pt }
        guard let px = designFontSizePx else { return 0 }
        let s = scale ?? 1.0
        guard s > 0 else { return px }
        return px / s
    }

    /// Returns a scale-independent multiple: lineHeightPx / fontSizePx.
    /// - Returns: The multiple, or `nil` if inputs are missing.
    public func lineHeightMultiple() -> CGFloat? {
        guard let lh = designLineHeightPx, let fontPx = designFontSizePx, fontPx > 0 else { return nil }
        return lh / fontPx
    }

    // MARK: Init

    /// Creates a new text spec.
    /// - Parameters:
    ///   - designFontSizePx: Design font size in px (ignored if overriding `pointSizeOverride`).
    ///   - pointSizeOverride: Explicit point size in pt (skips px→pt).
    ///   - weight: Typeface weight.
    ///   - slant: Font slant (default `.normal`).
    ///   - relativeTo: Dynamic Type anchor.
    ///   - designLineHeightPx: Design line height in px.
    ///   - letterSpacingPercent: Letter spacing as % of point size.
    ///   - preferredFamily: Token-level font family override (default `nil`).
    public init(designFontSizePx: CGFloat? = nil,
                pointSizeOverride: CGFloat? = nil,
                weight: RDSFontWeight,
                slant: RDSFontSlant = .normal,
                relativeTo: Font.TextStyle,
                designLineHeightPx: CGFloat? = nil,
                letterSpacingPercent: CGFloat? = nil,
                preferredFamily: RDSFontFamily? = nil) {
        self.designFontSizePx = designFontSizePx
        self.pointSizeOverride = pointSizeOverride
        self.weight = weight
        self.slant = slant
        self.relativeTo = relativeTo
        self.designLineHeightPx = designLineHeightPx
        self.letterSpacingPercent = letterSpacingPercent
        self.preferredFamily = preferredFamily
    }

    // MARK: Builders

    /// Returns a copy with the provided numeric weight mapped to domain weight.
    /// - Parameter weightNumber: Numeric weight (e.g., 100…900).
    /// - Returns: Updated spec with mapped weight.
    func with(weightNumber: Int) -> RDSTextSpec {
        .init(designFontSizePx: designFontSizePx,
              pointSizeOverride: pointSizeOverride,
              weight: .weight(weightNumber),
              slant: slant,
              relativeTo: relativeTo,
              designLineHeightPx: designLineHeightPx,
              letterSpacingPercent: letterSpacingPercent,
              preferredFamily: preferredFamily)
    }

    /// Returns a copy with a different slant.
    /// - Parameter slant: The desired `RDSFontSlant`.
    /// - Returns: Updated spec preserving all other fields.
    public func with(slant: RDSFontSlant) -> RDSTextSpec {
        .init(designFontSizePx: designFontSizePx,
              pointSizeOverride: pointSizeOverride,
              weight: weight,
              slant: slant,
              relativeTo: relativeTo,
              designLineHeightPx: designLineHeightPx,
              letterSpacingPercent: letterSpacingPercent,
              preferredFamily: preferredFamily)
    }
}

// MARK: - Tokens (defaults; adjust to your design source)

public enum RDSTextStyleToken: CaseIterable, Sendable {
    case h1B, h1M, h1R
    case h2B, h2M, h2R
    case h3B, h3M, h3R
    case h4B, h4M, h4R
    case h5B, h5M, h5R
    case buttonM, buttonS
    case body, caption, code
}

public extension RDSTextStyleToken {
    var spec: RDSTextSpec {
        switch self {
        case .h1B: return .init(designFontSizePx: 48.83, weight: .weight(700), slant: .normal, relativeTo: .largeTitle, designLineHeightPx: 56, letterSpacingPercent: 0.75)
        case .h1M: return .init(designFontSizePx: 48.83, weight: .weight(500), slant: .normal, relativeTo: .largeTitle, designLineHeightPx: 56, letterSpacingPercent: 0.75)
        case .h1R: return .init(designFontSizePx: 48.83, weight: .weight(400), slant: .normal, relativeTo: .largeTitle, designLineHeightPx: 56, letterSpacingPercent: 0.75)

        case .h2B: return .init(designFontSizePx: 39.06, weight: .weight(700), slant: .normal, relativeTo: .title, designLineHeightPx: 46, letterSpacingPercent: 0.75)
        case .h2M: return .init(designFontSizePx: 39.06, weight: .weight(500), slant: .normal, relativeTo: .title, designLineHeightPx: 46, letterSpacingPercent: 0.75)
        case .h2R: return .init(designFontSizePx: 39.06, weight: .weight(400), slant: .normal, relativeTo: .title, designLineHeightPx: 46, letterSpacingPercent: 0.75)

        case .h3B: return .init(designFontSizePx: 31.25, weight: .weight(700), slant: .normal, relativeTo: .title2, designLineHeightPx: 37, letterSpacingPercent: 0.75)
        case .h3M: return .init(designFontSizePx: 31.25, weight: .weight(500), slant: .normal, relativeTo: .title2, designLineHeightPx: 37, letterSpacingPercent: 0.75)
        case .h3R: return .init(designFontSizePx: 31.25, weight: .weight(400), slant: .normal, relativeTo: .title2, designLineHeightPx: 37, letterSpacingPercent: 0.75)

        case .h4B: return .init(designFontSizePx: 25, weight: .weight(700), slant: .normal, relativeTo: .title3, designLineHeightPx: 30, letterSpacingPercent: 0.75)
        case .h4M: return .init(designFontSizePx: 25, weight: .weight(500), slant: .normal, relativeTo: .title3, designLineHeightPx: 30, letterSpacingPercent: 0.75)
        case .h4R: return .init(designFontSizePx: 25, weight: .weight(400), slant: .normal, relativeTo: .title3, designLineHeightPx: 30, letterSpacingPercent: 0.75)

        case .h5B: return .init(designFontSizePx: 20, weight: .weight(700), slant: .normal, relativeTo: .headline,   designLineHeightPx: 24, letterSpacingPercent: 0.75)
        case .h5M: return .init(designFontSizePx: 20, weight: .weight(500), slant: .normal, relativeTo: .subheadline,designLineHeightPx: 24, letterSpacingPercent: 0.75)
        case .h5R: return .init(designFontSizePx: 20, weight: .weight(400), slant: .normal, relativeTo: .subheadline,designLineHeightPx: 24, letterSpacingPercent: 0.75)

        case .buttonM: return .init(designFontSizePx: 16, weight: .weight(500), slant: .normal, relativeTo: .body, designLineHeightPx: 24, letterSpacingPercent: 0.5)
        case .buttonS: return .init(designFontSizePx: 14, weight: .weight(500), slant: .normal, relativeTo: .body, designLineHeightPx: 22, letterSpacingPercent: 0.5)

        case .body:   return .init(designFontSizePx: 16, weight: .weight(400), slant: .normal, relativeTo: .body,    designLineHeightPx: 24, letterSpacingPercent: 0.5)
        case .caption:return .init(designFontSizePx: 12.8, weight: .weight(400), slant: .normal, relativeTo: .caption, designLineHeightPx: 16.2, letterSpacingPercent: 0.0)
        case .code:   return .init(designFontSizePx: 12, weight: .weight(400), slant: .normal, relativeTo: .caption2, designLineHeightPx: 16, letterSpacingPercent: 0.0)
        }
    }
}

