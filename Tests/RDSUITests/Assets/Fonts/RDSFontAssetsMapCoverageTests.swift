//
//  RDSFontAssetsMapCoverageTests.swift
//  RDSDesignSystem
//
//  Created by ChatGPT on 03/09/25.
//

import Testing
import SwiftUI
@testable import RDSUI

@Suite("RDSFonts assets map coverage")
struct RDSFontAssetsMapCoverageTests {

    // Families backed by the table-driven assets map (exclude .system).
    private let families: [RDSFontFamily] = [.helveticaNeueLTPro, .openSans, .roboto]

    @Test("postScriptName returns non-empty names and correct italic flag for upright/italic")
    func postScriptName_upright_vs_italic() {
        for family in families {
            for weight in RDSFontWeight.allCases {
                // Upright
                let upright = RDSFontResolver.postScriptName(family: family, weight: weight, slant: .normal)
                #expect(upright.name.isEmpty == false, "Upright PS name should not be empty for \(family) \(weight)")
                #expect(upright.hasItalicFace == false, "Upright should not mark italic for \(family) \(weight)")

                // Italic
                let italic = RDSFontResolver.postScriptName(family: family, weight: weight, slant: .italic)
                #expect(italic.name.isEmpty == false, "Italic PS name should not be empty for \(family) \(weight)")
                #expect(italic.hasItalicFace == true, "Italic face should be available for \(family) \(weight)")
            }
        }
    }

    @MainActor
    @Test("Resolver does not require view-level italic when italic asset exists (custom families)")
    func resolver_noViewItalic_whenRealItalicExists() async {
        // Use a basic spec that requests italic so we can observe the resolver flag.
        let baseSpec = RDSTextSpec(
            designFontSizePx: 16,
            pointSizeOverride: nil,
            weight: .regular,
            slant: .italic,
            relativeTo: .body,
            designLineHeightPx: 24,
            letterSpacingPercent: 0.0,
            preferredFamily: nil
        )
        let basePt = baseSpec.basePointSize(usingScale: 1.0)

        for family in families {
            for weight in RDSFontWeight.allCases {
                // Override weight for the iteration
                let spec = baseSpec.with(weightNumber: {
                    switch weight {
                    case .light:   return 300
                    case .regular: return 400
                    case .medium:  return 500
                    case .bold:    return 700
                    case .black:   return 900
                    }
                }())

                let resolved = RDSFontResolver.resolve(for: spec, family: family, basePointSize: basePt)
                #expect(resolved.needsViewItalic == false, "Custom \(family) \(weight) should not rely on view-level italic")
            }
        }
    }
}
