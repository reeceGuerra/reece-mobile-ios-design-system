//
//  RDSTypographySpecTests.swift
//  RDSDesignSystem
//
//  Created by ChatGPT on 03/09/25.
//

import XCTest
import SwiftUI
@testable import RDSUI

final class RDSTypographySpecTests: XCTestCase {

    func testBasePointSize_UsesDesignScale() {
        // Given a known token with 25px font size (h4*)
        let spec = RDSTextStyleToken.h4B.spec
        // When scale is 1.0, px == pt
        let pt1 = spec.basePointSize(usingScale: 1.0)
        // When scale is 2.0, pt halves
        let pt2 = spec.basePointSize(usingScale: 2.0)

        XCTAssertEqual(pt1, 25, accuracy: 0.001, "Expected 25pt for scale 1.0")
        XCTAssertEqual(pt2, 12.5, accuracy: 0.001, "Expected 12.5pt for scale 2.0")
    }

    func testLineHeightMultiple_h4() {
        // h4*: 25px font / 30px lineHeight ⇒ 1.2x
        let spec = RDSTextStyleToken.h4M.spec
        let multiple = spec.lineHeightMultiple()
        XCTAssertNotNil(multiple)
        XCTAssertEqual(multiple!, 30.0/25.0, accuracy: 0.0001)
    }

    func testLineHeightMultiple_buttons() {
        // buttonM: 16px / 24px ⇒ 1.5
        let m = Double(RDSTextStyleToken.buttonM.spec.lineHeightMultiple()!)
        XCTAssertEqual(m, 24.0/16.0, accuracy: 0.0001)

        // buttonS: 14px / 22px ⇒ 1.5714...
        let s = Double(RDSTextStyleToken.buttonS.spec.lineHeightMultiple()!)
        XCTAssertEqual(s, 22.0/14.0, accuracy: 0.0001)
    }

    func testWithWeightNumberMapping() {
        let base = RDSTextSpec(designFontSizePx: 16, weight: .regular, slant: .normal, relativeTo: .body, designLineHeightPx: 24, letterSpacingPercent: 0.0)

        XCTAssertEqual(base.with(weightNumber: 100).weight, .light)
        XCTAssertEqual(base.with(weightNumber: 300).weight, .light)
        XCTAssertEqual(base.with(weightNumber: 400).weight, .regular)
        XCTAssertEqual(base.with(weightNumber: 500).weight, .medium)
        XCTAssertEqual(base.with(weightNumber: 600).weight, .bold)
        XCTAssertEqual(base.with(weightNumber: 700).weight, .bold)
        XCTAssertEqual(base.with(weightNumber: 900).weight, .black)
    }
}
