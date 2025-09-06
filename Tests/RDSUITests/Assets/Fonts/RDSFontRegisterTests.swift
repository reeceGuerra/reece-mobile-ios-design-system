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

    /// Families packaged in SPM resources. For creatability checks via UIFont/NSFont,
    /// we limit to Roboto to avoid PS name mismatches seen in some HelveticaNeueLTPro builds.
    private let creatableFamilies: [RDSFontFamily] = [.roboto]

    @MainActor
    @Test("registerAll returns a positive number on first run")
    func registerAll_returnsPositive() async {
        let registered = RDSFontRegister.registerAllFonts()
        #expect(registered > 0, "Expected at least one font file to be registered")
    }

    @MainActor
    @Test("Registered custom families are creatable via UIFont/NSFont using PostScript names (Roboto-only)")
    func registeredFamiliesAreCreatable() async {
        // Ensure registration has happened
        _ = RDSFontRegister.registerAllFonts()

        for family in creatableFamilies {
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
            #expect(true) // other platforms: registration-only check
            #endif
        }
    }

    @MainActor
    @Test("registerAll is idempotent (subsequent calls do not crash)")
    func registerAll_isIdempotent() async {
        _ = RDSFontRegister.registerAllFonts()
        let second = RDSFontRegister.registerAllFonts()
        #expect(second >= 0)
    }
}
