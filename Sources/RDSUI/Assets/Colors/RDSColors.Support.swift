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
            .t100: Color("#407A26"),
            .t90:  Color("#54883C"),
            .t80:  Color("#669551"),
            .t70:  Color("#7AA268"),
            .t60:  Color("#8CAF7D"),
            .t50:  Color("#9FBC92"),
            .t40:  Color("#B3CAA8"),
            .t30:  Color("#C6D8BE"),
            .t20:  Color("#D9E4D4"),
            .t10:  Color("#ECF2E9")
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
            .t100: Color("#C82D15"),
            .t90:  Color("#CE422D"),
            .t80:  Color("#D35744"),
            .t70:  Color("#D96C5C"),
            .t60:  Color("#DE8173"),
            .t50:  Color("#E39589"),
            .t40:  Color("#E9ABA1"),
            .t30:  Color("#EFC0B9"),
            .t20:  Color("#F4D5D0"),
            .t10:  Color("#FAEAE8")
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
            .t100: Color("#9D6601"),
            .t90:  Color("#A7761B"),
            .t80:  Color("#B18534"),
            .t70:  Color("#BB944E"),
            .t60:  Color("#C4A367"),
            .t50:  Color("#CDB27F"),
            .t40:  Color("#D8C299"),
            .t30:  Color("#E2D2B3"),
            .t20:  Color("#EBE0CC"),
            .t10:  Color("#F6F0E6")
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
            .t100: Color("#3DDBCC"),
            .t90:  Color("#51DFD2"),
            .t80:  Color("#64E2D6"),
            .t70:  Color("#78E6DC"),
            .t60:  Color("#8BE9E0"),
            .t50:  Color("#9DECE5"),
            .t40:  Color("#B1F1EB"),
            .t30:  Color("#C5F5F0"),
            .t20:  Color("#D8F8F5"),
            .t10:  Color("#ECFCFA")
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
            .t100: Color("#44C7F4"),
            .t90:  Color("#57CDF6"),
            .t80:  Color("#69D2F6"),
            .t70:  Color("#7DD8F8"),
            .t60:  Color("#8FDDF8"),
            .t50:  Color("#A1E2F9"),
            .t40:  Color("#B4E9FB"),
            .t30:  Color("#C7EFFC"),
            .t20:  Color("#DAF4FD"),
            .t10:  Color("#EDFAFE")
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
            .t100: Color("#8C44EF"),
            .t90:  Color("#9857F1"),
            .t80:  Color("#A369F2"),
            .t70:  Color("#AF7DF4"),
            .t60:  Color("#BA8FF5"),
            .t50:  Color("#C5A1F6"),
            .t40:  Color("#D1B4F9"),
            .t30:  Color("#DDC7FB"),
            .t20:  Color("#E8DAFC"),
            .t10:  Color("#F4EDFE")
        ]

        #warning("Replace dark palette when design provides dedicated values for Support.Purple")
        public static let dark: [Tone: Color] = light
    }

    // MARK: - Single-tone color
    public enum HoverBlue {
        private enum Palette { static let base: Color = Color("#024E8E") }
        /// Single-tone accent color for **Hover Blue**.
        /// - Returns: The same value for light/dark until design provides a dedicated dark token.
        @MainActor public static func color(using scheme: ColorScheme) -> Color {
            let base = Palette.base
            return RDSColorEngine.pick(light: base, dark: base, using: scheme)
        }
    }
}
