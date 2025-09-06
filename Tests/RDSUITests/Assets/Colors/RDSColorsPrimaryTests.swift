import Testing
import SwiftUI
@testable import RDSUI

/// Primary palette smoke tests that are resilient while tones are being filled.
/// They ensure API shape and basic color conversion remain stable.
@MainActor
@Suite("RDSColors Primary Tests")
struct RDSColorsPrimaryTests {

    // MARK: - Helpers

    /// Returns true when string format matches "#RRGGBBAA"
    private func isValidHex9(_ s: String) -> Bool {
        guard s.count == 9, s.first == "#" else { return false }
        let hex = s.dropFirst()
        return hex.allSatisfy { ("0"..."9").contains($0) || ("a"..."f").contains($0) || ("A"..."F").contains($0) }
    }

    private func hex(_ c: Color) -> String {
        RDSColorExport.hex(from: c, includeAlpha: true) ?? "#N/A"
    }

    // MARK: - Families exist and expose tones

    @Test("DarkBlue exposes at least one tone")
    func darkBlue_hasTones() {
        #expect(!RDSColors.primary.DarkBlue.Tone.allCases.isEmpty)
    }

    @Test("LightBlue exposes at least one tone")
    func lightBlue_hasTones() {
        #expect(!RDSColors.primary.LightBlue.Tone.allCases.isEmpty)
    }

    @Test("DarkTextGray exposes at least one tone")
    func darkTextGray_hasTones() {
        #expect(!RDSColors.primary.DarkTextGray.Tone.allCases.isEmpty)
    }

    // MARK: - Smoke: color(_:using:) returns a convertible Color

    @Test("DarkBlue t100 produces a HEX string in light & dark")
    func darkBlue_t100_hexConvertible() {
        let light = hex(RDSColors.primary.DarkBlue.color(.t100, using: .light))
        let dark  = hex(RDSColors.primary.DarkBlue.color(.t100, using: .dark))
        #expect(isValidHex9(light))
        #expect(isValidHex9(dark))
    }

    @Test("All DarkBlue tones are HEX-convertible in both schemes")
    func darkBlue_allTones_hexConvertible() {
        for tone in RDSColors.primary.DarkBlue.Tone.allCases {
            #expect(isValidHex9(hex(RDSColors.primary.DarkBlue.color(tone, using: .light))))
            #expect(isValidHex9(hex(RDSColors.primary.DarkBlue.color(tone, using: .dark))))
        }
    }

    @Test("All LightBlue tones are HEX-convertible in both schemes")
    func lightBlue_allTones_hexConvertible() {
        for tone in RDSColors.primary.LightBlue.Tone.allCases {
            #expect(isValidHex9(hex(RDSColors.primary.LightBlue.color(tone, using: .light))))
            #expect(isValidHex9(hex(RDSColors.primary.LightBlue.color(tone, using: .dark))))
        }
    }

    @Test("All DarkTextGray tones are HEX-convertible in both schemes")
    func darkTextGray_allTones_hexConvertible() {
        for tone in RDSColors.primary.DarkTextGray.Tone.allCases {
            #expect(isValidHex9(hex(RDSColors.primary.DarkTextGray.color(tone, using: .light))))
            #expect(isValidHex9(hex(RDSColors.primary.DarkTextGray.color(tone, using: .dark))))
        }
    }
}

