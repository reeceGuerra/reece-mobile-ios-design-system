//
//  RDSFontRegisterTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 03/09/25.
//

import Testing
import SwiftUI
import CoreText
import CoreGraphics
@testable import RDSUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

@Suite("RDSFontRegister")
struct RDSFontRegisterTests {

    /// Families that are actually packaged in the SPM resources for this project.
    /// (OpenSans may be mapped but not packaged; we limit assertions to installed ones.)
    private let packagedFamilies: [RDSFontFamily] = [.roboto, .helveticaNeueLTPro]

    @MainActor
    @Test("registerAll returns a positive number on first run")
    func registerAll_returnsPositive() async {
        let registered = RDSFontRegister.registerAllFonts()
        #expect(registered > 0, "Expected at least one font file to be registered")
    }

    @MainActor
    @Test("Registered custom families are creatable via UIFont/NSFont using PostScript names")
    func registeredFamiliesAreCreatable() async {
        // Ensure registration has happened
        _ = RDSFontRegister.registerAllFonts()

        // For each packaged family, verify upright and italic names can resolve to fonts.
        for family in packagedFamilies {
            // regular + normal
            let upright = RDSFontResolver.postScriptName(family: family, weight: .regular, slant: .normal)
            #expect(!upright.name.isEmpty, "Upright PS name should not be empty for \(family)")
            #expect(upright.hasItalicFace == false)

            // regular + italic
            let italic = RDSFontResolver.postScriptName(family: family, weight: .regular, slant: .italic)
            #expect(!italic.name.isEmpty, "Italic PS name should not be empty for \(family)")
            #expect(italic.hasItalicFace == true)

            #if canImport(UIKit)
            let u1 = UIFont(name: upright.name, size: 12)
            let u2 = UIFont(name: italic.name, size: 12)
            #expect(u1 != nil, "UIFont should resolve \(upright.name)")
            #expect(u2 != nil, "UIFont should resolve \(italic.name)")
            #elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
            let n1 = NSFont(name: upright.name, size: 12)
            let n2 = NSFont(name: italic.name, size: 12)
            #expect(n1 != nil, "NSFont should resolve \(upright.name)")
            #expect(n2 != nil, "NSFont should resolve \(italic.name)")
            #else
            // Platforms without UIKit/AppKit: nothing to assert beyond registration path.
            #expect(true)
            #endif
        }
    }

    @MainActor
    @Test("registerAll is idempotent (subsequent calls do not crash)")
    func registerAll_isIdempotent() async {
        _ = RDSFontRegister.registerAllFonts()
        let second = RDSFontRegister.registerAllFonts()
        // Some platforms may report 0 on re-register; others may re-count. We just assert non-negative.
        #expect(second >= 0)
    }
}
