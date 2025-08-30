//
//  Test.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 30/08/25.
//

import XCTest
import SwiftUI
@testable import ReeceDesignSystem

@MainActor
final class ReeceColorsSecondaryTests: XCTestCase {

    // MARK: - Orange (10 tones)

    func testOrangeOneToneExists() {
        let c = ReeceColors.secondary.orange(.t100, using: ColorScheme.light)
        XCTAssertNotNil(c, "Expected a valid Color for Secondary.Orange t100 (light)")
    }

    func testOrangeDarkFallbackEqualsLight() {
        let light = ReeceColors.secondary.orange(.t100, using: ColorScheme.light)
        let dark  = ReeceColors.secondary.orange(.t100, using: ColorScheme.dark)
        XCTAssertEqual(light.description, dark.description,
                       "Orange dark should fallback to light until design provides dark palette")
    }

    func testAllOrangeTonesHaveValues() {
        for tone in OrangeTone.allCases {
            let light = ReeceColors.secondary.orange(tone, using: ColorScheme.light)
            let dark  = ReeceColors.secondary.orange(tone, using: ColorScheme.dark)
            XCTAssertEqual(light.description, dark.description,
                           "Orange tone \(tone) missing or inconsistent between light/dark")
        }
    }

    // MARK: - Text Gray (10 tones)

    func testTextGrayOneToneExists() {
        let c = ReeceColors.secondary.textGray(.t100, using: ColorScheme.light)
        XCTAssertNotNil(c, "Expected a valid Color for Secondary.TextGray t100 (light)")
    }

    func testAllTextGrayTonesHaveValues() {
        for tone in SecondaryTextGrayTone.allCases {
            let light = ReeceColors.secondary.textGray(tone, using: ColorScheme.light)
            let dark  = ReeceColors.secondary.textGray(tone, using: ColorScheme.dark)
            XCTAssertEqual(light.description, dark.description,
                           "Text Gray tone \(tone) missing or inconsistent between light/dark")
        }
    }

    // MARK: - Medium Grey (10 tones)

    func testMediumGreyOneToneExists() {
        let c = ReeceColors.secondary.mediumGrey(.t100, using: ColorScheme.light)
        XCTAssertNotNil(c, "Expected a valid Color for Secondary.MediumGrey t100 (light)")
    }

    func testAllMediumGreyTonesHaveValues() {
        for tone in MediumGreyTone.allCases {
            let light = ReeceColors.secondary.mediumGrey(tone, using: ColorScheme.light)
            let dark  = ReeceColors.secondary.mediumGrey(tone, using: ColorScheme.dark)
            XCTAssertEqual(light.description, dark.description,
                           "Medium Grey tone \(tone) missing or inconsistent between light/dark")
        }
    }

    // MARK: - Light Gray (10 tones)

    func testLightGrayOneToneExists() {
        let c = ReeceColors.secondary.lightGray(.t100, using: ColorScheme.light)
        XCTAssertNotNil(c, "Expected a valid Color for Secondary.LightGray t100 (light)")
    }

    func testAllLightGrayTonesHaveValues() {
        for tone in LightGrayTone.allCases {
            let light = ReeceColors.secondary.lightGray(tone, using: ColorScheme.light)
            let dark  = ReeceColors.secondary.lightGray(tone, using: ColorScheme.dark)
            XCTAssertEqual(light.description, dark.description,
                           "Light Gray tone \(tone) missing or inconsistent between light/dark")
        }
    }

    // MARK: - Single-tone colors

    func testWhiteExistsAndFallback() {
        let light = ReeceColors.secondary.white(using: ColorScheme.light)
        let dark  = ReeceColors.secondary.white(using: ColorScheme.dark)
        XCTAssertNotNil(light)
        XCTAssertEqual(light.description, dark.description,
                       "White should fallback to same value in dark mode for now")
    }

    func testOffWhiteExistsAndFallback() {
        let light = ReeceColors.secondary.offWhite(using: ColorScheme.light)
        let dark  = ReeceColors.secondary.offWhite(using: ColorScheme.dark)
        XCTAssertNotNil(light)
        XCTAssertEqual(light.description, dark.description,
                       "Off-White should fallback to same value in dark mode for now")
    }

    func testBlackExistsAndFallback() {
        let light = ReeceColors.secondary.black(using: ColorScheme.light)
        let dark  = ReeceColors.secondary.black(using: ColorScheme.dark)
        XCTAssertNotNil(light)
        XCTAssertEqual(light.description, dark.description,
                       "Black should fallback to same value in dark mode for now")
    }
}
