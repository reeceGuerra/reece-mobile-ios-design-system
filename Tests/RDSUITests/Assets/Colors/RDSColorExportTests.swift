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
        let color = Color(original) // ya existente en tu package
        let hex = RDSColorExport.hex(from: color, includeAlpha: false)

        XCTAssertNotNil(hex)
        XCTAssertEqual(hex, original.uppercased())
    }

    func testHexRoundTrip_RGBA_WithAlpha() {
        let original = "#FF00FF80" // fucsia 50% alpha
        let color = Color(original)
        let hex = RDSColorExport.hex(from: color, includeAlpha: true)

        XCTAssertNotNil(hex)
        XCTAssertEqual(hex, original.uppercased())
    }
}
