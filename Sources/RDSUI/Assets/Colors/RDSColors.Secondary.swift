//
//  RDSColors.Secondary.swift
//  RDSDesignSystem
//
//  Refactor: Families nested inside SecondaryNamespace for hierarchical access.
//  Created by Carlos Lopez on 30/08/25
//

import SwiftUI

public extension RDSColors {
    /// Value-namespace for the **Secondary** color family.
    ///
    /// Access example:
    /// ```swift
    /// let warn = RDSColors.secondary.Orange.color(.t60, using: scheme)
    /// let bg   = RDSColors.secondary.White.color(using: scheme)
    /// ```
    typealias secondary = Secondary
}

// MARK: - Secondary namespace (SwiftUI)
/// Public API for **Secondary** color tokens (SwiftUI).
/// Families are nested for explicit hierarchical access.
@MainActor
public enum Secondary {

    // MARK: - Families (tones)
    public enum Orange: RDSPaletteFamily {
        /// Tone scale for **Orange** (`100 → 10`).
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
        }

        public static let light: [Tone: Color] = [
            .t100: Color.rds("#FFA500"),
            .t90:  Color.rds("#FFAE1A"),
            .t80:  Color.rds("#FFB733"),
            .t70:  Color.rds("#FFC04D"),
            .t60:  Color.rds("#FFC966"),
            .t50:  Color.rds("#FFD17F"),
            .t40:  Color.rds("#FFDB99"),
            .t30:  Color.rds("#FFE4B3"),
            .t20:  Color.rds("#FFEDCC"),
            .t10:  Color.rds("#FFF6E6")
        ]

        #warning("Replace dark palette when design provides dedicated values for Secondary.Orange")
        public static let dark: [Tone: Color] = light
    }

    public enum TextGray: RDSPaletteFamily {
        /// Tone scale for **Text Gray** (`100 → 10`).
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
        }

        public static let light: [Tone: Color] = [
            .t100: Color.rds("#606060"),
            .t90:  Color.rds("#717171"),
            .t80:  Color.rds("#808080"),
            .t70:  Color.rds("#909090"),
            .t60:  Color.rds("#A0A0A0"),
            .t50:  Color.rds("#AFAFAF"),
            .t40:  Color.rds("#C0C0C0"),
            .t30:  Color.rds("#D0D0D0"),
            .t20:  Color.rds("#DFDFDF"),
            .t10:  Color.rds("#F0F0F0")
        ]

        #warning("Replace dark palette when design provides dedicated values for Secondary.TextGray")
        public static let dark: [Tone: Color] = light
    }

    public enum MediumGrey: RDSPaletteFamily {
        /// Tone scale for **Medium Grey** (`100 → 10`).
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
        }

        public static let light: [Tone: Color] = [
            .t100: Color.rds("#CBCBCB"),
            .t90:  Color.rds("#D1D1D1"),
            .t80:  Color.rds("#D5D5D5"),
            .t70:  Color.rds("#DBDBDB"),
            .t60:  Color.rds("#E0E0E0"),
            .t50:  Color.rds("#E4E4E4"),
            .t40:  Color.rds("#EAEAEA"),
            .t30:  Color.rds("#F0F0F0"),
            .t20:  Color.rds("#F5F5F5"),
            .t10:  Color.rds("#FAFAFA")
        ]

        #warning("Replace dark palette when design provides dedicated values for Secondary.MediumGrey")
        public static let dark: [Tone: Color] = light
    }

    public enum LightGray: RDSPaletteFamily {
        /// Tone scale for **Light Gray** (`100 → 10`).
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
        }

        public static let light: [Tone: Color] = [
            .t100: Color.rds("#F2F2F2"),
            .t90:  Color.rds("#F4F4F4"),
            .t80:  Color.rds("#F5F5F5"),
            .t70:  Color.rds("#F6F6F6"),
            .t60:  Color.rds("#F7F7F7"),
            .t50:  Color.rds("#F8F8F8"),
            .t40:  Color.rds("#FAFAFA"),
            .t30:  Color.rds("#FCFCFC"),
            .t20:  Color.rds("#FDFDFD"),
            .t10:  Color.rds("#FEFEFE")
        ]

        #warning("Replace dark palette when design provides dedicated values for Secondary.LightGray")
        public static let dark: [Tone: Color] = light
    }

    // MARK: - Single-tone colors
    public enum White {
        private enum Palette { static let base: Color = Color.rds("#FFFFFF") }
        /// Single-tone color for **White**.
        /// - Returns: The same value for light/dark until design provides a separate dark token.
        @MainActor public static func color(using scheme: ColorScheme) -> Color {
            let base = Palette.base
            return RDSColorEngine.pick(light: base, dark: base, using: scheme)
        }
    }

    public enum OffWhite {
        private enum Palette { static let base: Color = Color.rds("#F5F1ED") }
        /// Single-tone color for **Off-White**.
        @MainActor public static func color(using scheme: ColorScheme) -> Color {
            let base = Palette.base
            return RDSColorEngine.pick(light: base, dark: base, using: scheme)
        }
    }

    public enum Black {
        private enum Palette { static let base: Color = Color.rds("#000000") }
        /// Single-tone color for **Black**.
        @MainActor public static func color(using scheme: ColorScheme) -> Color {
            let base = Palette.base
            return RDSColorEngine.pick(light: base, dark: base, using: scheme)
        }
    }
}

