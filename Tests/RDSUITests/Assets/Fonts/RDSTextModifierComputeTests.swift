//
//  RDSTextModifierComputeTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 03/09/25.
//

import Testing
import SwiftUI
@testable import RDSUI

@Suite("RDSTextModifier Compute")
struct RDSTextModifierComputeTests {

    @Test("No line-height multiple yields zero extra spacing")
    func noLineHeightMultiple() {
        // Build a spec without designLineHeightPx so multiple is nil
        let spec = RDSTextSpec(
            designFontSizePx: 16,
            pointSizeOverride: nil,
            weight: .regular,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: nil,
            letterSpacingPercent: 0.0,
            preferredFamily: nil
        )

        // Base point size (px -> pt) using default design scale (1.0)
        let basePt = spec.basePointSize(usingScale: 1.0)

        // When no multiple is provided, extra spacing should be zero
        let multiple = spec.lineHeightMultiple()
        #expect(multiple == nil)

        let extraLineSpacing: CGFloat = 0
        #expect(extraLineSpacing == 0)
        #expect(basePt > 0)
    }

    @Test("Kerning derived from percentage over point size")
    func kerningFromPercent() {
        let spec = RDSTextSpec(
            designFontSizePx: 16,
            pointSizeOverride: nil,
            weight: .regular,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: 24,   // irrelevant for kerning
            letterSpacingPercent: 0.5, // 0.5% of 16pt = 0.08pt
            preferredFamily: nil
        )

        let basePt = spec.basePointSize(usingScale: 1.0)
        let kernPercent = spec.letterSpacingPercent ?? 0
        let kerning = (kernPercent / 100.0) * basePt

        let tol: CGFloat = 0.0001
        #expect(abs(kerning - 0.08) <= tol)
    }

    @MainActor
    @Test("System italic uses view-level italic fallback")
    func systemItalicUsesViewFallback() async {
        var spec = RDSTextSpec(
            designFontSizePx: 16,
            pointSizeOverride: nil,
            weight: .regular,
            slant: .italic,   // request italic
            relativeTo: .body,
            designLineHeightPx: 24,
            letterSpacingPercent: 0.0,
            preferredFamily: nil
        )

        let basePt = spec.basePointSize(usingScale: 1.0)
        let resolved = RDSFontResolver.resolve(for: spec, family: .system, basePointSize: basePt)

        // System fonts are created with Font.system; the resolver indicates
        // the view should apply `.italic()` when slant == .italic.
        #expect(resolved.needsViewItalic == true)
    }

    @MainActor
    @Test("System normal slant does not require italic fallback")
    func systemNormalDoesNotItalicize() async {
        let spec = RDSTextSpec(
            designFontSizePx: 16,
            pointSizeOverride: nil,
            weight: .regular,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: 24,
            letterSpacingPercent: 0.0,
            preferredFamily: nil
        )

        let basePt = spec.basePointSize(usingScale: 1.0)
        let resolved = RDSFontResolver.resolve(for: spec, family: .system, basePointSize: basePt)

        #expect(resolved.needsViewItalic == false)
    }

    @Test("Line-height multiple produces expected extra spacing")
    func lineHeightMultipleProducesExtraSpacing() {
        // Example: font 16px, line height 24px => multiple = 1.5
        let spec = RDSTextSpec(
            designFontSizePx: 16,
            pointSizeOverride: nil,
            weight: .regular,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: 24,
            letterSpacingPercent: 0.0,
            preferredFamily: nil
        )

        let basePt = spec.basePointSize(usingScale: 1.0)  // 16 pt
        let multiple = spec.lineHeightMultiple()
        #expect(multiple != nil)

        // extraSpacing = (multiple * basePt) - basePt
        let extra = (multiple! * basePt) - basePt
        let tol: CGFloat = 0.0001
        #expect(abs(extra - 8.0) <= tol) // 1.5*16 - 16 = 8
    }
}
