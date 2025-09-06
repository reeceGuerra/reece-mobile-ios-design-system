import Testing
import SwiftUI
@testable import RDSUI

/// Unit tests for the primary color families in the design system.
/// Covers tone presence, dark/light variants, and additional shades.
@Suite("RDSColors Primary Tests")
struct RDSColorsPrimaryTests {

    @Test("Dark Blue t100 should resolve in light scheme")
    func testDarkBlueLightTone() {
        let color = RDSColors.primary.DarkBlue.color(.t100, using: .light)
        #expect(color != nil)
    }

    @Test("Dark Blue tone falls back in dark scheme if missing")
    func testDarkBlueDarkToneFallback() {
        let color = RDSColors.primary.DarkBlue.color(.t100, using: .dark)
        #expect(color != nil)
    }

    @Test("All Dark Blue tones resolve values")
    func testAllDarkBlueTonesHaveValues() {
        for tone in RDSColors.primary.DarkBlue.allTones {
            let lightColor = RDSColors.primary.DarkBlue.color(tone, using: .light)
            let darkColor = RDSColors.primary.DarkBlue.color(tone, using: .dark)
            #expect(lightColor != nil)
            #expect(darkColor != nil)
        }
    }

    @Test("All Light Blue tones resolve values")
    func testAllLightBlueTonesHaveValues() {
        for tone in RDSColors.primary.LightBlue.Tone.allCases {
            #expect(RDSColors.primary.LightBlue.color(tone, using: .light) != nil)
            #expect(RDSColors.primary.LightBlue.color(tone, using: .dark) != nil)
        }
    }

    @Test("All Dark Text Gray tones resolve values")
    func testAllDarkTextGrayTonesHaveValues() {
        for tone in RDSColors.primary.DarkTextGray.Tone.allCases {
            #expect(RDSColors.primary.DarkTextGray.color(tone, using: .light) != nil)
            #expect(RDSColors.primary.DarkTextGray.color(tone, using: .dark) != nil)
        }
    }

    @Test("Dark Blue exposes additional tones")
    func testDarkBlueAdditionalTones() {
        #expect(!RDSColors.primary.DarkBlue.additionalTones.isEmpty)
    }

    @Test("Light Blue exposes additional tones")
    func testLightBlueAdditionalTones() {
        #expect(!RDSColors.primary.LightBlue.additionalTones.isEmpty)
    }

    @Test("Dark Text Gray exposes additional tones")
    func testDarkTextGrayAdditionalTones() {
        #expect(!RDSColors.primary.DarkTextGray.additionalTones.isEmpty)
    }
}
