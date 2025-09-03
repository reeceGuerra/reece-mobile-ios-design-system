//
//  ReeceText+Modifier.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 02/09/25.
//
//  Public APIs:
//   1) Builder: ReeceText(_:token:slant:color:family:designScale:)
//   2) View fallback: .reeceText(_:slant:color:family:designScale:)
// Implementation notes:
//   - @MainActor: all SwiftUI-facing APIs are main-actor isolated.
//   - _computeTextStyle(...) unwraps optional letterSpacingPercent safely.
//

import SwiftUI

// MARK: - Public Builder

/// Preferred builder when you create a new Text from a String.
@MainActor
@inlinable
public func ReeceText(
    _ string: String,
    token: ReeceTextStyleToken,
    slant: ReeceFontSlant? = nil,
    color: Color? = nil,
    family: ReeceFontFamily = .system,
    designScale: CGFloat? = nil
) -> some View {
    Text(string).reeceText(token, slant: slant, color: color, family: family, designScale: designScale)
}

// MARK: - Internal Pure Helper (unit-testable)

/// Computes font, kerning and line spacing for a given spec/family/scale.
/// - Returns: `(font, kerning, lineSpacing, needsViewItalic)`
///
/// Notes:
/// - `kerning` is computed from a percent of the *base point size*.
/// - `lineSpacing` is the *extra* spacing derived from line-height multiple.
/// - `needsViewItalic` is true for families that require view-level italics (e.g., `.system`).
@MainActor
@usableFromInline
internal func _computeTextStyle(
    spec: ReeceTextSpec,
    family: ReeceFontFamily,
    designScale: CGFloat
) -> (font: Font, kerning: CGFloat, lineSpacing: CGFloat, needsViewItalic: Bool) {

    let basePt = spec.basePointSize(usingScale: designScale)
    let resolved = ReeceFontResolver.resolve(for: spec, family: family, basePointSize: basePt)

    // SAFE unwrap for optional kerning percentage
    let kernPercent: Double = spec.letterSpacingPercent ?? 0.0
    let kerning = CGFloat(kernPercent / 100.0) * basePt

    // Extra spacing over the base point size (optional multiple)
    let lineSpacing: CGFloat
    if let multiple = spec.lineHeightMultiple() {
        lineSpacing = (CGFloat(multiple) * basePt) - basePt
    } else {
        lineSpacing = 0
    }

    return (resolved.font, kerning, lineSpacing, resolved.needsViewItalic)
}

// MARK: - ViewModifier

@MainActor
public struct ReeceTextModifier: ViewModifier {
    public let token: ReeceTextStyleToken
    public let slant: ReeceFontSlant?
    public let color: Color?
    public let family: ReeceFontFamily
    public let designScale: CGFloat?

    @inlinable
    public init(
        token: ReeceTextStyleToken,
        slant: ReeceFontSlant? = nil,
        color: Color? = nil,
        family: ReeceFontFamily = .system,
        designScale: CGFloat? = nil
    ) {
        self.token = token
        self.slant = slant
        self.color = color
        self.family = family
        self.designScale = designScale
    }

    public func body(content: Content) -> some View {
        // ❱❱ Todo lo “no-View” se calcula *antes* del builder
        let baseSpec = token.spec
        let effectiveSpec = slant.map { baseSpec.with(slant: $0) } ?? baseSpec
        let scale = designScale ?? 1.0
        let r = _computeTextStyle(spec: effectiveSpec, family: family, designScale: scale)

        // ❱❱ Ahora sí, un único `View` de retorno
        let base = content
            .font(r.font)
            .kerning(r.kerning)
            .lineSpacing(r.lineSpacing)

        return Group {
            if r.needsViewItalic {
                if let c = color {
                    base.italic().foregroundColor(c)
                } else {
                    base.italic()
                }
            } else {
                if let c = color {
                    base.foregroundColor(c)
                } else {
                    base
                }
            }
        }
    }
}


// MARK: - Public Fallback API on View

@MainActor
public extension View {
    /// Fallback API when you already have a Text value.
    func reeceText(
        _ token: ReeceTextStyleToken,
        slant: ReeceFontSlant? = nil,
        color: Color? = nil,
        family: ReeceFontFamily = .system,
        designScale: CGFloat? = nil
    ) -> some View {
        modifier(ReeceTextModifier(
            token: token,
            slant: slant,
            color: color,
            family: family,
            designScale: designScale
        ))
    }
}
