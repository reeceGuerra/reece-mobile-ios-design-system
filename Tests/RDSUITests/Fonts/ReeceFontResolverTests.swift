//
//  ReeceFontResolverTests.swift
//  ReeceDesignSystem
//
//  Created by ChatGPT on 03/09/25.
//

import XCTest
import SwiftUI
@testable import RDSUI

final class ReeceFontResolverTests: XCTestCase {

    func testSwiftUIWeightMapping() {
        XCTAssertEqual(swiftUIWeight(from: .light), .light)
        XCTAssertEqual(swiftUIWeight(from: .regular), .regular)
        XCTAssertEqual(swiftUIWeight(from: .medium), .medium)
        XCTAssertEqual(swiftUIWeight(from: .bold), .bold)
        XCTAssertEqual(swiftUIWeight(from: .black), .black)
    }

    func testSystemFamilyFlagsItalicWhenRequested() {
        let spec = ReeceTextSpec(designFontSizePx: 16, weight: .regular, slant: .italic, relativeTo: .body, designLineHeightPx: 24, letterSpacingPercent: 0.0)
        let baseSize = spec.basePointSize(usingScale: 1.0)

        let resolved = ReeceFontResolver.resolve(for: spec, family: .system, basePointSize: baseSize)
        XCTAssertTrue(resolved.needsViewItalic, "System fonts rely on view-level italic when slanted")
    }

    func testCustomFamilyUsesItalicAssetWhenAvailable() {
        // Roboto Regular Italic exists in the table → needsViewItalic should be false
        let spec = ReeceTextSpec(designFontSizePx: 16, weight: .regular, slant: .italic, relativeTo: .body, designLineHeightPx: 24, letterSpacingPercent: 0.0)
        let baseSize = spec.basePointSize(usingScale: 1.0)

        let resolved = ReeceFontResolver.resolve(for: spec, family: .roboto, basePointSize: baseSize)
        XCTAssertFalse(resolved.needsViewItalic, "Roboto has real italic faces; view-level italic not needed")
    }
}