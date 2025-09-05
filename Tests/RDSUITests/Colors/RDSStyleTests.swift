//
//  RDSStyleTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 03/09/25.
//


//
//  RDSStyleTests.swift
//  RDSDesignSystemTests
//
//  Verifies RDSStyle returns a usable AnyShapeStyle for both solid colors
//  and gradients, and that it can be consumed by common SwiftUI APIs.
//  Tests are conditionally executed based on platform availability.
//

import XCTest
import SwiftUI
@testable import RDSUI

final class RDSStyleTests: XCTestCase {

    func test_solid_produces_AnyShapeStyle_and_is_fillable() throws {
        #if os(iOS) || os(macOS)
        if #available(iOS 17, macOS 14, *) {
            let style = RDSStyle.solid(.red).style
            // Type check
            XCTAssertTrue(type(of: style) == AnyShapeStyle.self)

            // Ensure it can be consumed by SwiftUI fill APIs
            let _ = Rectangle().fill(style)
            let _ = Text("Solid").foregroundStyle(style)
        } else {
            throw XCTSkip("Requires iOS 17 or macOS 14 (AnyShapeStyle)")
        }
        #else
        throw XCTSkip("RDSStyle tests only run on iOS/macOS platforms.")
        #endif
    }

    func test_gradient_produces_AnyShapeStyle_and_is_fillable() throws {
        #if os(iOS) || os(macOS)
        if #available(iOS 17, macOS 14, *) {
            let gradient = LinearGradient(colors: [.blue, .green],
                                          startPoint: .topLeading,
                                          endPoint: .bottomTrailing)
            let style = RDSStyle.gradient(gradient).style
            XCTAssertTrue(type(of: style) == AnyShapeStyle.self)

            let _ = RoundedRectangle(cornerRadius: 8).fill(style)
            let _ = Text("Gradient").foregroundStyle(style)
        } else {
            throw XCTSkip("Requires iOS 17 or macOS 14 (AnyShapeStyle)")
        }
        #else
        throw XCTSkip("RDSStyle tests only run on iOS/macOS platforms.")
        #endif
    }
}
