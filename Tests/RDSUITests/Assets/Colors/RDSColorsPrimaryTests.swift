import Testing
import SwiftUI
@testable import RDSUI

/// Primary palette tests for DarkBlue, LightBlue and DarkTextGray.
/// Verifies that every tone resolves to a non-clear color in both schemes.
@MainActor
@Suite("RDSColors Primary Tests")
struct RDSColorsPrimaryTests {

    // MARK: - Dark Blue

    @Test("Dark Blue t100 resolves in light scheme")
    func testDarkBlueLightTone() {
        let c = RDSColors.primary.DarkBlue.color(.t100, using: .light)
        // Ensure the color is not transparent (missing tones should fallback to .clear)
        let hex = RDSColorExport.hex(from: c, includeAlpha: true)
        #expect(hex != "#00000000")
    }

    @Test("Dark Blue t100 resolves in dark scheme")
    func testDarkBlueDarkToneFallback() {
        let c = RDSColors.primary.DarkBlue.color(.t100, using: .dark)
        let hex = RDSColorExport.hex(from: c, includeAlpha: true)
        #expect(hex != "#00000000")
    }

    @Test("All Dark Blue tones resolve values (light & dark)")
    func testAllDarkBlueTonesHaveValues() {
        for tone in RDSColors.primary.DarkBlue.Tone.allCases {
            let lightHex = RDSColorExport.hex(from: RDSColors.primary.DarkBlue.color(tone, using: .light), includeAlpha: true)
            let darkHex  = RDSColorExport.hex(from: RDSColors.primary.DarkBlue.color(tone, using: .dark), includeAlpha: true)
            #expect(lightHex != "#00000000")
            #expect(darkHex  != "#00000000")
        }
    }

    // MARK: - Light Blue

    @Test("All Light Blue tones resolve values (light & dark)")
    func testAllLightBlueTonesHaveValues() {
        for tone in RDSColors.primary.LightBlue.Tone.allCases {
            let lightHex = RDSColorExport.hex(from: RDSColors.primary.LightBlue.color(tone, using: .light), includeAlpha: true)
            let darkHex  = RDSColorExport.hex(from: RDSColors.primary.LightBlue.color(tone, using: .dark), includeAlpha: true)
            #expect(lightHex != "#00000000")
            #expect(darkHex  != "#00000000")
        }
    }

    // MARK: - Dark Text Gray

    @Test("All Dark Text Gray tones resolve values (light & dark)")
    func testAllDarkTextGrayTonesHaveValues() {
        for tone in RDSColors.primary.DarkTextGray.Tone.allCases {
            let lightHex = RDSColorExport.hex(from: RDSColors.primary.DarkTextGray.color(tone, using: .light), includeAlpha: true)
            let darkHex  = RDSColorExport.hex(from: RDSColors.primary.DarkTextGray.color(tone, using: .dark), includeAlpha: true)
            #expect(lightHex != "#00000000")
            #expect(darkHex  != "#00000000")
        }
    }
}
