//
//  ReeceColorContrastTests.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 31/08/25.
//

import XCTest
import SwiftUI
@testable import RDSUI

final class ReeceColorContrastTests: XCTestCase {
    
    // Helper: HEX de un Color (sin alpha)
    private func hex(_ c: Color) -> String {
        ReeceColorExport.hexString(for: c, includeAlpha: false) ?? "NIL"
    }
    
    func testPreferredLabelColor_onWhiteBackground_returnsBlack() {
        let label = ReeceColorContrast.onColor(for: Color(hex: "#FFFFFF"))
        XCTAssertEqual(hex(label), "#000000", "Sobre blanco debe escoger negro")
    }
    
    func testPreferredLabelColor_onBlackBackground_returnsWhite() {
        let label = ReeceColorContrast.onColor(for: Color(hex: "#000000"))
        XCTAssertEqual(hex(label), "#FFFFFF", "Sobre negro debe escoger blanco")
    }
    
    func testPreferredLabelColor_thresholdOverridesDecision() {
        // Gris medio; por defecto debería dar negro
        let gray = Color(hex: "#BBBBBB")
        XCTAssertEqual(hex(ReeceColorContrast.onColor(for: gray)), "#000000")
        
        // Con threshold alto, forzamos blanco
        let forcedWhite = ReeceColorContrast.onColor(for: gray, threshold: 0.90)
        XCTAssertEqual(hex(forcedWhite), "#FFFFFF")
    }
    
    func testPreferredLabelColor_ignoresAlphaComponentForContrast() {
        // Mismo color con alpha distinto → mismo label
        let solid = Color(hex: "#407A26FF")
        let translucent = Color(hex: "#407A2680")
        let l1 = ReeceColorContrast.onColor(for: solid)
        let l2 = ReeceColorContrast.onColor(for: translucent)
        XCTAssertEqual(hex(l1), hex(l2))
    }
    
    func testPreferredLabelColor_neverMatchesBackgroundExactly() {
        // Muestras reales de la paleta (puedes ajustar/añadir)
        let samples = ["#407A26", "#024E8E", "#8C44EF", "#FAEAE8", "#ECF2E9"]
        
        for s in samples {
            let bg = Color(hex: s)
            let label = ReeceColorContrast.onColor(for: bg)
            XCTAssertNotEqual(
                hex(label), s.uppercased(),
                "El label no debería ser idéntico al background \(s)"
            )
        }
    }
    
    func testPreferredLabelColor_acceptsExplicitScheme() {
        // Un color cualquiera; el objetivo es cubrir la ruta con scheme .light/.dark
        let bg = Color(hex: "#3E5479")
        
        let labelDark  = ReeceColorContrast.onColor(for: bg, scheme: .dark)
        let labelLight = ReeceColorContrast.onColor(for: bg, scheme: .light)
        
        // Afirmaciones suaves: que devuelva HEX válido
        XCTAssertNotEqual(hex(labelDark), "NIL")
        XCTAssertNotEqual(hex(labelLight), "NIL")
    }
}
