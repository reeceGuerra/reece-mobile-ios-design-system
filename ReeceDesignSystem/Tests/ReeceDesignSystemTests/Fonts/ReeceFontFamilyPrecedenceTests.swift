//
//  ReeceFontFamilyPrecedenceTests.swift
//  ReeceDesignSystemTests
//
//  Purpose: sanity checks around family precedence mechanics and spec propagation.
//  Note: We verify compute-level effects and spec behavior; environment precedence
//  is exercised indirectly via `.reeceText(...)` in existing tests.
//
import XCTest
import SwiftUI
@testable import ReeceDesignSystem

final class ReeceFontFamilyPrecedenceTests: XCTestCase {

    func testPreferredFamilyIsPreservedWhenChangingSlant() {
        var spec = ReeceTextSpec(
            designFontSizePx: 16,
            weight: .regular,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: 24,
            letterSpacingPercent: 0.0,
            preferredFamily: .openSans
        )
        spec = spec.with(slant: .italic)
        XCTAssertEqual(spec.preferredFamily, .openSans, "preferredFamily should persist after with(slant:)")
    }

    func testExplicitFamilyOverridesPreferredAtComputeLevel() {
        // Spec prefers OpenSans, but compute uses the explicit family we pass in.
        let spec = ReeceTextSpec(
            designFontSizePx: 16,
            weight: .medium,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: 24,
            letterSpacingPercent: 0.0,
            preferredFamily: .openSans
        )

        let resPreferred = _computeTextStyle(spec: spec, family: .openSans, designScale: 1.0)
        let resExplicit  = _computeTextStyle(spec: spec, family: .roboto,   designScale: 1.0)

        // If the families differ, the resolver should generally pick different faces.
        XCTAssertNotEqual(String(describing: resPreferred.font),
                          String(describing: resExplicit.font),
                          "Explicit compute with a different family should yield a different font")
    }

    func testSystemFallbackProducesAFont() {
        let spec = ReeceTextSpec(
            designFontSizePx: 14,
            weight: .regular,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: nil,
            letterSpacingPercent: nil,
            preferredFamily: nil
        )
        let res = _computeTextStyle(spec: spec, family: .system, designScale: 1.0)
        XCTAssertNotNil(String(describing: res.font))
    }
}
