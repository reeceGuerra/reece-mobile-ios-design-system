//
//  RDSColorExportTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 31/08/25.
//

import Testing
import SwiftUI
@testable import RDSUI

@Suite("RDSColorExport")
struct RDSColorExportTests {

    @Test("HEX round-trip RGB (#RRGGBB)")
    func hexRoundTrip_RGB_NoAlpha() {
        let original = "#407A26" // green sample
        guard let color = RDSColorHex.color(from: original) else {
            #expect(false, "Failed to parse HEX \(original)")
            return
        }
        let hex = RDSColorExport.hex(from: color, includeAlpha: false)
        #expect(hex != nil)
        #expect(hex == original.uppercased())
    }

    @Test("HEX round-trip RGBA (#RRGGBBAA)")
    func hexRoundTrip_RGBA_WithAlpha() {
        let original = "#FF00FF80" // fuchsia with 50% alpha
        guard let color = RDSColorHex.color(from: original) else {
            #expect(false, "Failed to parse HEX \(original)")
            return
        }
        let hex = RDSColorExport.hex(from: color, includeAlpha: true)
        #expect(hex != nil)
        #expect(hex == original.uppercased())
    }

    @Test("Extract RGBA components (sRGB)")
    func rgbaExtraction_sRGB() {
        let original = "#3366CCBF" // blue with ~75% alpha
        guard let color = RDSColorHex.color(from: original) else {
            #expect(false, "Failed to parse HEX \(original)")
            return
        }
        let rgba = RDSColorExport.rgba(from: color)
        #expect(rgba != nil)

        // Compare against parsed components with a small tolerance
        let (r, g, b, a) = try! RDSColorHex.parse(original)
        let tol: CGFloat = 0.01
        if let comps = rgba {
            #expect(abs(comps.r - r) <= tol)
            #expect(abs(comps.g - g) <= tol)
            #expect(abs(comps.b - b) <= tol)
            #expect(abs(comps.a - a) <= tol)
        }
    }
}
