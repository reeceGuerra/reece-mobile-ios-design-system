//
//  RDSTextStyleTokenTests.swift
//  RDSDesignSystem
//
//  Created by ChatGPT on 03/09/25.
//

import Testing
import SwiftUI
@testable import RDSUI

@Suite("RDSTextStyleToken")
struct RDSTextStyleTokenTests {

    @Test("All tokens yield a positive base point size and valid line-height multiple when present")
    func allTokensHaveConsistentSpecs() {
        for token in RDSTextStyleToken.allCases {
            let spec = token.spec
            let base = spec.basePointSize(usingScale: 1.0)
            #expect(base > 0, "Token \(token) should yield a positive base point size")

            if let m = spec.lineHeightMultiple() {
                #expect(m > 0, "Token \(token) should have a positive line-height multiple when provided")
            }
        }
    }

    @Test("buttonM: size/weight/line-height/letter-spacing mapping")
    func buttonM_mapping() {
        let spec = RDSTextStyleToken.buttonM.spec

        // size px -> pt (scale 1.0)
        let base = spec.basePointSize(usingScale: 1.0)
        let tol: CGFloat = 0.0001
        #expect(abs(base - 16.0) <= tol)

        // weight
        #expect(spec.weight == .weight(500))

        // line height multiple: 24 / 16 = 1.5
        let m = spec.lineHeightMultiple()
        #expect(m != nil)
        #expect(abs(m! - 1.5) <= tol)

        // letter spacing percent
        #expect(spec.letterSpacingPercent == 0.5)
    }

    @Test("buttonS: size/weight/line-height/letter-spacing mapping")
    func buttonS_mapping() {
        let spec = RDSTextStyleToken.buttonS.spec

        // size px -> pt (scale 1.0)
        let base = spec.basePointSize(usingScale: 1.0)
        let tol: CGFloat = 0.0001
        #expect(abs(base - 14.0) <= tol)

        // weight
        #expect(spec.weight == .weight(500))

        // line height multiple: 22 / 14 ≈ 1.5714
        let m = spec.lineHeightMultiple()
        #expect(m != nil)
        #expect(abs(m! - (22.0/14.0)) <= tol)

        // letter spacing percent
        #expect(spec.letterSpacingPercent == 0.5)
    }

    @Test("H1 variants share size but differ in weight")
    func h1_variants_weightDifferences() {
        let b = RDSTextStyleToken.h1B.spec
        let m = RDSTextStyleToken.h1M.spec
        let r = RDSTextStyleToken.h1R.spec

        // same base size
        let tol: CGFloat = 0.0001
        #expect(abs(b.basePointSize(usingScale: 1.0) - m.basePointSize(usingScale: 1.0)) <= tol)
        #expect(abs(b.basePointSize(usingScale: 1.0) - r.basePointSize(usingScale: 1.0)) <= tol)

        // different weights
        #expect(b.weight == .weight(700))
        #expect(m.weight == .weight(500))
        #expect(r.weight == .weight(400))
    }
}
