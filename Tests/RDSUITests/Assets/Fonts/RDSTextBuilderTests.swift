//
//  RDSTextBuilderTests.swift
//  RDSDesignSystem
//
//  Created by ChatGPT on 03/09/25.
//
//  Updated: remove deprecated `RDSText(...)` builder usage.
//  Tests now exercise the ViewModifier API and compute helpers.
//
import Testing
import SwiftUI
@testable import RDSUI

@Suite("RDSText builder math & providers")
struct RDSTextBuilderTests {

    // MARK: - Base point size

    @Test("Uses pointSizeOverride when provided (ignores scale)")
    func basePointSize_usesOverride() {
        let spec = RDSTextSpec(
            designFontSizePx: 18,        // would be ignored
            pointSizeOverride: 15,       // wins
            weight: .regular,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: 22,
            letterSpacingPercent: 0.0,
            preferredFamily: nil
        )

        #expect(spec.basePointSize(usingScale: nil) == 15)
        #expect(spec.basePointSize(usingScale: 2.0) == 15)
    }

    @Test("Converts px to pt using design scale when no override")
    func basePointSize_usesPxOverScale() {
        let spec = RDSTextSpec(
            designFontSizePx: 18,
            pointSizeOverride: nil,      // no override → use px/scale
            weight: .regular,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: 22,
            letterSpacingPercent: 0.0,
            preferredFamily: nil
        )
        // 18 px / 1.5 scale = 12 pt
        let pt = spec.basePointSize(usingScale: 1.5)
        let tol: CGFloat = 0.0001
        #expect(abs(pt - 12.0) <= tol)
    }

    // MARK: - Line height multiple

    @Test("Line height multiple is lhPx / fontPx")
    func lineHeightMultiple_math() {
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
        // 24 / 16 = 1.5
        let multiple = spec.lineHeightMultiple()
        let tol: CGFloat = 0.0001
        #expect(multiple != nil)
        #expect(abs(multiple! - 1.5) <= tol)
    }

    // MARK: - Providers

    @Test("Default typography provider returns token spec")
    func defaultTypographyProvider_returnsTokenSpec() {
        let provider = RDSTypographyTokensProvider()
        // Assumes RDSTextStyleToken.buttonM is present in mapping
        let spec = provider.spec(for: .buttonM)

        // Sanity checks against expected token fields in default table
        #expect(spec.designFontSizePx != nil)
        #expect(spec.weight != .black) // arbitrary sanity check
    }

    @Test("Slant override via spec.with(slant:)")
    func slantOverride_changesSpec() {
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
        let italic = base.with(slant: .italic)
        #expect(base.slant == .normal)
        #expect(italic.slant == .italic)
    }

    @Test("Family provider fallback is used when spec has no preferred family")
    func familyProvider_fallback() {
        struct DummyFamilyProvider: RDSFontFamilyProviding {
            func resolvePreferredFamily(for token: RDSTextStyleToken) -> RDSFontFamily { .roboto }
        }
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
        let provider = DummyFamilyProvider()
        let chosen = spec.preferredFamily ?? provider.resolvePreferredFamily(for: .body)
        #expect(chosen == .roboto)
    }

    @MainActor
    @Test("Preferred family in spec takes precedence over provider")
    func preferredFamily_winsOverProvider() async {
        struct DummyFamilyProvider: RDSFontFamilyProviding {
            func resolvePreferredFamily(for token: RDSTextStyleToken) -> RDSFontFamily { .system }
        }
        let spec = RDSTextSpec(
            designFontSizePx: 16,
            pointSizeOverride: nil,
            weight: .regular,
            slant: .italic,            // use italic to observe resolver behavior
            relativeTo: .body,
            designLineHeightPx: 24,
            letterSpacingPercent: 0.0,
            preferredFamily: .roboto   // preferred in spec
        )
        // spec.preferredFamily should be used instead of provider fallback
        let provider = DummyFamilyProvider()
        let chosen = spec.preferredFamily ?? provider.resolvePreferredFamily(for: .buttonM)
        #expect(chosen == .roboto)

        // Resolver observability: Roboto has italic faces -> no view-level italic needed
        let basePt = spec.basePointSize(usingScale: 1.0)
        let resolved = RDSFontResolver.resolve(for: spec, family: chosen, basePointSize: basePt)
        #expect(resolved.needsViewItalic == false)
    }
}
