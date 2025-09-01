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
        let c = ReeceColors.secondary.Orange.color(.t100, using: ColorScheme.light)
        XCTAssertNotNil(c, "Expected a valid Color for Secondary.Orange t100 (light)")
    }

    func testOrangeDarkFallbackEqualsLight() {
        let light = ReeceColors.secondary.Orange.color(.t100, using: ColorScheme.light)
        let dark  = ReeceColors.secondary.Orange.color(.t100, using: ColorScheme.dark)
        XCTAssertEqual(light.description, dark.description,
                       "Orange dark should fallback to light until design provides dark palette")
    }

    func testAllOrangeTonesHaveValues() {
        for tone in ReeceColors.secondary.Orange.Tone.allCases {
            let light = ReeceColors.secondary.Orange.color(tone, using: ColorScheme.light)
            let dark  = ReeceColors.secondary.Orange.color(tone, using: ColorScheme.dark)
            XCTAssertEqual(light.description, dark.description,
                           "Orange tone \(tone) missing or inconsistent between light/dark")
        }
    }

    // MARK: - Text Gray (10 tones)

    func testTextGrayOneToneExists() {
        let c = ReeceColors.secondary.TextGray.color(.t100, using: ColorScheme.light)
        XCTAssertNotNil(c, "Expected a valid Color for Secondary.TextGray t100 (light)")
    }

    func testAllTextGrayTonesHaveValues() {
        for tone in ReeceColors.secondary.TextGray.Tone.allCases {
            let light = ReeceColors.secondary.TextGray.color(tone, using: ColorScheme.light)
            let dark  = ReeceColors.secondary.TextGray.color(tone, using: ColorScheme.dark)
            XCTAssertEqual(light.description, dark.description,
                           "Text Gray tone \(tone) missing or inconsistent between light/dark")
        }
    }

    // MARK: - Medium Grey (10 tones)

    func testMediumGreyOneToneExists() {
        let c = ReeceColors.secondary.MediumGrey.color(.t100, using: ColorScheme.light)
        XCTAssertNotNil(c, "Expected a valid Color for Secondary.MediumGrey t100 (light)")
    }

    func testAllMediumGreyTonesHaveValues() {
        for tone in  ReeceColors.secondary.MediumGrey.Tone.allCases {
            let light = ReeceColors.secondary.MediumGrey.color(tone, using: ColorScheme.light)
            let dark  = ReeceColors.secondary.MediumGrey.color(tone, using: ColorScheme.dark)
            XCTAssertEqual(light.description, dark.description,
                           "Medium Grey tone \(tone) missing or inconsistent between light/dark")
        }
    }

    // MARK: - Light Gray (10 tones)

    func testLightGrayOneToneExists() {
        let c = ReeceColors.secondary.LightGray.color(.t100, using: ColorScheme.light)
        XCTAssertNotNil(c, "Expected a valid Color for Secondary.LightGray t100 (light)")
    }

    func testAllLightGrayTonesHaveValues() {
        for tone in ReeceColors.secondary.LightGray.Tone.allCases {
            let light = ReeceColors.secondary.LightGray.color(tone, using: ColorScheme.light)
            let dark  = ReeceColors.secondary.LightGray.color(tone, using: ColorScheme.dark)
            XCTAssertEqual(light.description, dark.description,
                           "Light Gray tone \(tone) missing or inconsistent between light/dark")
        }
    }

    // MARK: - Single-tone colors

    func testWhiteExistsAndFallback() {
        let light = ReeceColors.secondary.White.color(using: ColorScheme.light)
        let dark  = ReeceColors.secondary.White.color(using: ColorScheme.dark)
        XCTAssertNotNil(light)
        XCTAssertEqual(light.description, dark.description,
                       "White should fallback to same value in dark mode for now")
    }

    func testOffWhiteExistsAndFallback() {
        let light = ReeceColors.secondary.OffWhite.color(using: ColorScheme.light)
        let dark  = ReeceColors.secondary.OffWhite.color(using: ColorScheme.dark)
        XCTAssertNotNil(light)
        XCTAssertEqual(light.description, dark.description,
                       "Off-White should fallback to same value in dark mode for now")
    }

    func testBlackExistsAndFallback() {
        let light = ReeceColors.secondary.Black.color(using: ColorScheme.light)
        let dark  = ReeceColors.secondary.Black.color(using: ColorScheme.dark)
        XCTAssertNotNil(light)
        XCTAssertEqual(light.description, dark.description,
                       "Black should fallback to same value in dark mode for now")
    }
}
