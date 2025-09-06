//
//  RDSTypographySpecTests.swift
//  RDSDesignSystem
//
//  Created by ChatGPT on 03/09/25.
//

import Testing
import SwiftUI
@testable import RDSUI

@Suite("RDSTypography Spec")
struct RDSTypographySpecTests {

    // MARK: - Base point size & scale

    @Test("basePointSize uses design scale (px / scale), with non-positive scale falling back to px")
    func basePointSize_usesDesignScale() {
        // h4B: 25 px, lineHeight 30 px, ls% 0.75
        let spec = RDSTextStyleToken.h4B.spec
        let tol: CGFloat = 0.0001

        // scale = 1.0 → 25 pt
        #expect(abs(spec.basePointSize(usingScale: 1.0) - 25.0) <= tol)

        // scale = 2.0 → 12.5 pt
        #expect(abs(spec.basePointSize(usingScale: 2.0) - 12.5) <= tol)

        // scale = 0 (invalid) → fallback to px (25 pt)
        #expect(abs(spec.basePointSize(usingScale: 0.0) - 25.0) <= tol)

        // scale = nil → defaults to 1.0
        #expect(abs(spec.basePointSize(usingScale: nil) - 25.0) <= tol)
    }

    // MARK: - Line height multiple & letter spacing

    @Test("lineHeightMultiple returns lhPx/fontPx; letterSpacingPercent is present as specified")
    func lineHeightMultiple_and_letterSpacing() {
        let spec = RDSTextStyleToken.h4B.spec
        let multiple = spec.lineHeightMultiple()

        // 30 / 25 = 1.2
        let tol: CGFloat = 0.0001
        #expect(multiple != nil)
        #expect(abs(multiple! - 1.2) <= tol)

        // Token table sets 0.75% for h4*
        #expect(spec.letterSpacingPercent == 0.75)
    }

    // MARK: - Weight mapping

    @Test("with(weightNumber:) maps numeric weights to DS buckets")
    func withWeightNumber_mapping() {
        let base = RDSTextSpec(
            designFontSizePx: 16,
            pointSizeOverride: nil,
            weight: .regular,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: 24,
            letterSpacingPercent: 0.0,
            preferredFamily: nil
        )

        // 100/300 → light
        #expect(base.with(weightNumber: 100).weight == .light)
        #expect(base.with(weightNumber: 300).weight == .light)

        // 400 → regular
        #expect(base.with(weightNumber: 400).weight == .regular)

        // 500 → medium
        #expect(base.with(weightNumber: 500).weight == .medium)

        // 600/700 → bold
        #expect(base.with(weightNumber: 600).weight == .bold)
        #expect(base.with(weightNumber: 700).weight == .bold)

        // 900+ → black
        #expect(base.with(weightNumber: 900).weight == .black)
        #expect(base.with(weightNumber: 1000).weight == .black)
    }

    // MARK: - Slant builder

    @Test("with(slant:) only changes slant")
    func withSlant_changesOnlySlant() {
        let base = RDSTextSpec(
            designFontSizePx: 18,
            pointSizeOverride: nil,
            weight: .medium,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: 24,
            letterSpacingPercent: 0.5,
            preferredFamily: .system
        )
        let italic = base.with(slant: .italic)

        #expect(italic.slant == .italic)
        #expect(italic.weight == base.weight)
        #expect(italic.designFontSizePx == base.designFontSizePx)
        #expect(italic.letterSpacingPercent == base.letterSpacingPercent)
        #expect(italic.preferredFamily == base.preferredFamily)
    }
}
