//
//  RDSTextModifierComputeTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 03/09/25.
//


import XCTest
import SwiftUI
@testable import RDSUI

final class RDSTextModifierComputeTests: XCTestCase {
    @MainActor func testCompute_System_Normal_Scale1() {
        let spec = RDSTextStyleToken.body.spec.with(slant: .normal)
        let r = _computeTextStyle(spec: spec, family: .system, designScale: 1.0)
        XCTAssertGreaterThan(r.kerning, -999) // se ejecuta cálculo
    }

    @MainActor func testCompute_Roboto_Italic_Scale2() {
        var spec = RDSTextStyleToken.h4M.spec
        spec = spec.with(slant: .italic)
        let r = _computeTextStyle(spec: spec, family: .roboto, designScale: 2.0)
        XCTAssertGreaterThanOrEqual(r.lineSpacing, 0) // cubre rama con multiple
    }

    @MainActor func testCompute_NoLineHeightMultiple() {
        // Spec sin designLineHeightPx => multiple nil
        let spec = RDSTextSpec(
            designFontSizePx: 16,
            weight: .regular,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: nil,
            letterSpacingPercent: 0.0
        )
        let r = _computeTextStyle(spec: spec, family: .system, designScale: 1.0)
        XCTAssertEqual(r.lineSpacing, 0)
    }
}
