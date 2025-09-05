//
//  RDSThemeModeTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 03/09/25.
//


//
//  RDSThemeModeTests.swift
//  RDSDesignSystemTests
//
//  Verifies RDSThemeMode semantics and RDSTheme global configuration.
//  - Ensures allCases has expected cases and order
//  - Ensures id mirrors title
//  - Ensures effectiveScheme logic (system passthrough vs forced schemes)
//  - Ensures RDSTheme.mode default and mutability on the main actor
//

import XCTest
import SwiftUI
@testable import RDSUI

final class RDSThemeModeTests: XCTestCase {

    func test_allCases_order_and_count() {
        // Source order matters for menus; lock it down.
        XCTAssertEqual(RDSThemeMode.allCases, [.system, .light, .dark])
        XCTAssertEqual(RDSThemeMode.allCases.count, 3)
    }

    func test_id_matches_title_for_all_modes() {
        for mode in RDSThemeMode.allCases {
            XCTAssertEqual(mode.id, mode.title, "Expected id to equal title for \(mode)")
        }
    }

    func test_effectiveScheme_system_passthrough_light() {
        let resolved = RDSThemeMode.effectiveScheme(using: .light, themeMode: .system)
        XCTAssertEqual(resolved, .light)
    }

    func test_effectiveScheme_system_passthrough_dark() {
        let resolved = RDSThemeMode.effectiveScheme(using: .dark, themeMode: .system)
        XCTAssertEqual(resolved, .dark)
    }

    func test_effectiveScheme_forced_light() {
        let resolved = RDSThemeMode.effectiveScheme(using: .dark, themeMode: .light)
        XCTAssertEqual(resolved, .light)
    }

    func test_effectiveScheme_forced_dark() {
        let resolved = RDSThemeMode.effectiveScheme(using: .light, themeMode: .dark)
        XCTAssertEqual(resolved, .dark)
    }

    /// Touches the @MainActor global to verify default and mutability.
    @MainActor
    func test_globalTheme_default_is_system_and_is_mutable() {
        let original = RDSTheme.mode
        // The documentation says default is `.system`
        XCTAssertEqual(original, .system)

        RDSTheme.mode = .dark
        XCTAssertEqual(RDSTheme.mode, .dark)

        // Restore so we don't leak state between tests
        RDSTheme.mode = original
        XCTAssertEqual(RDSTheme.mode, .system)
    }
}
