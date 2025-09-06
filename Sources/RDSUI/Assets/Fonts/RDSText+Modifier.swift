//
//  RDSText+Modifier.swift
//  RDSDesignSystem
//
//  Created by Carlos Guerra Lopez on 02/09/25.
//  - Inject typography & family providers via Environment (DIP/ISP).
//  - Keep modifier API stable (token/slant/color/family/designScale).
//

import SwiftUI

// MARK: - View Modifier

public struct RDSTextModifier: ViewModifier {
    // Inputs
    private let token: RDSTextStyleToken
    private let slant: RDSFontSlant?
    private let color: Color?
    private let explicitFamily: RDSFontFamily?
    private let designScale: CGFloat?

    // Providers (Environment)
    @Environment(\._rdsTypographyProvider) private var typographyProvider
    @Environment(\._rdsFontFamilyProvider) private var fontFamilyProvider

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

    public func body(content: Content) -> some View {
        // 1) Base spec desde el provider; aplica override de slant si hay
        var spec = typographyProvider.spec(for: token)
        if let s = slant { spec = spec.with(slant: s) }

        // 2) Familia efectiva (explícita > preferred del token > provider)
        let family = explicitFamily
            ?? spec.preferredFamily
            ?? fontFamilyProvider.resolvePreferredFamily(for: token)

        // 3) Resuelve Font y métricas concretas
        let (font, kerning, lineSpacing, needsViewItalic) =
            _computeTextStyle(spec: spec, family: family, designScale: designScale)

        // 4) Aplica modificadores
        return content
            .font(font)
            .kerning(kerning)
            .lineSpacing(lineSpacing)
            .italicIf(needsViewItalic)
            .foregroundStyleIf(color)
    }
}

// MARK: - Internal resolver

/// Devuelve `Font` y métricas para una spec/familia dadas.
/// - Parameters:
///   - spec: `RDSTypographySpec` (alias de `RDSTextSpec`) resuelto por el provider.
///   - family: `RDSFontFamily` a usar (system/custom).
///   - designScale: factor px→pt (si `nil`, la spec usa 1.0 por defecto).
/// - Returns: `(font, kerning, extraLineSpacing, needsViewItalic)`.
@MainActor
internal func _computeTextStyle(spec: RDSTypographySpec,
                               family: RDSFontFamily,
                               designScale: CGFloat?) -> (Font, CGFloat, CGFloat, Bool) {
    // 1) Tamaño base en pt (px→pt)
    let basePt = spec.basePointSize(usingScale: designScale)

    // 2) Resolver Font concreto + si requiere italic de vista
    let resolved = RDSFontResolver.resolve(for: spec, family: family, basePointSize: basePt)

    // 3) Kerning: % sobre el point size
    let kernPercent: CGFloat = spec.letterSpacingPercent ?? 0.0
    let kerning = (kernPercent / 100.0) * basePt

    // 4) Espaciado extra para alcanzar line height objetivo
    let lineSpacing: CGFloat
    if let multiple = spec.lineHeightMultiple() {
        lineSpacing = (multiple * basePt) - basePt
    } else {
        lineSpacing = 0
    }

    return (resolved.font, kerning, lineSpacing, resolved.needsViewItalic)
}

// MARK: - View Convenience

public extension View {
    /// Aplica la tipografía RDS usando token y overrides opcionales.
    /// - Parameters:
    ///   - token: Token tipográfico (tamaño, peso y métricas).
    ///   - slant: Slant opcional (e.g., `.italic`).
    ///   - color: Color opcional.
    ///   - family: Familia explícita opcional (si `nil`, usan providers).
    ///   - designScale: Factor px→pt opcional.
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

// MARK: - Tiny helpers

private extension View {
    @ViewBuilder
    func italicIf(_ flag: Bool) -> some View {
        if flag { self.italic() } else { self }
    }

    @ViewBuilder
    func foregroundStyleIf(_ color: Color?) -> some View {
        if let c = color { self.foregroundStyle(c) } else { self }
    }
}
