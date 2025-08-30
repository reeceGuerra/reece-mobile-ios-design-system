//
//  ReeceColors.Secondary.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 30/08/25.
//

import SwiftUI

public extension ReeceColors {
    /// Value-namespace for the **Secondary** color family.
    ///
    /// Example:
    /// ```swift
    /// // Orange tones (100 → 10)
    /// let warning = ReeceColors.secondary.orange(.t60, using: scheme)
    /// ```
    static let secondary = SecondaryNamespace()
}

// MARK: - Secondary namespace

/// Public API for **Secondary** color tokens (SwiftUI).
///
/// New families (e.g., TextGray, MediumGrey, LightGray) should follow the same pattern:
/// - define a tone enum
/// - add a public method here
/// - store palette values in `Palette.Secondary.<Family>`
@MainActor
public struct SecondaryNamespace {
    /// Raw palette access for the **Orange** family by tone.
    ///
    /// - Parameters:
    ///   - tone: One of the `OrangeTone` steps (`t100 … t10`).
    ///   - scheme: Caller’s environment `ColorScheme`.
    /// - Returns: The resolved color for the effective scheme.
    /// - Precondition: Crashes in debug if the requested tone is not present.
    public func orange(_ tone: OrangeTone, using scheme: ColorScheme) -> Color {
        guard
            let light = Palette.Secondary.Orange.light[tone],
            let dark  = Palette.Secondary.Orange.dark[tone]
        else {
            preconditionFailure("Missing Orange tone \(tone)")
        }
        return ReeceColorSupport.pick(light: light, dark: dark, using: scheme)
    }
}

// MARK: - Tone enums (Secondary)

/// Tone scale for **Orange** (`100 → 10`).
public enum OrangeTone: Int, CaseIterable, Sendable {
    case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
    case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
}

// MARK: - Internal palette storage

private enum Palette {
    enum Secondary {
        enum Orange {
            static let light: [OrangeTone: Color] = [
                .t100: Color(hex: "#FFA500"),
                .t90:  Color(hex: "#FFAE1A"),
                .t80:  Color(hex: "#FFB733"),
                .t70:  Color(hex: "#FFC04D"),
                .t60:  Color(hex: "#FFC966"),
                .t50:  Color(hex: "#FFD17F"),
                .t40:  Color(hex: "#FFDB99"),
                .t30:  Color(hex: "#FFE4B3"),
                .t20:  Color(hex: "#FFEDCC"),
                .t10:  Color(hex: "#FFF6E6")
            ]
            
            // Temporary: dark uses light until design delivers a dedicated dark palette.
            static let dark: [OrangeTone: Color] = light
        }
    }
}
