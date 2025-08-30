import XCTest
import SwiftUI
@testable import ReeceDesignSystem

@MainActor
final class ReeceColorsPrimaryTests: XCTestCase {

    func testDarkBlueLightTone() {
        let color = ReeceColors.primary.darkBlue(.t100, using: .light)
        XCTAssertNotNil(color, "Expected a valid Color for Dark Blue t100 (light)")
    }

    func testDarkBlueDarkToneFallback() {
        let lightColor = ReeceColors.primary.darkBlue(.t100, using: .light)
        let darkColor  = ReeceColors.primary.darkBlue(.t100, using: .dark)

        XCTAssertEqual(lightColor.description, darkColor.description,
                       "Dark mode should fallback to light until design provides dark palette")
    }
    
    func testAllDarkBlueTonesHaveValues() {
        for tone in DarkBlueTone.allCases {
            let colorLight = ReeceColors.primary.darkBlue(tone, using: ColorScheme.light)
            let colorDark  = ReeceColors.primary.darkBlue(tone, using: ColorScheme.dark)
            XCTAssertEqual(colorLight.description, colorDark.description)
        }
    }

    func testAllLightBlueTonesHaveValues() {
        for tone in LightBlueTone.allCases {
            let color = ReeceColors.primary.lightBlue(tone, using: ColorScheme.light)
            XCTAssertNotNil(color, "Missing color for Light Blue \(tone)")
        }
    }
    
    func testAllDarkTextGrayTonesHaveValues() {
        for tone in DarkTextGrayTone.allCases {
            let light = ReeceColors.primary.darkTextGray(tone, using: .light)
            let dark  = ReeceColors.primary.darkTextGray(tone, using: .dark)
            XCTAssertEqual(light.description, dark.description,
                           "DarkTextGray dark should fallback to light until design provides dark palette")
        }
    }
}
