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

    private let creatableFamilies: [RDSFontFamily] = [.roboto]

    @MainActor
    @Test("registerAll returns a non-negative number or fonts are already available")
    func registerAll_returnsPositiveOrAvailable() async {
        let registered = RDSFontRegister.registerAllFonts()
        #expect(registered >= 0, "Registration should not be negative")

        // If CoreText reported 0, verify at least Roboto is actually creatable (already available).
        if registered == 0 {
            let upright = RDSFontResolver.postScriptName(family: .roboto, weight: .regular, slant: .normal).name
            #if canImport(UIKit)
            let ok = UIFont(name: upright, size: 12) != nil
            #expect(ok, "Expected Roboto to be available even if registration returned 0 (\(upright))")
            #elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
            let ok = NSFont(name: upright, size: 12) != nil
            #expect(ok, "Expected Roboto to be available even if registration returned 0 (\(upright))")
            #else
            #expect(true) // other platforms: nothing else to assert
            #endif
        }
    }

    @MainActor
    @Test("Registered custom families are creatable via UIFont/NSFont using PostScript names (Roboto-only)")
    func registeredFamiliesAreCreatable() async {
        _ = RDSFontRegister.registerAllFonts()

        for family in creatableFamilies {
            let upright = RDSFontResolver.postScriptName(family: family, weight: .regular, slant: .normal)
            let italic  = RDSFontResolver.postScriptName(family: family, weight: .regular, slant: .italic)

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
            #expect(true)
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
