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
        let c = ReeceColors.support.green(.t100, using: .light)
        XCTAssertNotNil(c, "Expected a valid Color for Support.Green t100 (light)")
    }

    func testAllGreenTonesHaveValues() {
        for tone in GreenTone.allCases {
            let light = ReeceColors.support.green(tone, using: .light)
            let dark  = ReeceColors.support.green(tone, using: .dark)
            XCTAssertEqual(light.description, dark.description,
                           "Green tone \(tone) mismatch between light/dark (fallback expected)")
        }
    }

    // MARK: - Orangy Red (10 tones)

    func testOrangyRedOneToneExists() {
        let c = ReeceColors.support.orangyRed(.t100, using: .light)
        XCTAssertNotNil(c, "Expected a valid Color for Support.OrangyRed t100 (light)")
    }

    func testAllOrangyRedTonesHaveValues() {
        for tone in OrangyRedTone.allCases {
            let light = ReeceColors.support.orangyRed(tone, using: .light)
            let dark  = ReeceColors.support.orangyRed(tone, using: .dark)
            XCTAssertEqual(light.description, dark.description,
                           "OrangyRed tone \(tone) mismatch between light/dark (fallback expected)")
        }
    }

    // MARK: - Yellow (10 tones)

    func testYellowOneToneExists() {
        let c = ReeceColors.support.yellow(.t100, using: .light)
        XCTAssertNotNil(c, "Expected a valid Color for Support.Yellow t100 (light)")
    }

    func testAllYellowTonesHaveValues() {
        for tone in YellowTone.allCases {
            let light = ReeceColors.support.yellow(tone, using: .light)
            let dark  = ReeceColors.support.yellow(tone, using: .dark)
            XCTAssertEqual(light.description, dark.description,
                           "Yellow tone \(tone) mismatch between light/dark (fallback expected)")
        }
    }

    // MARK: - Teal (10 tones)

    func testTealOneToneExists() {
        let c = ReeceColors.support.teal(.t100, using: .light)
        XCTAssertNotNil(c, "Expected a valid Color for Support.Teal t100 (light)")
    }

    func testAllTealTonesHaveValues() {
        for tone in TealTone.allCases {
            let light = ReeceColors.support.teal(tone, using: .light)
            let dark  = ReeceColors.support.teal(tone, using: .dark)
            XCTAssertEqual(light.description, dark.description,
                           "Teal tone \(tone) mismatch between light/dark (fallback expected)")
        }
    }

    // MARK: - Sky Blue (10 tones)

    func testSkyBlueOneToneExists() {
        let c = ReeceColors.support.skyBlue(.t100, using: .light)
        XCTAssertNotNil(c, "Expected a valid Color for Support.SkyBlue t100 (light)")
    }

    func testAllSkyBlueTonesHaveValues() {
        for tone in SkyBlueTone.allCases {
            let light = ReeceColors.support.skyBlue(tone, using: .light)
            let dark  = ReeceColors.support.skyBlue(tone, using: .dark)
            XCTAssertEqual(light.description, dark.description,
                           "SkyBlue tone \(tone) mismatch between light/dark (fallback expected)")
        }
    }

    // MARK: - Purple (10 tones)

    func testPurpleOneToneExists() {
        let c = ReeceColors.support.purple(.t100, using: .light)
        XCTAssertNotNil(c, "Expected a valid Color for Support.Purple t100 (light)")
    }

    func testAllPurpleTonesHaveValues() {
        for tone in PurpleTone.allCases {
            let light = ReeceColors.support.purple(tone, using: .light)
            let dark  = ReeceColors.support.purple(tone, using: .dark)
            XCTAssertEqual(light.description, dark.description,
                           "Purple tone \(tone) mismatch between light/dark (fallback expected)")
        }
    }

    // MARK: - Single-tone (Hover Blue)

    func testHoverBlueExistsAndFallback() {
        let light = ReeceColors.support.hoverBlue(using: .light)
        let dark  = ReeceColors.support.hoverBlue(using: .dark)
        XCTAssertNotNil(light)
        XCTAssertEqual(light.description, dark.description,
                       "HoverBlue should fallback to same value in dark mode for now")
    }
}
