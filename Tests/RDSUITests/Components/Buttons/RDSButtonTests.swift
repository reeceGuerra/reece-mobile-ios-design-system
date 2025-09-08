//
//  RDSButtonTests.swift
//  RDSUI
//
//  Created by Carlos Lopez on 06/09/25.
//

import Testing
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

@testable import RDSUI

/// Unit tests for `RDSButton` and its press/hover/focus mapping.
/// These tests avoid UI snapshots and rely on pure helpers and smoke builds.
@MainActor
@Suite("RDSButton Tests")
struct RDSButtonTests {

    // MARK: - Helpers

    /// Builds a synthetic palette for testing non-UI logic.
    /// The exact color values are irrelevant for these tests; we only need non-nil colors.
    private func testPalette() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: Color.rds("#0057B8"),
            borderColor:     Color.rds("#003766"),
            selectionColor:  Color.rds("#FFFFFF"),
            underline: false
        )
    }

    /// Creates a button with default providers (real tokens) for smoke builds.
    private func makeButton(
        title: String = "Continue",
        variant: RDSButtonVariant = .primary,
        type: RDSButtonType = .default,
        size: RDSButtonSize = .default,
        state: RDSButtonState = .normal,
        icon: Image? = nil
    ) -> RDSButton {
        RDSButton(
            title: title,
            variant: variant,
            type: type,
            size: size,
            state: state,
            icon: icon,
            paletteProvider: RDSButtonTokensPaletteProvider(),
            typographyProvider: RDSButtonTypographyTokens(),
            action: { }
        )
    }

    // MARK: - Smoke tests (no UI assertions)

    /// Ensures all sizes report a non-zero height.
    @Test("Button dimensions expose non-zero heights for all sizes")
    func dimensions_nonZeroHeight() {
        for s in [RDSButtonSize.small, .default, .large, .iconLeft, .iconRight] {
            let d = RDSButton.dimensions(for: s)
            #expect(d.height > 0, "Height should be > 0 for \\(s)")
        }
    }

    /// Ensures the shared content renderer builds for all sizes (executes the layout path).
    @Test("content(palette:) builds for all sizes")
    func content_builds_forAllSizes() {
        let p = testPalette()
        for s in [RDSButtonSize.small, .default, .large, .iconLeft, .iconRight] {
            let btn = makeButton(
                size: s,
                icon: (s == .iconLeft || s == .iconRight) ? Image(systemName: "arrow.right") : nil
            )
            _ = btn.content(palette: p)
        }
        #expect(true)
    }

    /// Ensures SwiftUI can build the body for representative combinations.
    #if canImport(UIKit)
    @Test("Body builds without crash for common variant/type/state combinations")
    func body_builds_inHostingController() {
        let configs: [(RDSButtonVariant, RDSButtonType, RDSButtonState, RDSButtonSize)] = [
            (.primary, .default, .normal, .default),
            (.primary, .default, .disabled, .default),
            (.secondary, .default, .loading, .large),
            (.alternative, .textLink, .confirmed, .small),
            (.primary, .default, .normal, .iconLeft),
            (.primary, .default, .normal, .iconRight)
        ]
        for (v,t,st,sz) in configs {
            let btn = makeButton(
                variant: v, type: t, size: sz, state: st,
                icon: (sz == .iconLeft || sz == .iconRight) ? Image(systemName: "arrow.right") : nil
            )
            let host = UIHostingController(rootView: btn)
            #expect(host.view != nil)
        }
    }
    #endif

    /// Ensures disabled/loading still build content safely.
    @Test("Disabled and Loading states still build content safely")
    func disabled_loading_build() {
        for state in [RDSButtonState.disabled, .loading] {
            let btn = makeButton(state: state)
            #if canImport(UIKit)
            let host = UIHostingController(rootView: btn)
            #expect(host.view != nil)
            #else
            _ = btn.body
            #expect(true)
            #endif
        }
    }

    // MARK: - Effective state mapping (pure, unit-only)

    /// On non-macOS platforms, only `isPressed` should switch to `.highlighted`
    /// when `externalState == .normal`. Hover/focus are ignored.
    @Test("iOS/tvOS/watchOS: effective state honors pressed only (normal -> highlighted)")
    func mapping_nonMac_pressedOnly() {
        #if !os(macOS)
        // Normal + not pressed -> normal
        #expect(RDSPressAwareButtonStyle.mapEffectiveState(
            externalState: .normal, isPressed: false, isHovered: true, isFocused: true, isInteractive: true
        ) == .normal)

        // Normal + pressed -> highlighted
        #expect(RDSPressAwareButtonStyle.mapEffectiveState(
            externalState: .normal, isPressed: true, isHovered: false, isFocused: false, isInteractive: true
        ) == .highlighted)

        // Non-interactive ignores pressed
        for st in [RDSButtonState.disabled, .loading] {
            #expect(RDSPressAwareButtonStyle.mapEffectiveState(
                externalState: st, isPressed: true, isHovered: true, isFocused: true, isInteractive: false
            ) == st)
        }

        // Confirmed must not change
        #expect(RDSPressAwareButtonStyle.mapEffectiveState(
            externalState: .confirmed, isPressed: true, isHovered: true, isFocused: true, isInteractive: true
        ) == .confirmed)
        #else
        // Not applicable on macOS
        #expect(true)
        #endif
    }

    /// On macOS, `pressed` OR `hovered` OR `focused` should switch to `.highlighted`
    /// when `externalState == .normal`.
    @Test("macOS: effective state honors pressed/hovered/focused (normal -> highlighted)")
    func mapping_mac_pressedHoverFocus() {
        #if os(macOS)
        // Normal + none -> normal
        #expect(RDSPressAwareButtonStyle.mapEffectiveState(
            externalState: .normal, isPressed: false, isHovered: false, isFocused: false, isInteractive: true
        ) == .normal)

        // Pressed
        #expect(RDSPressAwareButtonStyle.mapEffectiveState(
            externalState: .normal, isPressed: true, isHovered: false, isFocused: false, isInteractive: true
        ) == .highlighted)

        // Hovered
        #expect(RDSPressAwareButtonStyle.mapEffectiveState(
            externalState: .normal, isPressed: false, isHovered: true, isFocused: false, isInteractive: true
        ) == .highlighted)

        // Focused
        #expect(RDSPressAwareButtonStyle.mapEffectiveState(
            externalState: .normal, isPressed: false, isHovered: false, isFocused: true, isInteractive: true
        ) == .highlighted)

        // Non-interactive ignores flags
        for st in [RDSButtonState.disabled, .loading] {
            #expect(RDSPressAwareButtonStyle.mapEffectiveState(
                externalState: st, isPressed: true, isHovered: true, isFocused: true, isInteractive: false
            ) == st)
        }

        // Confirmed must not change
        #expect(RDSPressAwareButtonStyle.mapEffectiveState(
            externalState: .confirmed, isPressed: true, isHovered: true, isFocused: true, isInteractive: true
        ) == .confirmed)
        #else
        // Not applicable outside macOS
        #expect(true)
        #endif
    }
}
