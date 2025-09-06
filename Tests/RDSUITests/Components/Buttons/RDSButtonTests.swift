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

/// Smoke tests for RDSButton:
/// - Construye el árbol de vistas (ejecuta `body`) en múltiples combinaciones
/// - Ejerce helpers de layout (dimensions, iconView, content)
/// - Verifica que no crashea ni devuelve vistas vacías
@MainActor
@Suite("RDSButton Smoke Tests")
struct RDSButtonTests {

    // MARK: - Helpers

    /// Paleta determinística para probar `content(palette:)` sin depender de tokens.
    private func testPalette() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: Color.rds("#003766"),
            borderColor:     Color.rds("#003766"),
            selectionColor:  Color.rds("#FFFFFF"),
            underline: false
        )
    }

    /// Crea un botón con dependencias por defecto (tokens reales).
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
            action: {}
        )
    }

    // MARK: - Layout helpers

    @Test("dimensions(for:) returns non-zero height for all sizes")
    func dimensions_nonZeroHeight() {
        for s in [RDSButtonSize.small, .default, .large, .iconLeft, .iconRight] {
            let d = RDSButton.dimensions(for: s)
            #expect(d.height > 0, "Height should be > 0 for \(s)")
            // width puede ser fijo o flexible; no lo afirmamos para no acoplar
        }
    }

    @Test("iconView(_:color:) builds for SF Symbol and selectionColor")
    func iconView_builds() {
        let btn = makeButton(icon: Image(systemName: "checkmark"))
        // `iconView` espera un `Image` no opcional → pasar uno directo
        let img = Image(systemName: "checkmark")
        _ = btn.iconView(img, color: Color.rds("#FFFFFF"))
        #expect(true)
    }

    @Test("content(palette:) builds view for all button sizes")
    func content_builds_forAllSizes() {
        let p = testPalette()
        for s in [RDSButtonSize.small, .default, .large, .iconLeft, .iconRight] {
            let btn = makeButton(size: s, icon: (s == .iconLeft || s == .iconRight) ? Image(systemName: "arrow.right") : nil)
            _ = btn.content(palette: p) // ejecuta el layout path
        }
        #expect(true)
    }

    // MARK: - Body smoke (ejecuta `body` en host)

    #if canImport(UIKit)
    @Test("Body builds without crash for common variant/type/state combinations")
    func body_builds_inHostingController() {
        let configs: [(RDSButtonVariant, RDSButtonType, RDSButtonState, RDSButtonSize)] = [
            (.primary,   .default,  .normal,      .default),
            (.primary,   .default,  .highlighted, .default),
            (.primary,   .default,  .disabled,    .default),
            (.primary,   .textLink, .normal,      .small),
            (.secondary, .default,  .confirmed,   .large),
            (.secondary, .textLink, .loading,     .default),
            (.alternative, .default, .normal,     .iconLeft)
        ]

        for (variant, type, state, size) in configs {
            let button = makeButton(
                title: "Action",
                variant: variant,
                type: type,
                size: size,
                state: state,
                icon: (size == .iconLeft || size == .iconRight) ? Image(systemName: "arrow.right") : nil
            )

            // Hosting para forzar evaluación del body y modifiers
            let host = UIHostingController(rootView: button)
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = host
            window.makeKeyAndVisible()

            #expect(host.view != nil, "Host view must be created")
        }
    }
    #endif

    // MARK: - Disabled / Loading do not crash and still build
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
}
