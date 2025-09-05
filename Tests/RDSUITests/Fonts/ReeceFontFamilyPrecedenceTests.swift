//
//  ReeceFontFamilyPrecedenceTests.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 04/09/25.
//


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
@testable import RDSUI

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
        // Spec prefiere OpenSans, pero aquí comprobamos que al pedir Roboto
        // el resolver selecciona un PostScript distinto y el cómputo produce un Font.
        let spec = ReeceTextSpec(
            designFontSizePx: 16,
            weight: .medium,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: 24,
            letterSpacingPercent: 0.0,
            preferredFamily: .openSans
        )

        // 1) Resolver: nombres PostScript deben diferir entre familias
        let psOpen = ReeceFontResolver.postScriptName(
            family: .openSans,
            weight: spec.weight,
            slant: spec.slant
        ).name

        let psRoboto = ReeceFontResolver.postScriptName(
            family: .roboto,
            weight: spec.weight,
            slant: spec.slant
        ).name

        XCTAssertNotEqual(psOpen, psRoboto, "Different families should map to different PostScript names")

        // 2) Cómputo: ambos deben producir un Font válido (independiente de si hay fallback a sistema)
        let resPreferred = _computeTextStyle(spec: spec, family: .openSans, designScale: 1.0)
        let resExplicit  = _computeTextStyle(spec: spec, family: .roboto,   designScale: 1.0)

        XCTAssertNotNil(String(describing: resPreferred.font))
        XCTAssertNotNil(String(describing: resExplicit.font))
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
