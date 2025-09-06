//
//  RDSFontExistsOverrideTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 03/09/25.
//

import Testing
import SwiftUI
@testable import RDSUI

@Suite("RDSFonts FS override behavior")
struct RDSFontExistsOverrideTests {

    @MainActor
    @Test("Custom families ignore FS override for italic faces")
    func customFamilyIgnoresFSOverride() async {
        // Even if we simulate missing files, custom families should not require view-level italic
        _FontFSProbe.existsOverride = { _ in false }
        defer { _FontFSProbe.existsOverride = nil }

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
        let resolved = RDSFontResolver.resolve(for: spec, family: .roboto, basePointSize: base)

        // With assets-table based resolution, italic face is known and no view-level italic is required.
        #expect(resolved.needsViewItalic == false)
    }

    @MainActor
    @Test("System family relies on view-level italic regardless of FS override")
    func systemFamilyRequiresViewItalic() async {
        // Simulate files existing; system fonts still rely on view-level italic
        _FontFSProbe.existsOverride = { _ in true }
        defer { _FontFSProbe.existsOverride = nil }

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
}
