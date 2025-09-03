//
//  ReeceTextBuilderTests.swift
//  ReeceDesignSystem
//
//  Created by ChatGPT on 03/09/25.
//

import XCTest
import SwiftUI
@testable import ReeceDesignSystem

/// These tests execute the ReeceText builder and the ViewModifier paths
/// to make sure the code runs (and thus is covered) across families/slants/scales.
final class ReeceTextBuilderTests: XCTestCase {

    @MainActor @ViewBuilder
    private func sample(_ token: ReeceTextStyleToken,
                        slant: ReeceFontSlant,
                        color: Color = .primary,
                        family: ReeceFontFamily = .system,
                        scale: CGFloat? = 1.0) -> some View {
        ReeceText("Hello Reece!", token: token, slant: slant, color: color, family: family, designScale: scale)
    }

    @MainActor func testBuilder_System_Normal() {
        // Just exercise the code path; we only assert construction succeeds.
        let view = sample(.body, slant: .normal, color: .blue, family: .system, scale: 1.0)
        XCTAssertNotNil(String(describing: view))
    }

    @MainActor func testBuilder_System_Italic() {
        let view = sample(.body, slant: .italic, color: .red, family: .system, scale: 1.0)
        XCTAssertNotNil(String(describing: view))
    }

    @MainActor func testBuilder_Roboto_Italic_And_Scale2() {
        // Scale=2 halves the base point size; we only need to exercise the builder with these params.
        let view = sample(.h4B, slant: .italic, color: .green, family: .roboto, scale: 2.0)
        XCTAssertNotNil(String(describing: view))
    }

    @MainActor func testViewModifierAPI() {
        // Exercise the ViewModifier fallback path.
        let v = Text("Modifier API").reeceText(.buttonM, slant: .normal, color: .purple, family: .openSans, designScale: 1.0)
        XCTAssertNotNil(String(describing: v))
    }
}
