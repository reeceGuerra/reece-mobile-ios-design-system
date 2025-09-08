//
//  RDSButtonTokensInvariantTests.swift
//  RDSUI
//
//  Created by Carlos Lopez on 08/09/25.
//


//
//  RDSButtonTokensInvariantTests.swift
//  RDSUI
//
//  Created by Carlos Lopez on 08/09/25.
//

import Testing
import SwiftUI
@testable import RDSUI

/// Invariant unit tests for `RDSButtonTokensPaletteProvider`.
/// These tests are **pure** (no UI hosting) and validate semantic rules
/// that should hold across themes and states (light/dark).
@MainActor
@Suite("RDSButtonTokensInvariant Tests")
struct RDSButtonTokensInvariantTests {

    // MARK: - Helpers

    /// Creates a palette provider for the given color scheme.
    /// - Parameter scheme: The `ColorScheme` to resolve tokens (light/dark).
    /// - Returns: A `RDSButtonTokensPaletteProvider` bound to `scheme`.
    private func provider(_ scheme: ColorScheme) -> RDSButtonTokensPaletteProvider {
        .init(scheme: scheme)
    }

    /// Converts a SwiftUI `Color` into a hex string for comparison.
    /// - Parameter color: The `Color` to export as `#RRGGBBAA`.
    /// - Returns: A `String` with the hex value or `#NA` if export fails.
    private func hexRGBA(_ color: Color) -> String {
        RDSColorExport.hex(from: color, includeAlpha: true) ?? "#NA"
    }

    // MARK: - Tests

    /// Verifies TextLink keeps underline enabled across states for primary variant.
    /// - Note: Runs on light and dark schemes.
    @Test("Primary/TextLink uses underline across states (light/dark)")
    func primary_textLink_underline_allStates() {
        for scheme in [ColorScheme.light, .dark] {
            let p = provider(scheme)
            for state in [RDSButtonState.normal, .highlighted, .disabled, .confirmed] {
                let palette = p.palette(for: .primary, type: .textLink, state: state)
                #expect(palette.underline == true, "Expected underline=true for TextLink, state=\\(state), scheme=\\(scheme)")
            }
        }
    }

    /// Verifies Default type does not use underline across states for primary variant.
    /// - Note: Runs on light and dark schemes.
    @Test("Primary/Default does not use underline across states (light/dark)")
    func primary_default_noUnderline_allStates() {
        for scheme in [ColorScheme.light, .dark] {
            let p = provider(scheme)
            for state in [RDSButtonState.normal, .highlighted, .disabled, .confirmed] {
                let palette = p.palette(for: .primary, type: .default, state: state)
                #expect(palette.underline == false, "Expected underline=false for Default, state=\\(state), scheme=\\(scheme)")
            }
        }
    }

    /// Validates that highlighted state changes bg/border compared to normal (primary/default).
    /// - Note: Runs on light and dark schemes.
    @Test("Primary/Default: background and border change on highlighted (light/dark)")
    func primary_default_bgBorder_changes_onHighlighted() {
        for scheme in [ColorScheme.light, .dark] {
            let p = provider(scheme)
            let normal = p.palette(for: .primary, type: .default, state: .normal)
            let highlighted = p.palette(for: .primary, type: .default, state: .highlighted)

            #expect(hexRGBA(normal.backgroundColor) != hexRGBA(highlighted.backgroundColor), "Expected bg to differ on highlighted (scheme=\\(scheme))")
            #expect(hexRGBA(normal.borderColor)     != hexRGBA(highlighted.borderColor),     "Expected border to differ on highlighted (scheme=\\(scheme))")
        }
    }

    /// Validates that highlighted selection for primary/textLink is HoverBlue from tokens.
    /// - Note: Runs on light and dark schemes.
    @Test("Primary/TextLink: selectionColor is HoverBlue in highlighted (light/dark)")
    func primary_textLink_selection_is_hoverBlue_onHighlighted() {
        for scheme in [ColorScheme.light, .dark] {
            let p = provider(scheme)
            let highlighted = p.palette(for: .primary, type: .textLink, state: .highlighted)
            let expected = RDSColors.support.HoverBlue.color(using: scheme)
            #expect(hexRGBA(highlighted.selectionColor) == hexRGBA(expected), "Expected HoverBlue selection on highlighted TextLink (scheme=\\(scheme))")
        }
    }

    /// Validates that confirmed background/border for primary/default uses Green(t100).
    /// - Note: Runs on light and dark schemes.
    @Test("Primary/Default: confirmed uses Green(t100) background (light/dark)")
    func primary_default_confirmed_background_is_green100() {
        for scheme in [ColorScheme.light, .dark] {
            let p = provider(scheme)
            let confirmed = p.palette(for: .primary, type: .default, state: .confirmed)
            let expected = RDSColors.support.Green.color(.t100, using: scheme)
            #expect(hexRGBA(confirmed.backgroundColor) == hexRGBA(expected), "Expected Green(t100) bg on confirmed Default (scheme=\\(scheme))")
            #expect(hexRGBA(confirmed.borderColor)     == hexRGBA(expected), "Expected Green(t100) border on confirmed Default (scheme=\\(scheme))")
        }
    }

    /// Validates that confirmed selection for primary/textLink uses Green(t100).
    /// - Note: Runs on light and dark schemes.
    @Test("Primary/TextLink: confirmed uses Green(t100) selection (light/dark)")
    func primary_textLink_confirmed_selection_is_green100() {
        for scheme in [ColorScheme.light, .dark] {
            let p = provider(scheme)
            let confirmed = p.palette(for: .primary, type: .textLink, state: .confirmed)
            let expected = RDSColors.support.Green.color(.t100, using: scheme)
            #expect(hexRGBA(confirmed.selectionColor) == hexRGBA(expected), "Expected Green(t100) selection on confirmed TextLink (scheme=\\(scheme))")
        }
    }
}
