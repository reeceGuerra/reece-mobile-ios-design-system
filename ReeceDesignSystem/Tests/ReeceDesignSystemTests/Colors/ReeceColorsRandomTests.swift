import XCTest
import SwiftUI
@testable import ReeceDesignSystem

final class ReeceColorsRandomTests: XCTestCase {

    // MARK: - Helpers

    /// Convierte un `SwiftUI.Color` a RGBA (device RGB) para poder compararlo en tests.
    private func rgba(_ color: Color) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {
        #if canImport(UIKit)
        import UIKit
        let ui = UIColor(color)
        guard let rgb = ui.cgColor.converted(to: CGColorSpaceCreateDeviceRGB(),
                                             intent: .defaultIntent,
                                             options: nil) else { return nil }
        let comps = rgb.components ?? []
        // cgColor puede venir con 2 (grayscale) o 4 componentes
        if comps.count == 4 {
            return (comps[0], comps[1], comps[2], comps[3])
        } else if comps.count == 2 {
            return (comps[0], comps[0], comps[0], comps[1])
        } else {
            return nil
        }
        #elseif canImport(AppKit)
        import AppKit
        let ns = NSColor(color)
        guard let rgb = ns.usingColorSpace(.deviceRGB) else { return nil }
        return (rgb.redComponent, rgb.greenComponent, rgb.blueComponent, rgb.alphaComponent)
        #else
        return nil
        #endif
    }

    /// Redondea componentes para evitar ruido de punto flotante al comparar.
    private func quantize(_ rgba: (CGFloat, CGFloat, CGFloat, CGFloat), places: Int = 3)
    -> (Int, Int, Int, Int) {
        func q(_ x: CGFloat) -> Int {
            let p = pow(10.0, Double(places))
            return Int((Double(x) * p).rounded())
        }
        return (q(rgba.0), q(rgba.1), q(rgba.2), q(rgba.3))
    }

    // MARK: - Tests

    @MainActor
    func test_random_returnsOpaqueColor_inLight() {
        let c = ReeceColors.random(using: .light)
        guard let comps = rgba(c) else {
            XCTFail("Could not extract RGBA from random color (light).")
            return
        }
        XCTAssertGreaterThan(comps.a, 0.0, "Expected non-transparent color (light).")
    }

    @MainActor
    func test_random_returnsOpaqueColor_inDark() {
        let c = Reec
