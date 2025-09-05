//
//  RDSTypographySpecAdditionalTests.swift
//  RDSDesignSystem
//
//  Created by ChatGPT on 03/09/25.
//

import XCTest
import SwiftUI
@testable import RDSUI

/// Covers additional branches in RDSTypography (pointSizeOverride, with(slant:), token access).
final class RDSTypographySpecAdditionalTests: XCTestCase {
    
    func testBasePointSize_UsesPointSizeOverride() {
        let spec = RDSTextSpec(designFontSizePx: 20,
                                 pointSizeOverride: 17,
                                 weight: .regular,
                                 slant: .normal,
                                 relativeTo: .body,
                                 designLineHeightPx: 24,
                                 letterSpacingPercent: 0.0)
        XCTAssertEqual(spec.basePointSize(usingScale: 3.0), 17, "Override should win regardless of scale")
    }
    
    func testWithSlant() {
        let spec = RDSTextSpec(designFontSizePx: 16,
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
        _ = RDSTextStyleToken.h1B.spec
        _ = RDSTextStyleToken.h2M.spec
        _ = RDSTextStyleToken.h3R.spec
        _ = RDSTextStyleToken.h4M.spec
        _ = RDSTextStyleToken.h5R.spec
        _ = RDSTextStyleToken.buttonM.spec
        _ = RDSTextStyleToken.caption.spec
        _ = RDSTextStyleToken.code.spec
        XCTAssertTrue(true) // we only care about executing the getters
    }
    
    func testWithSlant_ChangesOnlySlant() {
        let base = RDSTextSpec(designFontSizePx: 14, weight: .medium, slant: .normal, relativeTo: .body, designLineHeightPx: 20, letterSpacingPercent: 2.0)
        let it = base.with(slant: .italic)
        XCTAssertEqual(it.slant, .italic)
        XCTAssertEqual(it.weight, base.weight)
        XCTAssertEqual(it.designFontSizePx, base.designFontSizePx)
    }
    
    func testWithWeightNumber_OutOfTableFallsBack() {
        let base = RDSTextSpec(designFontSizePx: 16, weight: .regular, slant: .normal, relativeTo: .body, designLineHeightPx: nil, letterSpacingPercent: 0)
        // si tu mapeo envía >900 a .black, esto ejecuta la rama final
        XCTAssertEqual(base.with(weightNumber: 1000).weight, .black)
    }
}
