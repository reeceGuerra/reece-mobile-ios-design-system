//
//  RDSFontsMissingAssetTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 03/09/25.
//


//
//  RDSFontsMissingAssetTests.swift
//  RDSDesignSystemTests
//
//  Negative-path coverage:
//  - System family has no real italic asset → needsViewItalic should be true.
//  - Normal slant never asks for view italic.
//

import XCTest
import SwiftUI
@testable import RDSUI

final class RDSFontsMissingAssetTests: XCTestCase {

    func test_systemFamily_italic_requests_viewItalic() {
        // Given a spec that requests italic
        let spec = RDSTextSpec(
            designFontSizePx: 16,
            pointSizeOverride: nil,
            weight: .regular,
            slant: .italic,
            relativeTo: .body,
            designLineHeightPx: nil,
            letterSpacingPercent: nil
        )
        // When resolving for .system
        let resolved = RDSFontResolver.resolve(for: spec, family: .system, basePointSize: 16)

        // Then the DS must mark that the SwiftUI view should apply italic at view level.
        XCTAssertTrue(resolved.needsViewItalic, "System family has no italic asset; view-level italic is required.")
    }

    func test_systemFamily_normal_does_not_request_viewItalic() {
        let spec = RDSTextSpec(
            designFontSizePx: 16,
            pointSizeOverride: nil,
            weight: .regular,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: nil,
            letterSpacingPercent: nil
        )
        let resolved = RDSFontResolver.resolve(for: spec, family: .system, basePointSize: 16)
        XCTAssertFalse(resolved.needsViewItalic, "Normal slant should not request view-level italic.")
    }
}
