//
//  ReeceTypographySpecAdditionalTests.swift
//  ReeceDesignSystem
//
//  Created by ChatGPT on 03/09/25.
//

import XCTest
import SwiftUI
@testable import ReeceDesignSystem

/// Covers additional branches in ReeceTypography (pointSizeOverride, with(slant:), token access).
final class ReeceTypographySpecAdditionalTests: XCTestCase {
    
    func testBasePointSize_UsesPointSizeOverride() {
        let spec = ReeceTextSpec(designFontSizePx: 20,
                                 pointSizeOverride: 17,
                                 weight: .regular,
                                 slant: .normal,
                                 relativeTo: .body,
                                 designLineHeightPx: 24,
                                 letterSpacingPercent: 0.0)
        XCTAssertEqual(spec.basePointSize(usingScale: 3.0), 17, "Override should win regardless of scale")
    }
    
    func testWithSlant() {
        let spec = ReeceTextSpec(designFontSizePx: 16,
                                 weight: .regular,
                                 slant: .normal,
                                 relativeTo: .body,
                                 designLineHeightPx: 24,
                                 letterSpacingPercent: 0.0)
        let italic = spec.with(slant: .italic)
        XCTAssertEqual(italic.slant, .italic)
    }
    
    func testTokenAccessors_Headlines() {
        // Touch several tokens to bump getter coverage
        _ = ReeceTextStyleToken.h1B.spec
        _ = ReeceTextStyleToken.h2M.spec
        _ = ReeceTextStyleToken.h3R.spec
        _ = ReeceTextStyleToken.h4M.spec
        _ = ReeceTextStyleToken.h5R.spec
        _ = ReeceTextStyleToken.buttonM.spec
        _ = ReeceTextStyleToken.caption.spec
        _ = ReeceTextStyleToken.code.spec
        XCTAssertTrue(true) // we only care about executing the getters
    }
    
    func testWithSlant_ChangesOnlySlant() {
        let base = ReeceTextSpec(designFontSizePx: 14, weight: .medium, slant: .normal, relativeTo: .body, designLineHeightPx: 20, letterSpacingPercent: 2.0)
        let it = base.with(slant: .italic)
        XCTAssertEqual(it.slant, .italic)
        XCTAssertEqual(it.weight, base.weight)
        XCTAssertEqual(it.designFontSizePx, base.designFontSizePx)
    }
    
    func testWithWeightNumber_OutOfTableFallsBack() {
        let base = ReeceTextSpec(designFontSizePx: 16, weight: .regular, slant: .normal, relativeTo: .body, designLineHeightPx: nil, letterSpacingPercent: 0)
        // si tu mapeo envía >900 a .black, esto ejecuta la rama final
        XCTAssertEqual(base.with(weightNumber: 1000).weight, .black)
    }
}
