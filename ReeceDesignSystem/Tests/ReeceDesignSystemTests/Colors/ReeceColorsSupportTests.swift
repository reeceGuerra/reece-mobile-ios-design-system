//
//  ReeceColorsSupportTests.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 30/08/25.
//


import XCTest
import SwiftUI
@testable import ReeceDesignSystem

@MainActor
final class ReeceColorsSupportTests: XCTestCase {

    // MARK: - Green (10 tones)

    func testGreenOneToneExists() {
        let c = ReeceColors.support.Green.color(.t100, using: .light)
        XCTAssertNotNil(c, "Expected a valid Color for Support.Green t100 (light)")
    }

    func testAllGreenTonesHaveValues() {
        for tone in ReeceColors.support.Green.Tone.allCases {
            let light = ReeceColors.support.Green.color(tone, using: .light)
            let dark  = ReeceColors.support.Green.color(tone, using: .dark)
            XCTAssertEqual(light.description, dark.description,
                           "Green tone \(tone) mismatch between light/dark (fallback expected)")
        }
    }

    // MARK: - Orangy Red (10 tones)

    func testOrangyRedOneToneExists() {
        let c = ReeceColors.support.OrangyRed.color(.t100, using: .light)
        XCTAssertNotNil(c, "Expected a valid Color for Support.OrangyRed t100 (light)")
    }

    func testAllOrangyRedTonesHaveValues() {
        for tone in ReeceColors.support.OrangyRed.Tone.allCases {
            let light = ReeceColors.support.OrangyRed.color(tone, using: .light)
            let dark  = ReeceColors.support.OrangyRed.color(tone, using: .dark)
            XCTAssertEqual(light.description, dark.description,
                           "OrangyRed tone \(tone) mismatch between light/dark (fallback expected)")
        }
    }

    // MARK: - Yellow (10 tones)

    func testYellowOneToneExists() {
        let c = ReeceColors.support.Yellow.color(.t100, using: .light)
        XCTAssertNotNil(c, "Expected a valid Color for Support.Yellow t100 (light)")
    }

    func testAllYellowTonesHaveValues() {
        for tone in ReeceColors.support.Yellow.Tone.allCases {
            let light = ReeceColors.support.Yellow.color(tone, using: .light)
            let dark  = ReeceColors.support.Yellow.color(tone, using: .dark)
            XCTAssertEqual(light.description, dark.description,
                           "Yellow tone \(tone) mismatch between light/dark (fallback expected)")
        }
    }

    // MARK: - Teal (10 tones)

    func testTealOneToneExists() {
        let c = ReeceColors.support.Teal.color(.t100, using: .light)
        XCTAssertNotNil(c, "Expected a valid Color for Support.Teal t100 (light)")
    }

    func testAllTealTonesHaveValues() {
        for tone in ReeceColors.support.Teal.Tone.allCases {
            let light = ReeceColors.support.Teal.color(tone, using: .light)
            let dark  = ReeceColors.support.Teal.color(tone, using: .dark)
            XCTAssertEqual(light.description, dark.description,
                           "Teal tone \(tone) mismatch between light/dark (fallback expected)")
        }
    }

    // MARK: - Sky Blue (10 tones)

    func testSkyBlueOneToneExists() {
        let c = ReeceColors.support.SkyBlue.color(.t100, using: .light)
        XCTAssertNotNil(c, "Expected a valid Color for Support.SkyBlue t100 (light)")
    }

    func testAllSkyBlueTonesHaveValues() {
        for tone in ReeceColors.support.SkyBlue.Tone.allCases {
            let light = ReeceColors.support.SkyBlue.color(tone, using: .light)
            let dark  = ReeceColors.support.SkyBlue.color(tone, using: .dark)
            XCTAssertEqual(light.description, dark.description,
                           "SkyBlue tone \(tone) mismatch between light/dark (fallback expected)")
        }
    }

    // MARK: - Purple (10 tones)

    func testPurpleOneToneExists() {
        let c = ReeceColors.support.Purple.color(.t100, using: .light)
        XCTAssertNotNil(c, "Expected a valid Color for Support.Purple t100 (light)")
    }

    func testAllPurpleTonesHaveValues() {
        for tone in ReeceColors.support.Purple.Tone.allCases {
            let light = ReeceColors.support.Purple.color(tone, using: .light)
            let dark  = ReeceColors.support.Purple.color(tone, using: .dark)
            XCTAssertEqual(light.description, dark.description,
                           "Purple tone \(tone) mismatch between light/dark (fallback expected)")
        }
    }

    // MARK: - Single-tone (Hover Blue)

    func testHoverBlueExistsAndFallback() {
        let light = ReeceColors.support.HoverBlue.color(using: .light)
        let dark  = ReeceColors.support.HoverBlue.color(using: .dark)
        XCTAssertNotNil(light)
        XCTAssertEqual(light.description, dark.description,
                       "HoverBlue should fallback to same value in dark mode for now")
    }
}
