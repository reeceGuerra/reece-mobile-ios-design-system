//
//  RDSColorHexTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 30/08/25.
//


import XCTest
@testable import RDSUI

final class RDSColorHexTests: XCTestCase {

    func testHexInvalidLengths() {
        XCTAssertThrowsError(try HexColorParser.rgba(from: "")) { error in
            XCTAssertEqual(error as? HexColorError, .invalidLength(actual: 0))
        }
        XCTAssertThrowsError(try HexColorParser.rgba(from: "#12")) { error in
            XCTAssertEqual(error as? HexColorError, .invalidLength(actual: 2))
        }
        XCTAssertThrowsError(try HexColorParser.rgba(from: "#12345")) { error in
            XCTAssertEqual(error as? HexColorError, .invalidLength(actual: 5))
        }
    }

    func testHexInvalidScan() {
        XCTAssertThrowsError(try HexColorParser.rgba(from: "#GGHHII")) { error in
            XCTAssertEqual(error as? HexColorError, .invalidScan("GGHHII"))
        }
    }

    func testHexValidRGB() throws {
        let c = try HexColorParser.rgba(from: "#0859A8") // ejemplo
        XCTAssertEqual(c.a, 1.0, accuracy: 0.0001)
    }

    func testHexValidRGBA() throws {
        let c = try HexColorParser.rgba(from: "#0859A8FF")
        XCTAssertEqual(c.a, 1.0, accuracy: 0.0001)
    }
}
