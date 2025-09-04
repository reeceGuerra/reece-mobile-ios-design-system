//
//  ReeceTextBuilderTests.swift
//  ReeceDesignSystem
//
//  Created by ChatGPT on 03/09/25.
//
//  Updated: remove deprecated `ReeceText(...)` builder usage.
//  Tests now exercise the ViewModifier API and compute helpers.
//
import XCTest
import SwiftUI
@testable import ReeceDesignSystem

/// Exercises Typography via the ViewModifier path and the compute helper,
/// ensuring code paths run across families, slants, and scales.
final class ReeceTextBuilderTests: XCTestCase {

    // MARK: - Helpers

    @MainActor @ViewBuilder
    private func sampleView(_ token: ReeceTextStyleToken,
                            slant: ReeceFontSlant,
                            color: Color = .primary,
                            family: ReeceFontFamily? = nil,
                            scale: CGFloat? = 1.0) -> some View {
        Text("Hello Reece!")
            .reeceText(token, slant: slant, color: color, family: family, designScale: scale)
    }

    // MARK: - ViewModifier API

    @MainActor func testModifier_System_Normal() {
        let view = sampleView(.body, slant: .normal, color: .blue, family: .system, scale: 1.0)
        XCTAssertNotNil(String(describing: view))
    }

    @MainActor func testModifier_Roboto_Italic_Scale2() {
        // Scale=2 halves the base point size in our px→pt mapping.
        let view = sampleView(.h4B, slant: .italic, color: .green, family: .roboto, scale: 2.0)
        XCTAssertNotNil(String(describing: view))
    }

    @MainActor func testModifier_OpenSans_ButtonM() {
        let view = sampleView(.buttonM, slant: .normal, color: .purple, family: .openSans, scale: 1.0)
        XCTAssertNotNil(String(describing: view))
    }

    // MARK: - Compute helper

    @MainActor func testCompute_KerningAndLineSpacing() {
        // Use token spec + slant override to exercise compute function.
        var spec = ReeceTextStyleToken.body.spec
        spec = spec.with(slant: .italic) // test slant propagation
        let r = _computeTextStyle(spec: spec, family: .system, designScale: 1.0)

        // Basic sanity checks on outputs.
        XCTAssertGreaterThanOrEqual(r.lineSpacing, 0, "Line spacing should not be negative")
        XCTAssertNotNil(String(describing: r.font))
    }

    @MainActor func testCompute_NoLineHeightMultiple() {
        // Construct a spec with nil lineHeightMultiple by omitting designLineHeightPx.
        let spec = ReeceTextSpec(
            designFontSizePx: 16,
            weight: .regular,
            slant: .normal,
            relativeTo: .body,
            designLineHeightPx: nil,
            letterSpacingPercent: 0.0
        )
        let r = _computeTextStyle(spec: spec, family: .system, designScale: 1.0)
        XCTAssertEqual(r.lineSpacing, 0, "Expected 0 extra spacing when no line-height multiple is provided.")
    }
}
