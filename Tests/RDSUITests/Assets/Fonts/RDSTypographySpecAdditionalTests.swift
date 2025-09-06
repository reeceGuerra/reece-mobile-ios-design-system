//
//  RDSTypographySpecAdditionalTests.swift
//  RDSDesignSystem
//
//  Created by ChatGPT on 03/09/25.
//

import Testing
import SwiftUI
@testable import RDSUI

@Suite("RDSTypography Spec (additional branches)")
struct RDSTypographySpecAdditionalTests {

    // MARK: - basePointSize

    @Test("basePointSize uses pointSizeOverride when provided (ignores scale)")
    func basePointSize_usesOverride() {
        let spec = RDSTextSpec(
            designFontSizePx: 20,          // ignored
            pointSizeOverride: 14,         // wins
            weight: .regular,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: 24,
            letterSpacingPercent: 0.0,
            preferredFamily: nil
        )

        #expect(spec.basePointSize(usingScale: nil) == 14)
        #expect(spec.basePointSize(usingScale: 2.0) == 14)
        #expect(spec.basePointSize(usingScale: 3.0) == 14)
    }

    @Test("basePointSize converts px to pt using scale when no override")
    func basePointSize_pxOverScale() {
        let spec = RDSTextSpec(
            designFontSizePx: 20,          // px
            pointSizeOverride: nil,        // use px / scale
            weight: .regular,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: 30,
            letterSpacingPercent: 0.0,
            preferredFamily: nil
        )

        let tol: CGFloat = 0.0001
        #expect(abs(spec.basePointSize(usingScale: 2.0) - 10.0) <= tol)
        #expect(abs(spec.basePointSize(usingScale: 1.25) - 16.0) <= tol)
    }

    // MARK: - Builders

    @Test("with(slant:) changes only the slant field")
    func withSlant_changesOnlySlant() {
        let base = RDSTextSpec(
            designFontSizePx: 14,
            pointSizeOverride: nil,
            weight: .medium,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: 20,
            letterSpacingPercent: 2.0,
            preferredFamily: .system
        )
        let it = base.with(slant: .italic)

        #expect(it.slant == .italic)
        #expect(it.weight == base.weight)
        #expect(it.designFontSizePx == base.designFontSizePx)
        #expect(it.letterSpacingPercent == base.letterSpacingPercent)
        #expect(it.preferredFamily == base.preferredFamily)
    }

    @Test("with(weightNumber:) maps out-of-range numbers to the closest bucket")
    func withWeightNumber_outOfTableFallsBack() {
        let base = RDSTextSpec(
            designFontSizePx: 16,
            pointSizeOverride: nil,
            weight: .regular,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: nil,
            letterSpacingPercent: 0.0,
            preferredFamily: nil
        )
        // Common buckets: 100 → light, 400 → regular, 500 → medium, 700 → bold, 900 → black.
        #expect(base.with(weightNumber: 100).weight == .light)
        #expect(base.with(weightNumber: 400).weight == .regular)
        #expect(base.with(weightNumber: 500).weight == .medium)
        #expect(base.with(weightNumber: 700).weight == .bold)
        // Large values should clamp to the heaviest bucket (black).
        #expect(base.with(weightNumber: 1000).weight == .black)
    }

    // MARK: - Tokens bridge

    @Test("Token access returns a consistent spec (sanity check)")
    func tokenAccess_consistentSpec() {
        let body = RDSTextStyleToken.body.spec
        let base = body.basePointSize(usingScale: 1.0)

        #expect(base > 0)
        #expect(body.relativeTo == .body)
        // If present, multiple must be positive.
        if let m = body.lineHeightMultiple() {
            #expect(m > 0)
        }
    }
}
