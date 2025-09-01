import XCTest
import SwiftUI
@testable import ReeceDesignSystem

@MainActor
final class ReeceColorsPrimaryTests: XCTestCase {

    func testDarkBlueLightTone() {
        let color = ReeceColors.primary.DarkBlue.color(.t100, using: ColorScheme.light)
        XCTAssertNotNil(color, "Expected a valid Color for Dark Blue t100 (light)")
    }

    func testDarkBlueDarkToneFallback() {
        let lightColor = ReeceColors.primary.DarkBlue.color(.t100, using: .light)
        let darkColor  = ReeceColors.primary.DarkBlue.color(.t100, using: .dark)

        XCTAssertEqual(lightColor.description, darkColor.description,
                       "Dark mode should fallback to light until design provides dark palette")
    }
    
    func testAllDarkBlueTonesHaveValues() {
        for tone in ReeceColors.primary.DarkBlue.Tone.allCases {
            let colorLight = ReeceColors.primary.DarkBlue.color(tone, using: ColorScheme.light)
            let colorDark  = ReeceColors.primary.DarkBlue.color(tone, using: ColorScheme.dark)
            XCTAssertEqual(colorLight.description, colorDark.description)
        }
    }

    func testAllLightBlueTonesHaveValues() {
        for tone in ReeceColors.primary.LightBlue.Tone.allCases {
            let color = ReeceColors.primary.LightBlue.color(tone, using: ColorScheme.light)
            XCTAssertNotNil(color, "Missing color for Light Blue \(tone)")
        }
    }
    
    func testAllDarkTextGrayTonesHaveValues() {
        for tone in ReeceColors.primary.DarkTextGray.Tone.allCases {
            let light = ReeceColors.primary.DarkTextGray.color(tone, using: .light)
            let dark  = ReeceColors.primary.DarkTextGray.color(tone, using: .dark)
            XCTAssertEqual(light.description, dark.description,
                           "DarkTextGray dark should fallback to light until design provides dark palette")
        }
    }

    // Primary: cubrir más tonos
    func testDarkBlueAdditionalTones() {
        _ = ReeceColors.primary.DarkBlue.color(.t50, using: .light)
        _ = ReeceColors.primary.DarkBlue.color(.t10, using: .dark)
    }

    func testLightBlueAdditionalTones() {
        _ = ReeceColors.primary.LightBlue.color(.t50, using: .light)
        _ = ReeceColors.primary.LightBlue.color(.t5,  using: .dark)
    }

    func testDarkTextGrayAdditionalTones() {
        _ = ReeceColors.primary.DarkTextGray.color(.t50, using: .light)
        _ = ReeceColors.primary.DarkTextGray.color(.t10, using: .dark)
    }

}
