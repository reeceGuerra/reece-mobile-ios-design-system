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

    func testOrangeLightTone() {
        let color = ReeceColors.secondary.orange(.t100, using: .light)
        XCTAssertNotNil(color, "Expected a valid Color for Orange t100 (light)")
    }

    func testOrangeDarkToneFallback() {
        let lightColor = ReeceColors.secondary.orange(.t100, using: .light)
        let darkColor  = ReeceColors.secondary.orange(.t100, using: .dark)

        XCTAssertEqual(lightColor.description, darkColor.description,
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
}
