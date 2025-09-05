//
//  RDSColorExportTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 31/08/25.
//


import XCTest
import SwiftUI
@testable import RDSUI

final class RDSColorExportTests: XCTestCase {

    func testHexRoundTrip_RGB_NoAlpha() {
        let original = "#407A26" // sample de tu paleta (Green 100)
        let color = Color(hex: original) // ya existente en tu package
        let hex = RDSColorExport.hexString(for: color, includeAlpha: false)

        XCTAssertNotNil(hex)
        XCTAssertEqual(hex, original.uppercased())
    }

    func testHexRoundTrip_RGBA_WithAlpha() {
        let original = "#FF00FF80" // fucsia 50% alpha
        let color = Color(hex: original)
        let hex = RDSColorExport.hexString(for: color, includeAlpha: true)

        XCTAssertNotNil(hex)
        XCTAssertEqual(hex, original.uppercased())
    }

    func testSchemeAwareExport_UsesProvidedScheme() {
        // Simula dos colores distintos para Light/Dark (ejemplo simple)
        // En tu caso real vendrán de RDSColors.pick(using:)
        let light = Color(hex: "#FFFFFF")
        let dark  = Color(hex: "#000000")

        // Si pides scheme .light, debe exportar blanco
        XCTAssertEqual(RDSColorExport.hexString(for: light, scheme: .light), "#FFFFFF")
        // Si pides scheme .dark, debe exportar negro
        XCTAssertEqual(RDSColorExport.hexString(for: dark, scheme: .dark), "#000000")
    }
}
