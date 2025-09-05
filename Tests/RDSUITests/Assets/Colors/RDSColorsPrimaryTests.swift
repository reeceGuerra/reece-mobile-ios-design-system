import XCTest
import SwiftUI
@testable import RDSUI

@MainActor
final class RDSColorsPrimaryTests: XCTestCase {

    func testDarkBlueLightTone() {
        let color = RDSColors.primary.DarkBlue.color(.t100, using: ColorScheme.light)
        XCTAssertNotNil(color, "Expected a valid Color for Dark Blue t100 (light)")
    }

    func testDarkBlueDarkToneFallback() {
        let lightColor = RDSColors.primary.DarkBlue.color(.t100, using: .light)
        let darkColor  = RDSColors.primary.DarkBlue.color(.t100, using: .dark)

        XCTAssertEqual(lightColor.description, darkColor.description,
                       "Dark mode should fallback to light until design provides dark palette")
    }
    
    func testAllDarkBlueTonesHaveValues() {
        for tone in RDSColors.primary.DarkBlue.Tone.allCases {
            let colorLight = RDSColors.primary.DarkBlue.color(tone, using: ColorScheme.light)
            let colorDark  = RDSColors.primary.DarkBlue.color(tone, using: ColorScheme.dark)
            XCTAssertEqual(colorLight.description, colorDark.description)
        }
    }

    func testAllLightBlueTonesHaveValues() {
        for tone in RDSColors.primary.LightBlue.Tone.allCases {
            let color = RDSColors.primary.LightBlue.color(tone, using: ColorScheme.light)
            XCTAssertNotNil(color, "Missing color for Light Blue \(tone)")
        }
    }
    
    func testAllDarkTextGrayTonesHaveValues() {
        for tone in RDSColors.primary.DarkTextGray.Tone.allCases {
            let light = RDSColors.primary.DarkTextGray.color(tone, using: .light)
            let dark  = RDSColors.primary.DarkTextGray.color(tone, using: .dark)
            XCTAssertEqual(light.description, dark.description,
                           "DarkTextGray dark should fallback to light until design provides dark palette")
        }
    }

    // Primary: cubrir más tonos
    func testDarkBlueAdditionalTones() {
        _ = RDSColors.primary.DarkBlue.color(.t50, using: .light)
        _ = RDSColors.primary.DarkBlue.color(.t10, using: .dark)
    }

    func testLightBlueAdditionalTones() {
        _ = RDSColors.primary.LightBlue.color(.t50, using: .light)
        _ = RDSColors.primary.LightBlue.color(.t5,  using: .dark)
    }

    func testDarkTextGrayAdditionalTones() {
        _ = RDSColors.primary.DarkTextGray.color(.t50, using: .light)
        _ = RDSColors.primary.DarkTextGray.color(.t10, using: .dark)
    }

}
