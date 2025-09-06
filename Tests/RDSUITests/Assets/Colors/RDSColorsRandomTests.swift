//
//  RDSColorsRandomTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 03/09/25.
//

import Testing
import SwiftUI
@testable import RDSUI

/// Tests for the `RDSColors.random(using:)` utility.
/// Ensures opaque output for both schemes and guards against `.clear`.
@MainActor
@Suite("RDSColors Random Tests")
struct RDSColorsRandomTests {

    // MARK: - Helpers

    /// Extract RGBA components in sRGB (0...1). If extraction fails, returns zeros.
    private func rgba(_ color: Color) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        // `RDSColorExport.rgba(from:)` returns an optional tuple of CGFloats.
        let comps = RDSColorExport.rgba(from: color) ?? (r: 0, g: 0, b: 0, a: 0)
        return comps
    }

    /// Rounds a value to the given number of decimal places (useful for stable expectations).
    private func quantize(_ value: CGFloat, places: Int) -> CGFloat {
        let p = pow(10 as CGFloat, CGFloat(places))
        return (value * p).rounded() / p
    }

    /// Convenience to detect `.clear`.
    private func isClear(_ color: Color) -> Bool {
        RDSColorExport.hex(from: color, includeAlpha: true) == "#00000000"
    }

    // MARK: - Tests

    @Test("random() returns an opaque color in Light scheme")
    func test_random_returnsOpaqueColor_inLight() {
        for _ in 0..<60 {
            let c = RDSColors.random(using: .light)
            let comps = rgba(c)
            // Opaque alpha
            #expect(quantize(comps.a, places: 3) == 1.0)
            // Not clear fallback
            #expect(!isClear(c))
        }
    }

    @Test("random() returns an opaque color in Dark scheme")
    func test_random_returnsOpaqueColor_inDark() {
        for _ in 0..<60 {
            let c = RDSColors.random(using: .dark)
            let comps = rgba(c)
            #expect(quantize(comps.a, places: 3) == 1.0)
            #expect(!isClear(c))
        }
    }

    @Test("random() consistently avoids clear across schemes")
    func test_random_isDeterministicallyNonClear_acrossSchemes() {
        for _ in 0..<60 {
            let light = RDSColors.random(using: .light)
            let dark  = RDSColors.random(using: .dark)
            #expect(!isClear(light))
            #expect(!isClear(dark))
        }
    }
}
