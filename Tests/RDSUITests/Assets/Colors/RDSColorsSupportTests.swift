//
//  RDSColorsSupportTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 30/08/25.
//

import Testing
import SwiftUI
@testable import RDSUI

/// Support palette tests for Green, OrangyRed, Yellow, Teal, SkyBlue, Purple, and single-tone HoverBlue.
/// Ensures every tone resolves to a non-clear color in both color schemes and HEX is well-formed.
@MainActor
@Suite("RDSColors Support Tests")
struct RDSColorsSupportTests {

    // MARK: - Helpers

    /// Returns HEX string (#RRGGBBAA) or "#NA" if conversion is unavailable.
    private func hex(_ color: Color) -> String {
        RDSColorExport.hex(from: color, includeAlpha: true) ?? "#NA"
    }

    private func isValidHex9(_ s: String) -> Bool {
        guard s.count == 9, s.first == "#" else { return false }
        return s.dropFirst().allSatisfy { ("0"..."9").contains($0) || ("a"..."f").contains($0) || ("A"..."F").contains($0) }
    }

    /// Asserts that producer(.light) and producer(.dark) yield non-clear, HEX-convertible colors.
    private func expectNonClearBothSchemes(_ colorProducer: (ColorScheme) -> Color, context: String) {
        let light = hex(colorProducer(.light))
        let dark  = hex(colorProducer(.dark))
        #expect(light != "#00000000" && isValidHex9(light), "\(context) (light) → \(light)")
        #expect(dark  != "#00000000" && isValidHex9(dark),  "\(context) (dark) → \(dark)")
    }

    // MARK: - Green

    @Test("All Green tones resolve (light & dark)")
    func green_allTones() {
        for tone in RDSColors.support.Green.Tone.allCases {
            expectNonClearBothSchemes({ scheme in
                RDSColors.support.Green.color(tone, using: scheme)
            }, context: "Support.Green.\(tone)")
        }
    }

    // MARK: - OrangyRed

    @Test("All OrangyRed tones resolve (light & dark)")
    func orangyRed_allTones() {
        for tone in RDSColors.support.OrangyRed.Tone.allCases {
            expectNonClearBothSchemes({ scheme in
                RDSColors.support.OrangyRed.color(tone, using: scheme)
            }, context: "Support.OrangyRed.\(tone)")
        }
    }

    // MARK: - Yellow

    @Test("All Yellow tones resolve (light & dark)")
    func yellow_allTones() {
        for tone in RDSColors.support.Yellow.Tone.allCases {
            expectNonClearBothSchemes({ scheme in
                RDSColors.support.Yellow.color(tone, using: scheme)
            }, context: "Support.Yellow.\(tone)")
        }
    }

    // MARK: - Teal

    @Test("All Teal tones resolve (light & dark)")
    func teal_allTones() {
        for tone in RDSColors.support.Teal.Tone.allCases {
            expectNonClearBothSchemes({ scheme in
                RDSColors.support.Teal.color(tone, using: scheme)
            }, context: "Support.Teal.\(tone)")
        }
    }

    // MARK: - SkyBlue

    @Test("All SkyBlue tones resolve (light & dark)")
    func skyBlue_allTones() {
        for tone in RDSColors.support.SkyBlue.Tone.allCases {
            expectNonClearBothSchemes({ scheme in
                RDSColors.support.SkyBlue.color(tone, using: scheme)
            }, context: "Support.SkyBlue.\(tone)")
        }
    }

    // MARK: - Purple

    @Test("All Purple tones resolve (light & dark)")
    func purple_allTones() {
        for tone in RDSColors.support.Purple.Tone.allCases {
            expectNonClearBothSchemes({ scheme in
                RDSColors.support.Purple.color(tone, using: scheme)
            }, context: "Support.Purple.\(tone)")
        }
    }

    // MARK: - Single-tone

    @Test("HoverBlue resolves (light & dark)")
    func hoverBlue_singleTone() {
        expectNonClearBothSchemes({ scheme in
            RDSColors.support.HoverBlue.color(using: scheme)
        }, context: "Support.HoverBlue")
    }
}
