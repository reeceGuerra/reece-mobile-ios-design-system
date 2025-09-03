//
//  ReeceThemeModeTests.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 03/09/25.
//


//
//  ReeceThemeModeTests.swift
//  ReeceDesignSystemTests
//
//  Verifies ReeceThemeMode semantics and ReeceTheme global configuration.
//  - Ensures allCases has expected cases and order
//  - Ensures id mirrors title
//  - Ensures effectiveScheme logic (system passthrough vs forced schemes)
//  - Ensures ReeceTheme.mode default and mutability on the main actor
//

import XCTest
import SwiftUI
@testable import ReeceDesignSystem

final class ReeceThemeModeTests: XCTestCase {

    func test_allCases_order_and_count() {
        // Source order matters for menus; lock it down.
        XCTAssertEqual(ReeceThemeMode.allCases, [.system, .light, .dark])
        XCTAssertEqual(ReeceThemeMode.allCases.count, 3)
    }

    func test_id_matches_title_for_all_modes() {
        for mode in ReeceThemeMode.allCases {
            XCTAssertEqual(mode.id, mode.title, "Expected id to equal title for \(mode)")
        }
    }

    func test_effectiveScheme_system_passthrough_light() {
        let resolved = ReeceThemeMode.effectiveScheme(using: .light, themeMode: .system)
        XCTAssertEqual(resolved, .light)
    }

    func test_effectiveScheme_system_passthrough_dark() {
        let resolved = ReeceThemeMode.effectiveScheme(using: .dark, themeMode: .system)
        XCTAssertEqual(resolved, .dark)
    }

    func test_effectiveScheme_forced_light() {
        let resolved = ReeceThemeMode.effectiveScheme(using: .dark, themeMode: .light)
        XCTAssertEqual(resolved, .light)
    }

    func test_effectiveScheme_forced_dark() {
        let resolved = ReeceThemeMode.effectiveScheme(using: .light, themeMode: .dark)
        XCTAssertEqual(resolved, .dark)
    }

    /// Touches the @MainActor global to verify default and mutability.
    @MainActor
    func test_globalTheme_default_is_system_and_is_mutable() {
        let original = ReeceTheme.mode
        // The documentation says default is `.system`
        XCTAssertEqual(original, .system)

        ReeceTheme.mode = .dark
        XCTAssertEqual(ReeceTheme.mode, .dark)

        // Restore so we don't leak state between tests
        ReeceTheme.mode = original
        XCTAssertEqual(ReeceTheme.mode, .system)
    }
}
