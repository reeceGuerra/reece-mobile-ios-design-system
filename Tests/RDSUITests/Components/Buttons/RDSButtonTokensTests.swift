//
//  RDSButtonTokensTests.swift
//  RDSUI
//
//  Created by Carlos Lopez on 06/09/25.
//


import Testing
import SwiftUI
@testable import RDSUI

/// Tests for RDSButtonTokensPaletteProvider wiring against color tokens.
/// We assert exact HEX (#RRGGBBAA) for background/border/selection and the underline flag.
/// Both .light and .dark are exercised (dark mirrors light in current tokens).
@MainActor
@Suite("RDSButtonTokens Palette Tests")
struct RDSButtonTokensTests {

    // MARK: - Helpers

    private func hex(_ color: Color) -> String {
        // Always include alpha to be explicit and deterministic
        RDSColorExport.hex(from: color, includeAlpha: true) ?? "#NA"
    }

    private func assertPalette(
        _ palette: RDSButtonPalette,
        bg expectedBG: String,
        border expectedBorder: String,
        selection expectedSelection: String,
        underline expectedUnderline: Bool,
        context: String
    ) {
        #expect(hex(palette.backgroundColor) == expectedBG,
                "[\(context)] background → \(hex(palette.backgroundColor)) (expected \(expectedBG))")
        #expect(hex(palette.borderColor) == expectedBorder,
                "[\(context)] border → \(hex(palette.borderColor)) (expected \(expectedBorder))")
        #expect(hex(palette.selectionColor) == expectedSelection,
                "[\(context)] selection → \(hex(palette.selectionColor)) (expected \(expectedSelection))")
        #expect(palette.underline == expectedUnderline,
                "[\(context)] underline → \(palette.underline) (expected \(expectedUnderline))")
    }

    private struct Expected {
        // Primary.DarkBlue.t100
        static let darkBlue100 = "#003766FF"
        // Support.HoverBlue
        static let hoverBlue   = "#024E8EFF"
        // Secondary.White
        static let white       = "#FFFFFFFF"
        // Primary.DarkTextGray.t60
        static let darkText60  = "#8C8C8CFF"
        // Support.Green.t100
        static let green100    = "#407A26FF"
        // Primary.LightBlue.t100
        static let lightBlue100 = "#0B66ECFF"
        // Secondary.TextGray.t60
        static let textGray60  = "#A0A0A0FF"
    }

    // MARK: - Matrix runner

    private func runAllCases(scheme: ColorScheme) {
        let provider = RDSButtonTokensPaletteProvider(scheme: scheme)

        func pal(_ v: RDSButtonVariant, _ t: RDSButtonType, _ s: RDSButtonState) -> RDSButtonPalette {
            provider.palette(for: v, type: t, state: s)
        }

        // --- Primary / Default ---
        assertPalette(
            pal(.primary, .default, .normal),
            bg: Expected.darkBlue100,
            border: Expected.darkBlue100,
            selection: Expected.white,
            underline: false,
            context: "primary/default/normal"
        )
        assertPalette(
            pal(.primary, .default, .highlighted),
            bg: Expected.hoverBlue,
            border: Expected.hoverBlue,
            selection: Expected.white,
            underline: false,
            context: "primary/default/highlighted"
        )
        // disabled & loading share visuals
        assertPalette(
            pal(.primary, .default, .disabled),
            bg: Expected.darkText60,
            border: Expected.darkText60,
            selection: Expected.white,
            underline: false,
            context: "primary/default/disabled"
        )
        assertPalette(
            pal(.primary, .default, .loading),
            bg: Expected.darkText60,
            border: Expected.darkText60,
            selection: Expected.white,
            underline: false,
            context: "primary/default/loading"
        )
        assertPalette(
            pal(.primary, .default, .confirmed),
            bg: Expected.green100,
            border: Expected.green100,
            selection: Expected.white,
            underline: false,
            context: "primary/default/confirmed"
        )

        // --- Primary / TextLink (underline = true) ---
        assertPalette(
            pal(.primary, .textLink, .normal),
            bg: Expected.white,
            border: Expected.white,
            selection: Expected.lightBlue100,
            underline: true,
            context: "primary/textLink/normal"
        )
        assertPalette(
            pal(.primary, .textLink, .highlighted),
            bg: Expected.white,
            border: Expected.white,
            selection: Expected.hoverBlue,
            underline: true,
            context: "primary/textLink/highlighted"
        )
        // disabled & loading share visuals
        assertPalette(
            pal(.primary, .textLink, .disabled),
            bg: Expected.white,
            border: Expected.white,
            selection: Expected.textGray60,
            underline: true,
            context: "primary/textLink/disabled"
        )
        assertPalette(
            pal(.primary, .textLink, .loading),
            bg: Expected.white,
            border: Expected.white,
            selection: Expected.textGray60,
            underline: true,
            context: "primary/textLink/loading"
        )
        assertPalette(
            pal(.primary, .textLink, .confirmed),
            bg: Expected.white,
            border: Expected.white,
            selection: Expected.green100,
            underline: true,
            context: "primary/textLink/confirmed"
        )

        // --- Secondary / Default ---
        assertPalette(
            pal(.secondary, .default, .normal),
            bg: Expected.white,
            border: Expected.darkBlue100,
            selection: Expected.darkBlue100,
            underline: false,
            context: "secondary/default/normal"
        )
        assertPalette(
            pal(.secondary, .default, .highlighted),
            bg: Expected.white,
            border: Expected.hoverBlue,
            selection: Expected.hoverBlue,
            underline: false,
            context: "secondary/default/highlighted"
        )
        // disabled & loading share visuals
        assertPalette(
            pal(.secondary, .default, .disabled),
            bg: Expected.white,
            border: Expected.textGray60,
            selection: Expected.textGray60,
            underline: false,
            context: "secondary/default/disabled"
        )
        assertPalette(
            pal(.secondary, .default, .loading),
            bg: Expected.white,
            border: Expected.textGray60,
            selection: Expected.textGray60,
            underline: false,
            context: "secondary/default/loading"
        )
        assertPalette(
            pal(.secondary, .default, .confirmed),
            bg: Expected.white,
            border: Expected.green100,
            selection: Expected.green100,
            underline: false,
            context: "secondary/default/confirmed"
        )

        // --- Secondary / TextLink (underline = false) ---
        assertPalette(
            pal(.secondary, .textLink, .normal),
            bg: Expected.white,
            border: Expected.white,
            selection: Expected.darkBlue100,
            underline: false,
            context: "secondary/textLink/normal"
        )
        assertPalette(
            pal(.secondary, .textLink, .highlighted),
            bg: Expected.white,
            border: Expected.white,
            selection: Expected.hoverBlue,
            underline: false,
            context: "secondary/textLink/highlighted"
        )
        // disabled & loading share visuals
        assertPalette(
            pal(.secondary, .textLink, .disabled),
            bg: Expected.white,
            border: Expected.white,
            selection: Expected.textGray60,
            underline: false,
            context: "secondary/textLink/disabled"
        )
        assertPalette(
            pal(.secondary, .textLink, .loading),
            bg: Expected.white,
            border: Expected.white,
            selection: Expected.textGray60,
            underline: false,
            context: "secondary/textLink/loading"
        )
        assertPalette(
            pal(.secondary, .textLink, .confirmed),
            bg: Expected.white,
            border: Expected.white,
            selection: Expected.green100,
            underline: false,
            context: "secondary/textLink/confirmed"
        )

        // --- Alternative / Default ---
        assertPalette(
            pal(.alternative, .default, .normal),
            bg: Expected.lightBlue100,
            border: Expected.lightBlue100,
            selection: Expected.white,
            underline: false,
            context: "alternative/default/normal"
        )
        // other alternative states alias primary default
        assertPalette(
            pal(.alternative, .default, .highlighted),
            bg: Expected.hoverBlue,
            border: Expected.hoverBlue,
            selection: Expected.white,
            underline: false,
            context: "alternative/default/highlighted"
        )
        assertPalette(
            pal(.alternative, .default, .disabled),
            bg: Expected.darkText60,
            border: Expected.darkText60,
            selection: Expected.white,
            underline: false,
            context: "alternative/default/disabled"
        )
        assertPalette(
            pal(.alternative, .default, .loading),
            bg: Expected.darkText60,
            border: Expected.darkText60,
            selection: Expected.white,
            underline: false,
            context: "alternative/default/loading"
        )
        assertPalette(
            pal(.alternative, .default, .confirmed),
            bg: Expected.green100,
            border: Expected.green100,
            selection: Expected.white,
            underline: false,
            context: "alternative/default/confirmed"
        )
    }

    // MARK: - Tests

    @Test("Light scheme palettes match expected tokens")
    func palettes_light() {
        runAllCases(scheme: .light)
    }

    @Test("Dark scheme palettes match expected tokens (currently mirrors light)")
    func palettes_dark() {
        runAllCases(scheme: .dark)
    }
}
