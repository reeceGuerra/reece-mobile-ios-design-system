//
//  ReeceFontExistsOverrideTests.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 03/09/25.
//


import XCTest
import SwiftUI
@testable import RDSUI

final class ReeceFontExistsOverrideTests: XCTestCase {
    override func tearDown() {
        _FontFSProbe.existsOverride = nil
    }

    func testItalicExists_UsesRealItalic_NoViewItalic() {
        _FontFSProbe.existsOverride = { _ in true }
        let spec = ReeceTextSpec(designFontSizePx: 16, weight: .regular, slant: .italic, relativeTo: .body, designLineHeightPx: 24, letterSpacingPercent: 0)
        let r = ReeceFontResolver.resolve(for: spec, family: .roboto, basePointSize: spec.basePointSize(usingScale: 1.0))
        XCTAssertFalse(r.needsViewItalic)
    }

    func testItalicMissing_FallsBackToViewItalic_WhenSystem() {
        _FontFSProbe.existsOverride = { _ in false }
        let spec = ReeceTextSpec(designFontSizePx: 16, weight: .regular, slant: .italic, relativeTo: .body, designLineHeightPx: 24, letterSpacingPercent: 0)
        let r = ReeceFontResolver.resolve(for: spec, family: .system, basePointSize: spec.basePointSize(usingScale: 1.0))
        XCTAssertTrue(r.needsViewItalic)
    }
}
