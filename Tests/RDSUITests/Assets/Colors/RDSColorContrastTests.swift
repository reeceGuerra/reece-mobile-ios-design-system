//
//  RDSColorContrastTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 31/08/25.
//

import Testing
import SwiftUI
@testable import RDSUI

@Suite("RDSColorContrast")
struct RDSColorContrastTests {

    // Helper: HEX from a Color (without alpha)
    private func hex(_ c: Color) -> String {
        RDSColorExport.hex(from: c, includeAlpha: false) ?? "NIL"
    }

    // Helper: parse HEX to Color safely
    private func color(_ hex: String) -> Color {
        guard let c = RDSColorHex.color(from: hex) else { return .clear }
        return c
    }

    @Test("Returns black for light backgrounds (default threshold)")
    func prefersBlackOnLightBackground() {
        // Very light gray
        let bg = color("#FAFAFA")
        let label = RDSColorContrast.onColor(for: bg)
        #expect(hex(label) == "#000000")
    }

    @Test("Returns white for dark backgrounds (default threshold)")
    func prefersWhiteOnDarkBackground() {
        // Near-black
        let bg = color("#121212")
        let label = RDSColorContrast.onColor(for: bg)
        #expect(hex(label) == "#FFFFFF")
    }

    @Test("Threshold parameter affects decision around mid-gray")
    func thresholdAffectsDecision() {
        // Mid gray ⇒ luminance ~0.502
        let bg = color("#808080")

        // Default threshold = 0.57 → 0.502 < 0.57 ⇒ white
        let labelDefault = RDSColorContrast.onColor(for: bg)
        #expect(hex(labelDefault) == "#FFFFFF")

        // Lower threshold = 0.40 → 0.502 > 0.40 ⇒ black
        let labelLower = RDSColorContrast.onColor(for: bg, threshold: 0.40)
        #expect(hex(labelLower) == "#000000")
    }

    @Test("Accepts explicit ColorScheme (no crash, returns valid color)")
    func acceptsExplicitScheme() {
        // Arbitrary background
        let bg = color("#3E5479")

        let labelDark  = RDSColorContrast.onColor(for: bg, scheme: .dark)
        let labelLight = RDSColorContrast.onColor(for: bg, scheme: .light)

        // Soft assertions: returns a valid HEX
        #expect(hex(labelDark)  != "NIL")
        #expect(hex(labelLight) != "NIL")
    }
}
