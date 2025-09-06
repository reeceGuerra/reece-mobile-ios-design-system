//
//  RDSText+Modifier.swift
//  RDSDesignSystem
//
//  Created by Carlos Guerra Lopez on 02/09/25.
//
//  Overview:
//  Applies Reece Typography to SwiftUI views using token specs and the global
//  font-family environment. Family resolution priority:
//    1) Explicit `family:` at call site
//    2) Token `preferredFamily`
//    3) Environment (`\.reeceFontFamily`)
//    4) `.system` fallback
//
//  Notes:
//  - Main-actor isolated for SwiftUI usage.
//  - `_computeTextStyle(...)` is an internal free function for testability.
//

import SwiftUI

// MARK: - Compute helper

/// Computes the concrete SwiftUI text style (font, kerning and line spacing)
/// from a `RDSTextSpec`, an effective font `family`, and an optional `designScale`.
///
/// This function is intentionally declared at module scope with **internal** visibility,
/// so it can be imported by tests using `@testable import RDSDesignSystem`.
///
/// - Parameters:
///   - spec: Fully design-driven text specification (px-based inputs and metadata).
///   - family: Effective font family to use after priority resolution.
///   - designScale: Optional px→pt scale factor. If `nil`, a default scale is applied in the spec.
/// - Returns: A tuple with:
///   - `font`: The resolved `SwiftUI.Font` to render the text.
///   - `kerning`: Kerning in **points**, computed from `letterSpacingPercent`.
///   - `lineSpacing`: Extra leading in **points** computed from line-height.
///   - `needsViewItalic`: `true` if the view should apply `.italic()` (e.g. system fallback).
func _computeTextStyle(spec: RDSTextSpec,
                       family: RDSFontFamily,
                       designScale: CGFloat?) -> (font: Font, kerning: CGFloat, lineSpacing: CGFloat, needsViewItalic: Bool) {

    // 1) Base size in points (pre–Dynamic Type)
    let basePt = spec.basePointSize(usingScale: designScale)

    // 2) Resolve font via central resolver (in RDSFonts.swift)
    let resolved = RDSFontResolver.resolve(for: spec,
                                             family: family,
                                             basePointSize: basePt)

    // 3) Kerning from percent over point size
    let kernPercent: CGFloat = spec.letterSpacingPercent ?? 0.0
    let kerning = (kernPercent / 100.0) * basePt

    // 4) Extra spacing over the base point size
    let lineSpacing: CGFloat
    if let multiple = spec.lineHeightMultiple() {
        lineSpacing = (multiple * basePt) - basePt
    } else {
        lineSpacing = 0
    }

    return (resolved.font, kerning, lineSpacing, resolved.needsViewItalic)
}

// MARK: - Reece Text Modifier (Environment-aware)

/// A SwiftUI `ViewModifier` that applies Reece Typography to any view using token specs
/// and the global font-family environment.
///
/// Family resolution priority (highest → lowest):
/// 1) Explicit `family:` at call site
/// 2) Token `preferredFamily`
/// 3) Environment `\.reeceFontFamily`
/// 4) `.system` fallback
public struct RDSTextModifier: ViewModifier {
    // Inputs
    private let token: RDSTextStyleToken
    private let slant: RDSFontSlant?
    private let color: Color?
    private let explicitFamily: RDSFontFamily?
    private let designScale: CGFloat?

    /// Global default font family provided by the SwiftUI environment.
    @Environment(\.rdsFontFamily) private var envFamily

    /// Creates a modifier that styles text according to a Reece token.
    ///
    /// - Parameters:
    ///   - token: Typography token describing size, weight, and metrics.
    ///   - slant: Optional font slant (e.g., `.italic`). Defaults to `nil` (no override).
    ///   - color: Optional SwiftUI color to apply with `.foregroundStyle`. Defaults to `nil`.
    ///   - family: Optional explicit font family override. If `nil`, the environment is used.
    ///   - designScale: Optional design px → pt scale factor used during resolution.
    public init(token: RDSTextStyleToken,
                slant: RDSFontSlant? = nil,
                color: Color? = nil,
                family: RDSFontFamily? = nil,
                designScale: CGFloat? = nil) {
        self.token = token
        self.slant = slant
        self.color = color
        self.explicitFamily = family
        self.designScale = designScale
    }

    /// Builds the styled view by resolving the effective family, computing the concrete
    /// font/metrics via `_computeTextStyle`, and applying the resulting modifiers.
    ///
    /// - Parameter content: The input view to style.
    /// - Returns: A view with font, kerning and line spacing applied.
    public func body(content: Content) -> some View {
        // Base token spec
        var spec = token.spec

        // Apply slant override (if any)
        if let s = slant {
            spec = spec.with(slant: s)
        }

        // Resolve effective family with the documented priority.
        let effectiveFamily = explicitFamily
            ?? spec.preferredFamily
            ?? envFamily

        // Compute final font & metrics via resolver
        let style = _computeTextStyle(spec: spec,
                                      family: effectiveFamily,
                                      designScale: designScale)

        // Apply to content (chain conditionally to keep opaque type consistent)
        return content
            .font(style.font)
            .kerning(style.kerning)
            .lineSpacing(style.lineSpacing)
            .italicIf(style.needsViewItalic)
            .foregroundStyleIf(color)
    }
}

// MARK: - View Convenience

public extension View {
    /// Applies Reece Typography using the given token and optional overrides.
    ///
    /// This is a convenience over manually constructing `RDSTextModifier`.
    ///
    /// - Parameters:
    ///   - token: Typography token describing size, weight and metrics.
    ///   - slant: Optional font slant (e.g., `.italic`). Defaults to `nil`.
    ///   - color: Optional SwiftUI color to apply. Defaults to `nil`.
    ///   - family: Optional explicit font family override. If `nil`, the environment is used.
    ///   - designScale: Optional design px → pt scale factor used during resolution.
    /// - Returns: A view styled with Reece Typography rules.
    func rdsTextStyle(_ token: RDSTextStyleToken,
                   slant: RDSFontSlant? = nil,
                   color: Color? = nil,
                   family: RDSFontFamily? = nil,
                   designScale: CGFloat? = nil) -> some View {
        modifier(RDSTextModifier(token: token,
                                   slant: slant,
                                   color: color,
                                   family: family,
                                   designScale: designScale))
    }
}

// MARK: - Conditional helpers

private extension View {
    /// Conditionally applies `.italic()` when `flag` is `true`.
    /// - Parameter flag: When `true`, applies `.italic()`.
    /// - Returns: Either `self.italic()` or `self` unchanged.
    @ViewBuilder
    func italicIf(_ flag: Bool) -> some View {
        if flag { self.italic() } else { self }
    }

    /// Conditionally applies `.foregroundStyle(_:)` when a color is provided.
    /// - Parameter color: Optional SwiftUI `Color` to apply.
    /// - Returns: Either `self.foregroundStyle(c)` or `self` unchanged.
    @ViewBuilder
    func foregroundStyleIf(_ color: Color?) -> some View {
        if let c = color { self.foregroundStyle(c) } else { self }
    }
}
