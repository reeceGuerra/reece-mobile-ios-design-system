//
//  RDSColorHexTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 30/08/25.
//

import Testing
import SwiftUI
@testable import RDSUI

@Suite("RDSColorHex parsing & formatting")
struct RDSColorHexTests {

    // MARK: - Error cases

    @Test("Rejects unsupported lengths")
    func rejectsUnsupportedLengths() {
        do {
            _ = try RDSColorHex.parse("#12") // 2 hex digits → invalid
            #expect(false, "Expected parse to throw for invalid length")
        } catch let err as HexColorError {
            #expect(err == .invalidLength(actual: 2))
        } catch {
            #expect(false, "Unexpected error type: \(error)")
        }
    }

    @Test("Rejects non-hex characters")
    func rejectsNonHexCharacters() {
        do {
            _ = try RDSColorHex.parse("#GGHHII")
            #expect(false, "Expected parse to throw for invalid scan")
        } catch let err as HexColorError {
            #expect(err == .invalidScan("GGHHII"))
        } catch {
            #expect(false, "Unexpected error type: \(error)")
        }
    }

    // MARK: - Valid parsing forms

    @Test("Parses short RGB (#RGB) expanding nibbles")
    func parsesShortRGB() throws {
        // #1A2 → (0x11, 0xAA, 0x22)
        let c = try RDSColorHex.parse("#1A2")
        let tol: CGFloat = 0.001
        #expect(abs(c.r - (17.0/255.0)) <= tol)
        #expect(abs(c.g - (170.0/255.0)) <= tol)
        #expect(abs(c.b - (34.0/255.0)) <= tol)
        #expect(abs(c.a - 1.0) <= tol)
    }

    @Test("Parses short RGBA (#RGBA) expanding nibbles")
    func parsesShortRGBA() throws {
        // #1A2F → (0x11, 0xAA, 0x22, 0xFF)
        let c = try RDSColorHex.parse("#1A2F")
        let tol: CGFloat = 0.001
        #expect(abs(c.r - (17.0/255.0)) <= tol)
        #expect(abs(c.g - (170.0/255.0)) <= tol)
        #expect(abs(c.b - (34.0/255.0)) <= tol)
        #expect(abs(c.a - 1.0) <= tol)
    }

    @Test("Parses full RGB (#RRGGBB)")
    func parsesFullRGB() throws {
        let c = try RDSColorHex.parse("#0859A8")
        let tol: CGFloat = 0.0001
        #expect(abs(c.a - 1.0) <= tol)
        #expect(c.r >= 0 && c.r <= 1 && c.g >= 0 && c.g <= 1 && c.b >= 0 && c.b <= 1)
    }

    @Test("Parses full RGBA (#RRGGBBAA)")
    func parsesFullRGBA() throws {
        let c = try RDSColorHex.parse("#0859A8FF")
        let tol: CGFloat = 0.0001
        #expect(abs(c.a - 1.0) <= tol)
    }

    // MARK: - Formatting

    @Test("Formats RGBA components to uppercase HEX")
    func formatsComponentsToHEX() {
        // 0x40 = round(0.25 * 255), 0x7A ≈ round(0.48 * 255), 0x26 ≈ round(0.15 * 255)
        let s1 = RDSColorHex.string(r: 0.25, g: 0.48, b: 0.15, includeAlpha: false)
        let s2 = RDSColorHex.string(r: 0.25, g: 0.48, b: 0.15, a: 1.0, includeAlpha: true)

        #expect(s1 == "#407A26")
        #expect(s2 == "#407A26FF")
    }

    @Test("Formats SwiftUI.Color to HEX in sRGB")
    func formatsSwiftUIColorToHEX() {
        // Known primaries in sRGB
        #expect(RDSColorHex.string(from: .red,   colorSpace: .sRGB, includeAlpha: false) == "#FF0000")
        #expect(RDSColorHex.string(from: .green, colorSpace: .sRGB, includeAlpha: false) == "#00FF00")
        #expect(RDSColorHex.string(from: .blue,  colorSpace: .sRGB, includeAlpha: false) == "#0000FF")

        // Alpha variant
        #expect(RDSColorHex.string(from: .red.opacity(0.5), colorSpace: .sRGB, includeAlpha: true) == "#FF000080")
    }

    // MARK: - Round-trip (HEX → Color → HEX)

    @Test("Round-trips HEX → Color → HEX (RGB)")
    func roundTrip_RGB() {
        let original = "#407A26"
        guard let c = RDSColorHex.color(from: original, colorSpace: .sRGB) else {
            #expect(false, "Failed to build Color from \(original)")
            return
        }
        let hex = RDSColorHex.string(from: c, colorSpace: .sRGB, includeAlpha: false)
        #expect(hex == original)
    }

    @Test("Round-trips HEX → Color → HEX (RGBA)")
    func roundTrip_RGBA() {
        let original = "#407A26CC"
        guard let c = RDSColorHex.color(from: original, colorSpace: .sRGB) else {
            #expect(false, "Failed to build Color from \(original)")
            return
        }
        let hex = RDSColorHex.string(from: c, colorSpace: .sRGB, includeAlpha: true)
        #expect(hex == original)
    }
}
