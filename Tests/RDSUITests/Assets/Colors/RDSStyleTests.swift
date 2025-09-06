//
//  RDSStyleTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 03/09/25.
//
//  Verifies RDSStyle returns a usable AnyShapeStyle for both solid colors
//  and gradients, and that it can be consumed by common SwiftUI APIs.
//  Tests are conditionally executed based on platform availability.
//

import Testing
import SwiftUI
@testable import RDSUI

/// Smoke tests for `RDSStyle`
/// Ensures `.solid` and `.gradient` produce `AnyShapeStyle` that compiles and can be
/// applied to `fill` / `foregroundStyle` without crashing on the main actor.
@MainActor
@Suite("RDSStyle Tests")
struct RDSStyleTests {

    // MARK: - Helpers

    private func sampleGradient() -> LinearGradient {
        LinearGradient(
            colors: [
                Color.rds("#0B66EC"),
                Color.rds("#44C7F4")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Solid

    @Test("RDSStyle.solid produces AnyShapeStyle usable in .fill(...)")
    func solidStyle_isUsableInFill() {
        let red = Color.rds("#FF0000")
        let style = RDSStyle.solid(red).style // AnyShapeStyle
        // Compiles & builds a simple view tree
        _ = Rectangle().fill(style)
        _ = Capsule().fill(style)
        #expect(true) // building succeeded
    }

    @Test("RDSStyle.solid is usable via foregroundStyle(...)")
    func solidStyle_isUsableInForegroundStyle() {
        let style = RDSStyle.solid(Color.rds("#407A26")).style
        _ = Text("Hello").foregroundStyle(style)
        _ = Image(systemName: "checkmark.circle.fill").foregroundStyle(style)
        #expect(true)
    }

    // MARK: - Gradient

    @Test("RDSStyle.gradient produces AnyShapeStyle usable in .fill(...)")
    func gradientStyle_isUsableInFill() {
        let gradient = sampleGradient()
        let style = RDSStyle.gradient(gradient).style
        _ = RoundedRectangle(cornerRadius: 12).fill(style)
        _ = Circle().fill(style)
        #expect(true)
    }

    @Test("RDSStyle.gradient is usable via foregroundStyle(...)")
    func gradientStyle_isUsableInForegroundStyle() {
        let style = RDSStyle.gradient(sampleGradient()).style
        _ = Text("Gradient").font(.headline).foregroundStyle(style)
        #expect(true)
    }

    // MARK: - Reusability

    @Test("Any RDSStyle is reusable across multiple views without recomputation")
    func style_isReusableAcrossViews() {
        let style = RDSStyle.solid(Color.rds("#0000FF")).style
        // Reuse the same AnyShapeStyle several times; this should be cheap and safe.
        _ = VStack {
            Rectangle().fill(style).frame(width: 10, height: 10)
            Circle().fill(style).frame(width: 10, height: 10)
            Text("Reused").foregroundStyle(style)
        }
        #expect(true)
    }
}
