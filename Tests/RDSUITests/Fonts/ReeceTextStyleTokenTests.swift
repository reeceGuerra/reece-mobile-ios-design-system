//
//  ReeceTextStyleTokenTests.swift
//  ReeceDesignSystem
//
//  Created by ChatGPT on 03/09/25.
//

import XCTest
import SwiftUI
@testable import RDSUI

final class ReeceTextStyleTokenTests: XCTestCase {

    func testAllTokensHaveConsistentSpecs() {
        for token in ReeceTextStyleToken.allCases {
            let spec = token.spec
            // Base size should be positive given a design size
            let base = spec.basePointSize(usingScale: 1.0)
            XCTAssertGreaterThan(base, 0, "Token \(token) should yield a positive base point size")
            // If both px values exist, multiple should be > 0
            if let m = spec.lineHeightMultiple() {
                XCTAssertGreaterThan(m, 0.0, "Token \(token) should have a positive line-height multiple when provided")
            }
        }
    }
}