//
//  ReeceFontAssetsMapCoverageTests.swift
//  ReeceDesignSystem
//
//  Created by ChatGPT on 03/09/25.
//

import XCTest
import SwiftUI
@testable import ReeceDesignSystem

/// Expands coverage of assetsMap and fontName by hitting multiple families/weights/slants.
final class ReeceFontAssetsMapCoverageTests: XCTestCase {

    private func resolve(_ family: ReeceFontFamily,
                         weight: ReeceFontWeight,
                         slant: ReeceFontSlant) -> ReeceResolvedFont {
        let spec = ReeceTextSpec(designFontSizePx: 16,
                                 weight: weight,
                                 slant: slant,
                                 relativeTo: .body,
                                 designLineHeightPx: 24,
                                 letterSpacingPercent: 0.0)
        let pts = spec.basePointSize(usingScale: 1.0)
        return ReeceFontResolver.resolve(for: spec, family: family, basePointSize: pts)
    }

    func testHelveticaNeueLTPro_NormalAndItalic() {
        let normal = resolve(.helveticaNeueLTPro, weight: .medium, slant: .normal)
        XCTAssertFalse(normal.needsViewItalic)

        let italic = resolve(.helveticaNeueLTPro, weight: .medium, slant: .italic)
        // When the mapping contains an italic face, resolver should not require view-level italic.
        XCTAssertFalse(italic.needsViewItalic)
    }

    func testOpenSans_NormalAndItalic() {
        let normal = resolve(.openSans, weight: .bold, slant: .normal)
        XCTAssertFalse(normal.needsViewItalic)

        let italic = resolve(.openSans, weight: .bold, slant: .italic)
        XCTAssertFalse(italic.needsViewItalic)
    }

    func testRoboto_NormalAndItalic_AllWeights() {
        for w in ReeceFontWeight.allCases {
            let normal = resolve(.roboto, weight: w, slant: .normal)
            XCTAssertFalse(normal.needsViewItalic, "Upright should not require view italic for \(w)")

            let italic = resolve(.roboto, weight: w, slant: .italic)
            // With the table-driven approach, italic faces are available → view italic not needed.
            XCTAssertFalse(italic.needsViewItalic, "Italic should use real face for \(w)")
        }
    }
}
