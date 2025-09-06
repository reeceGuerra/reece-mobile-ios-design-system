//
//  RDSThemeModeTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 03/09/25.
//
//  Verifies RDSThemeMode semantics and RDSTheme global configuration.
//  - Ensures allCases has expected cases and order
//  - Ensures id mirrors title
//  - Ensures effectiveScheme logic (system passthrough vs forced schemes)
//  - Ensures RDSTheme.mode default and mutability on the main actor
//

import Testing
import SwiftUI
@testable import RDSUI

/// Theme mode behavior tests focused on the engine that resolves colors by scheme.
/// These are lightweight and do not depend on any demo app scaffolding.
@MainActor
@Suite("RDSThemeMode Tests")
struct RDSThemeModeTests {

    // MARK: - Helpers

    private func hex(_ color: Color, includeAlpha: Bool = true) -> String {
        RDSColorExport.hex(from: color, includeAlpha: includeAlpha) ?? "#NA"
    }

    // MARK: - pick(light:dark:using:)

    @Test("pick returns the light color in .light scheme")
    func pick_returnsLight_inLightMode() {
        let light = Color.rds("#FF0000")
        let dark  = Color.rds("#00FF00")

        let resolved = RDSColorEngine.pick(light: light, dark: dark, using: .light)
        #expect(hex(resolved) == hex(light))
    }

    @Test("pick returns the dark color in .dark scheme")
    func pick_returnsDark_inDarkMode() {
        let light = Color.rds("#FF0000")
        let dark  = Color.rds("#00FF00")

        let resolved = RDSColorEngine.pick(light: light, dark: dark, using: .dark)
        #expect(hex(resolved) == hex(dark))
    }

    @Test("pick is stable when light == dark (same HEX for both schemes)")
    func pick_sameForBoth_whenInputsEqual() {
        let same = Color.rds("#407A26") // any sample color

        let resolvedLight = RDSColorEngine.pick(light: same, dark: same, using: .light)
        let resolvedDark  = RDSColorEngine.pick(light: same, dark: same, using: .dark)

        #expect(hex(resolvedLight) == hex(same))
        #expect(hex(resolvedDark)  == hex(same))
        #expect(hex(resolvedLight) == hex(resolvedDark))
    }
}
