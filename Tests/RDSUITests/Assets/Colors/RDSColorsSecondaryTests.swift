//
//  Test.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 30/08/25.
//

import Testing
import SwiftUI
@testable import RDSUI

/// Secondary palette tests for Orange, TextGray, MediumGrey, LightGray and single-tone colors.
/// Ensures every tone resolves to a non-clear color in both color schemes and HEX is well-formed.
@MainActor
@Suite("RDSColors Secondary Tests")
struct RDSColorsSecondaryTests {

    // MARK: - Helpers

    /// Returns HEX string (#RRGGBBAA) or "#NA" if conversion is unavailable.
    private func hex(_ color: Color) -> String {
        RDSColorExport.hex(from: color, includeAlpha: true) ?? "#NA"
    }

    private func isValidHex9(_ s: String) -> Bool {
        guard s.count == 9, s.first == "#" else { return false }
        return s.dropFirst().allSatisfy { ("0"..."9").contains($0) || ("a"..."f").contains($0) || ("A"..."F").contains($0) }
    }

    private func expectNonClearBothSchemes(_ colorProducer: (ColorScheme) -> Color, file: StaticString = #fileID, line: UInt = #line) {
        let light = hex(colorProducer(.light))
        let dark  = hex(colorProducer(.dark))
        // Conversion should be available and not clear
        #expect(light != "#00000000" && isValidHex9(light), "\(light) should be non-clear HEX", sourceLocation: .init(fileID: file, line: line))
        #expect(dark  != "#00000000" && isValidHex9(dark),  "\(dark) should be non-clear HEX",  sourceLocation: .init(fileID: file, line: line))
    }

    // MARK: - Orange

    @Test("All Orange tones resolve (light & dark)")
    func orange_allTones() {
        for tone in RDSColors.secondary.Orange.Tone.allCases {
            expectNonClearBothSchemes { scheme in
                RDSColors.secondary.Orange.color(tone, using: scheme)
            }
        }
    }

    // MARK: - TextGray

    @Test("All TextGray tones resolve (light & dark)")
    func textGray_allTones() {
        for tone in RDSColors.secondary.TextGray.Tone.allCases {
            expectNonClearBothSchemes { scheme in
                RDSColors.secondary.TextGray.color(tone, using: scheme)
            }
        }
    }

    // MARK: - MediumGrey

    @Test("All MediumGrey tones resolve (light & dark)")
    func mediumGrey_allTones() {
        for tone in RDSColors.secondary.MediumGrey.Tone.allCases {
            expectNonClearBothSchemes { scheme in
                RDSColors.secondary.MediumGrey.color(tone, using: scheme)
            }
        }
    }

    // MARK: - LightGray

    @Test("All LightGray tones resolve (light & dark)")
    func lightGray_allTones() {
        for tone in RDSColors.secondary.LightGray.Tone.allCases {
            expectNonClearBothSchemes { scheme in
                RDSColors.secondary.LightGray.color(tone, using: scheme)
            }
        }
    }

    // MARK: - Single-tone colors

    @Test("White resolves (light & dark)")
    func white_singleTone() {
        expectNonClearBothSchemes { scheme in
            RDSColors.secondary.White.color(using: scheme)
        }
    }

    @Test("OffWhite resolves (light & dark)")
    func offWhite_singleTone() {
        expectNonClearBothSchemes { scheme in
            RDSColors.secondary.OffWhite.color(using: scheme)
        }
    }

    @Test("Black resolves (light & dark)")
    func black_singleTone() {
        expectNonClearBothSchemes { scheme in
            RDSColors.secondary.Black.color(using: scheme)
        }
    }
}
