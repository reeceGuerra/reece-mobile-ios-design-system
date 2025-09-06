//
//  RDSFontResolverTests.swift
//  RDSDesignSystem
//
//  Created by ChatGPT on 03/09/25.
//

import Testing
import SwiftUI
@testable import RDSUI

@Suite("RDSFontResolver")
struct RDSFontResolverTests {

    @Test("Maps RDSFontWeight to SwiftUI Font.Weight")
    func swiftUIWeightMapping() {
        #expect(swiftUIWeight(from: .light)   == .light)
        #expect(swiftUIWeight(from: .regular) == .regular)
        #expect(swiftUIWeight(from: .medium)  == .medium)
        #expect(swiftUIWeight(from: .bold)    == .bold)
        #expect(swiftUIWeight(from: .black)   == .black)
    }

    @MainActor
    @Test("System family uses view-level italic fallback")
    func systemItalicUsesViewFallback() async {
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
        let baseSize = spec.basePointSize(usingScale: 1.0)

        let resolved = RDSFontResolver.resolve(for: spec, family: .system, basePointSize: baseSize)
        #expect(resolved.needsViewItalic == true, "System fonts rely on view-level italic when slanted")
    }

    @MainActor
    @Test("Custom family uses real italic asset when available")
    func customFamilyUsesItalicAssetWhenAvailable() async {
        // Roboto has real italic faces in the asset map
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
        let baseSize = spec.basePointSize(usingScale: 1.0)

        let resolved = RDSFontResolver.resolve(for: spec, family: .roboto, basePointSize: baseSize)
        #expect(resolved.needsViewItalic == false, "Roboto provides italic faces; view-level italic should not be needed")
    }

    @Test("postScriptName resolves family/weight/slant and marks italic presence")
    func postScriptNameResolvesItalic() {
        // Regular + italic should map to a concrete italic PS name for Roboto
        let result = RDSFontResolver.postScriptName(family: .roboto, weight: .regular, slant: .italic)
        #expect(result.name.isEmpty == false)
        #expect(result.hasItalicFace == true)

        // Regular + normal slant should not mark italic
        let normal = RDSFontResolver.postScriptName(family: .roboto, weight: .regular, slant: .normal)
        #expect(normal.hasItalicFace == false || normal.name != result.name)
    }
}
