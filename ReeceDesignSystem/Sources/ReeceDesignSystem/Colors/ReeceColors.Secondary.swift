//
//  ReeceColors.Secondary.swift
//  ReeceDesignSystem
//
//  Refactor: Families nested inside SecondaryNamespace for hierarchical access.
//  Created by Carlos Lopez on 30/08/25
//  Updated by ChatGPT on 01/09/25
//

import SwiftUI

public extension ReeceColors {
    /// Value-namespace for the **Secondary** color family.
    ///
    /// Access example:
    /// ```swift
    /// let warn = ReeceColors.secondary.Orange.color(.t60, using: scheme)
    /// let bg   = ReeceColors.secondary.White.color(using: scheme)
    /// ```
    typealias secondary = Secondary
}

// MARK: - Secondary namespace (SwiftUI)
/// Public API for **Secondary** color tokens (SwiftUI).
/// Families are nested for explicit hierarchical access.
@MainActor
public enum Secondary {

    // MARK: - Families (tones)
    public enum Orange: ReecePaletteFamily {
        /// Tone scale for **Orange** (`100 → 10`).
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
        }

        public static let light: [Tone: Color] = [
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

        #warning("Replace dark palette when design provides dedicated values for Secondary.Orange")
        public static let dark: [Tone: Color] = light
    }

    public enum TextGray: ReecePaletteFamily {
        /// Tone scale for **Text Gray** (`100 → 10`).
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
        }

        public static let light: [Tone: Color] = [
            .t100: Color(hex: "#606060"),
            .t90:  Color(hex: "#717171"),
            .t80:  Color(hex: "#808080"),
            .t70:  Color(hex: "#909090"),
            .t60:  Color(hex: "#A0A0A0"),
            .t50:  Color(hex: "#AFAFAF"),
            .t40:  Color(hex: "#C0C0C0"),
            .t30:  Color(hex: "#D0D0D0"),
            .t20:  Color(hex: "#DFDFDF"),
            .t10:  Color(hex: "#F0F0F0")
        ]

        #warning("Replace dark palette when design provides dedicated values for Secondary.TextGray")
        public static let dark: [Tone: Color] = light
    }

    public enum MediumGrey: ReecePaletteFamily {
        /// Tone scale for **Medium Grey** (`100 → 10`).
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
        }

        public static let light: [Tone: Color] = [
            .t100: Color(hex: "#CBCBCB"),
            .t90:  Color(hex: "#D1D1D1"),
            .t80:  Color(hex: "#D5D5D5"),
            .t70:  Color(hex: "#DBDBDB"),
            .t60:  Color(hex: "#E0E0E0"),
            .t50:  Color(hex: "#E4E4E4"),
            .t40:  Color(hex: "#EAEAEA"),
            .t30:  Color(hex: "#F0F0F0"),
            .t20:  Color(hex: "#F5F5F5"),
            .t10:  Color(hex: "#FAFAFA")
        ]

        #warning("Replace dark palette when design provides dedicated values for Secondary.MediumGrey")
        public static let dark: [Tone: Color] = light
    }

    public enum LightGray: ReecePaletteFamily {
        /// Tone scale for **Light Gray** (`100 → 10`).
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
        }

        public static let light: [Tone: Color] = [
            .t100: Color(hex: "#F2F2F2"),
            .t90:  Color(hex: "#F4F4F4"),
            .t80:  Color(hex: "#F5F5F5"),
            .t70:  Color(hex: "#F6F6F6"),
            .t60:  Color(hex: "#F7F7F7"),
            .t50:  Color(hex: "#F8F8F8"),
            .t40:  Color(hex: "#FAFAFA"),
            .t30:  Color(hex: "#FCFCFC"),
            .t20:  Color(hex: "#FDFDFD"),
            .t10:  Color(hex: "#FEFEFE")
        ]

        #warning("Replace dark palette when design provides dedicated values for Secondary.LightGray")
        public static let dark: [Tone: Color] = light
    }

    // MARK: - Single-tone colors
    public enum White {
        private enum Palette { static let base: Color = Color(hex: "#FFFFFF") }
        /// Single-tone color for **White**.
        /// - Returns: The same value for light/dark until design provides a separate dark token.
        @MainActor public static func color(using scheme: ColorScheme) -> Color {
            let base = Palette.base
            return ReeceColorEngine.pick(light: base, dark: base, using: scheme)
        }
    }

    public enum OffWhite {
        private enum Palette { static let base: Color = Color(hex: "#F5F1ED") }
        /// Single-tone color for **Off-White**.
        @MainActor public static func color(using scheme: ColorScheme) -> Color {
            let base = Palette.base
            return ReeceColorEngine.pick(light: base, dark: base, using: scheme)
        }
    }

    public enum Black {
        private enum Palette { static let base: Color = Color(hex: "#000000") }
        /// Single-tone color for **Black**.
        @MainActor public static func color(using scheme: ColorScheme) -> Color {
            let base = Palette.base
            return ReeceColorEngine.pick(light: base, dark: base, using: scheme)
        }
    }
}
