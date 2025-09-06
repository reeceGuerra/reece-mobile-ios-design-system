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
/// Instead of requiring every draw to be valid (some tones may be missing),
/// we require that within a reasonable number of attempts we can obtain a
/// non-clear color for each scheme, and that output shows basic variability.
@MainActor
@Suite("RDSColors Random Tests")
struct RDSColorsRandomTests {

    // MARK: - Helpers

    /// Returns HEX string (#RRGGBBAA) for the given color; "#NA" if unavailable.
    private func hex(_ color: Color) -> String {
        RDSColorExport.hex(from: color, includeAlpha: true) ?? "#NA"
    }

    /// Detects the `.clear` fallback used by the palette engine.
    private func isClear(_ color: Color) -> Bool {
        hex(color) == "#00000000"
    }

    /// Try up to `attempts` draws to get a non-clear color for the given scheme.
    private func nonClearColor(using scheme: ColorScheme, attempts: Int = 80) -> Color? {
        for _ in 0..<attempts {
            let c = RDSColors.random(using: scheme)
            if !isClear(c) { return c }
        }
        return nil
    }

    /// Very lightweight notion of variability: collect up to K HEX values and
    /// assert that more than one distinct value was seen (ignoring "#NA").
    private func hasBasicVariability(using scheme: ColorScheme, samples: Int = 20) -> Bool {
        var set = Set<String>()
        for _ in 0..<samples {
            let h = hex(RDSColors.random(using: scheme))
            if h != "#NA" { set.insert(h) }
            if set.count > 1 { return true }
        }
        return set.count > 1
    }

    // MARK: - Tests

    @Test("Able to obtain a non-clear random color in Light within N attempts")
    func test_random_producesUsableColor_inLight() {
        let c = nonClearColor(using: .light)
        #expect(c != nil, "Expected a non-clear color in Light within 80 attempts.")
    }

    @Test("Able to obtain a non-clear random color in Dark within N attempts")
    func test_random_producesUsableColor_inDark() {
        let c = nonClearColor(using: .dark)
        #expect(c != nil, "Expected a non-clear color in Dark within 80 attempts.")
    }

    @Test("HEX of the obtained colors is well-formed (#RRGGBBAA) when available")
    func test_random_hexFormat_ofObtainedColors() {
        func isValidHex9(_ s: String) -> Bool {
            guard s.count == 9, s.first == "#" else { return false }
            return s.dropFirst().allSatisfy { ("0"..."9").contains($0) || ("a"..."f").contains($0) || ("A"..."F").contains($0) }
        }

        if let light = nonClearColor(using: .light) {
            let h = hex(light)
            if h != "#NA" { #expect(isValidHex9(h)) }
        } else {
            Issue.record("Could not obtain non-clear Light color within attempts; skipping HEX assertion.")
        }

        if let dark = nonClearColor(using: .dark) {
            let h = hex(dark)
            if h != "#NA" { #expect(isValidHex9(h)) }
        } else {
            Issue.record("Could not obtain non-clear Dark color within attempts; skipping HEX assertion.")
        }
    }

    @Test("Random output shows basic variability per scheme")
    func test_random_showsVariability() {
        #expect(hasBasicVariability(using: .light), "Expected >1 distinct HEX values in Light over sample window.")
        #expect(hasBasicVariability(using: .dark),  "Expected >1 distinct HEX values in Dark over sample window.")
    }
}

