//
//  RDSColors.Support.swift
//  RDSDesignSystem
//
//  Refactor: Families nested inside SupportNamespace for hierarchical access.
//  Created by Carlos Lopez on 30/08/25
//  Updated by ChatGPT on 01/09/25
//

import SwiftUI

public extension RDSColors {
    /// Value-namespace for the **Support** color family.
    ///
    /// Access examples:
    /// ```swift
    /// let ok     = RDSColors.support.Green.color(.t60, using: scheme)
    /// let alert  = RDSColors.support.OrangyRed.color(.t70, using: scheme)
    /// let warn   = RDSColors.support.Yellow.color(.t50, using: scheme)
    /// let accent = RDSColors.support.HoverBlue.color(using: scheme) // single tone
    /// ```
    typealias support = Support
}

// MARK: - Support namespace (SwiftUI)
/// Public API for **Support** color tokens (SwiftUI).
/// Families are nested for explicit hierarchical access.
/// All methods are **MainActor**-isolated to align with UI rendering and theme resolution.
@MainActor
public enum Support {

    // MARK: - Families (tones)
    public enum Green: RDSPaletteFamily {
        /// Tone scale for **Green** (`100 → 10`).
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
        }

        public static let light: [Tone: Color] = [
            .t100: Color(hex: "#407A26"),
            .t90:  Color(hex: "#54883C"),
            .t80:  Color(hex: "#669551"),
            .t70:  Color(hex: "#7AA268"),
            .t60:  Color(hex: "#8CAF7D"),
            .t50:  Color(hex: "#9FBC92"),
            .t40:  Color(hex: "#B3CAA8"),
            .t30:  Color(hex: "#C6D8BE"),
            .t20:  Color(hex: "#D9E4D4"),
            .t10:  Color(hex: "#ECF2E9")
        ]

        #warning("Replace dark palette when design provides dedicated values for Support.Green")
        public static let dark: [Tone: Color] = light
    }

    public enum OrangyRed: RDSPaletteFamily {
        /// Tone scale for **Orangy Red** (`100 → 10`).
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
        }

        public static let light: [Tone: Color] = [
            .t100: Color(hex: "#C82D15"),
            .t90:  Color(hex: "#CE422D"),
            .t80:  Color(hex: "#D35744"),
            .t70:  Color(hex: "#D96C5C"),
            .t60:  Color(hex: "#DE8173"),
            .t50:  Color(hex: "#E39589"),
            .t40:  Color(hex: "#E9ABA1"),
            .t30:  Color(hex: "#EFC0B9"),
            .t20:  Color(hex: "#F4D5D0"),
            .t10:  Color(hex: "#FAEAE8")
        ]

        #warning("Replace dark palette when design provides dedicated values for Support.OrangyRed")
        public static let dark: [Tone: Color] = light
    }

    public enum Yellow: RDSPaletteFamily {
        /// Tone scale for **Yellow** (`100 → 10`).
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
        }

        public static let light: [Tone: Color] = [
            .t100: Color(hex: "#9D6601"),
            .t90:  Color(hex: "#A7761B"),
            .t80:  Color(hex: "#B18534"),
            .t70:  Color(hex: "#BB944E"),
            .t60:  Color(hex: "#C4A367"),
            .t50:  Color(hex: "#CDB27F"),
            .t40:  Color(hex: "#D8C299"),
            .t30:  Color(hex: "#E2D2B3"),
            .t20:  Color(hex: "#EBE0CC"),
            .t10:  Color(hex: "#F6F0E6")
        ]

        #warning("Replace dark palette when design provides dedicated values for Support.Yellow")
        public static let dark: [Tone: Color] = light
    }

    public enum Teal: RDSPaletteFamily {
        /// Tone scale for **Teal** (`100 → 10`).
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
        }

        public static let light: [Tone: Color] = [
            .t100: Color(hex: "#3DDBCC"),
            .t90:  Color(hex: "#51DFD2"),
            .t80:  Color(hex: "#64E2D6"),
            .t70:  Color(hex: "#78E6DC"),
            .t60:  Color(hex: "#8BE9E0"),
            .t50:  Color(hex: "#9DECE5"),
            .t40:  Color(hex: "#B1F1EB"),
            .t30:  Color(hex: "#C5F5F0"),
            .t20:  Color(hex: "#D8F8F5"),
            .t10:  Color(hex: "#ECFCFA")
        ]

        #warning("Replace dark palette when design provides dedicated values for Support.Teal")
        public static let dark: [Tone: Color] = light
    }

    public enum SkyBlue: RDSPaletteFamily {
        /// Tone scale for **Sky Blue** (`100 → 10`).
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
        }

        public static let light: [Tone: Color] = [
            .t100: Color(hex: "#44C7F4"),
            .t90:  Color(hex: "#57CDF6"),
            .t80:  Color(hex: "#69D2F6"),
            .t70:  Color(hex: "#7DD8F8"),
            .t60:  Color(hex: "#8FDDF8"),
            .t50:  Color(hex: "#A1E2F9"),
            .t40:  Color(hex: "#B4E9FB"),
            .t30:  Color(hex: "#C7EFFC"),
            .t20:  Color(hex: "#DAF4FD"),
            .t10:  Color(hex: "#EDFAFE")
        ]

        #warning("Replace dark palette when design provides dedicated values for Support.SkyBlue")
        public static let dark: [Tone: Color] = light
    }

    public enum Purple: RDSPaletteFamily {
        /// Tone scale for **Purple** (`100 → 10`).
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
        }

        public static let light: [Tone: Color] = [
            .t100: Color(hex: "#8C44EF"),
            .t90:  Color(hex: "#9857F1"),
            .t80:  Color(hex: "#A369F2"),
            .t70:  Color(hex: "#AF7DF4"),
            .t60:  Color(hex: "#BA8FF5"),
            .t50:  Color(hex: "#C5A1F6"),
            .t40:  Color(hex: "#D1B4F9"),
            .t30:  Color(hex: "#DDC7FB"),
            .t20:  Color(hex: "#E8DAFC"),
            .t10:  Color(hex: "#F4EDFE")
        ]

        #warning("Replace dark palette when design provides dedicated values for Support.Purple")
        public static let dark: [Tone: Color] = light
    }

    // MARK: - Single-tone color
    public enum HoverBlue {
        private enum Palette { static let base: Color = Color(hex: "#024E8E") }
        /// Single-tone accent color for **Hover Blue**.
        /// - Returns: The same value for light/dark until design provides a dedicated dark token.
        @MainActor public static func color(using scheme: ColorScheme) -> Color {
            let base = Palette.base
            return RDSColorEngine.pick(light: base, dark: base, using: scheme)
        }
    }
}
