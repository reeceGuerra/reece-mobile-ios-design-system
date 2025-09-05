//
//  ReeceColors.Primary.swift
//  ReeceDesignSystem
//
//  Refactor: Families nested inside PrimaryNamespace for hierarchical access.
//  Created by Carlos Lopez on 29/08/25
//  Updated by ChatGPT on 01/09/25
//

import SwiftUI

// MARK: - Public Entry Point
public extension ReeceColors {
    /// Value-namespace for the **Primary** color family.
    ///
    /// Access example:
    /// ```swift
    /// let button = ReeceColors.primary.DarkBlue.color(.t80, using: scheme)
    /// let info   = ReeceColors.primary.LightBlue.color(.t30, using: scheme)
    /// let text   = ReeceColors.primary.DarkTextGray.color(.t60, using: scheme)
    /// ```
    typealias primary = Primary
}
// MARK: - Primary namespace (SwiftUI)
/// Public API for **Primary** color tokens (SwiftUI).
/// Families are nested for explicit hierarchical access.
@MainActor
public enum Primary {
    // MARK: - Families
    public enum DarkBlue: ReecePaletteFamily {
        /// Tone scale for **Dark Blue** (`100 → 10`).
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
        }

        public static let light: [Tone: Color] = [
            .t100: Color(hex: "#003766"),
            .t90:  Color(hex: "#1A4B76"),
            .t80:  Color(hex: "#335F85"),
            .t70:  Color(hex: "#4D7394"),
            .t60:  Color(hex: "#6687A3"),
            .t50:  Color(hex: "#7F9AB2"),
            .t40:  Color(hex: "#99AFC2"),
            .t30:  Color(hex: "#B3C3D2"),
            .t20:  Color(hex: "#CCD7E0"),
            .t10:  Color(hex: "#E6EBF0")
        ]

        #warning("Replace dark palette when design provides dedicated values for Primary.DarkBlue")
        public static let dark: [Tone: Color] = light
    }

    public enum LightBlue: ReecePaletteFamily {
        /// Tone scale for **Light Blue** (`100 → 10`) plus **`t5`**.
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
            case t5 = 5
        }

        public static let light: [Tone: Color] = [
            .t100: Color(hex: "#0B66EC"),
            .t90:  Color(hex: "#2476EE"),
            .t80:  Color(hex: "#3C85F0"),
            .t70:  Color(hex: "#5594F2"),
            .t60:  Color(hex: "#6DA3F4"),
            .t50:  Color(hex: "#84B2F5"),
            .t40:  Color(hex: "#9DC2F7"),
            .t30:  Color(hex: "#B6D2FA"),
            .t20:  Color(hex: "#CEE0FB"),
            .t10:  Color(hex: "#E7F0FE"),
            .t5:   Color(hex: "#F4F9FF")
        ]

        #warning("Replace dark palette when design provides dedicated values for Primary.LightBlue")
        public static let dark: [Tone: Color] = light
    }

    public enum DarkTextGray: ReecePaletteFamily {
        /// Tone scale for **Dark Text Gray** (`100 → 10`).
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
        }

        public static let light: [Tone: Color] = [
            .t100: Color(hex: "#404040"),
            .t90:  Color(hex: "#545454"),
            .t80:  Color(hex: "#666666"),
            .t70:  Color(hex: "#7A7A7A"),
            .t60:  Color(hex: "#8C8C8C"),
            .t50:  Color(hex: "#9F9F9F"),
            .t40:  Color(hex: "#B3B3B3"),
            .t30:  Color(hex: "#C6C6C6"),
            .t20:  Color(hex: "#D9D9D9"),
            .t10:  Color(hex: "#ECECEC")
        ]

        #warning("Replace dark palette when design provides dedicated values for Primary.DarkTextGray")
        public static let dark: [Tone: Color] = light
    }
}
