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
import Testing
import SwiftUI
@testable import RDSUI

@Suite("RDSFonts Missing Assets")
struct RDSFontsMissingAssetTests {

    @MainActor
    @Test("System family with italic slant requires view-level italic")
    func systemItalicRequiresViewItalic() async {
        let spec = RDSTextSpec(
            designFontSizePx: 16,
            pointSizeOverride: nil,
            weight: .regular,
            slant: .italic,
            relativeTo: .body,
            designLineHeightPx: 24,
            letterSpacingPercent: 0.0,
            preferredFamily: nil
        )
        let base = spec.basePointSize(usingScale: 1.0)
        let resolved = RDSFontResolver.resolve(for: spec, family: .system, basePointSize: base)

        #expect(resolved.needsViewItalic == true)
    }

    @MainActor
    @Test("System family with normal slant does not require view-level italic")
    func systemNormalDoesNotRequireItalic() async {
        let spec = RDSTextSpec(
            designFontSizePx: 16,
            pointSizeOverride: nil,
            weight: .regular,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: 24,
            letterSpacingPercent: 0.0,
            preferredFamily: nil
        )
        let base = spec.basePointSize(usingScale: 1.0)
        let resolved = RDSFontResolver.resolve(for: spec, family: .system, basePointSize: base)

        #expect(resolved.needsViewItalic == false)
    }
}
