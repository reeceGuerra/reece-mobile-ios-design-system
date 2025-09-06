//
//  RDSColors.Primary.swift
//  RDSDesignSystem
//
//  Refactor: Families nested inside PrimaryNamespace for hierarchical access.
//  Created by Carlos Lopez on 29/08/25
//

import SwiftUI

// MARK: - Public Entry Point
public extension RDSColors {
    /// Value-namespace for the **Primary** color family.
    ///
    /// Access example:
    /// ```swift
    /// let button = RDSColors.primary.DarkBlue.color(.t80, using: scheme)
    /// let info   = RDSColors.primary.LightBlue.color(.t30, using: scheme)
    /// let text   = RDSColors.primary.DarkTextGray.color(.t60, using: scheme)
    /// ```
    typealias primary = Primary
}

// MARK: - Primary namespace (SwiftUI)
/// Public API for **Primary** color tokens (SwiftUI).
/// Families are nested for explicit hierarchical access.
@MainActor
public enum Primary {
    // MARK: - Families

    public enum DarkBlue: RDSPaletteFamily {
        /// Tone scale for **Dark Blue** (`100 → 10`).
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
        }

        public static let light: [Tone: Color] = [
            .t100: Color.rds("#003766"),
            .t90:  Color.rds("#1A4B76"),
            .t80:  Color.rds("#335F85"),
            .t70:  Color.rds("#4D7394"),
            .t60:  Color.rds("#6687A3"),
            .t50:  Color.rds("#7F9AB2"),
            .t40:  Color.rds("#99AFC2"),
            .t30:  Color.rds("#B3C3D2"),
            .t20:  Color.rds("#CCD7E0"),
            .t10:  Color.rds("#E6EBF0")
        ]

        #warning("Replace dark palette when design provides dedicated values for Primary.DarkBlue")
        public static let dark: [Tone: Color] = light
    }

    public enum LightBlue: RDSPaletteFamily {
        /// Tone scale for **Light Blue** (`100 → 10`) plus **`t5`**.
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
            case t5 = 5
        }

        public static let light: [Tone: Color] = [
            .t100: Color.rds("#0B66EC"),
            .t90:  Color.rds("#2476EE"),
            .t80:  Color.rds("#3C85F0"),
            .t70:  Color.rds("#5594F2"),
            .t60:  Color.rds("#6DA3F4"),
            .t50:  Color.rds("#84B2F5"),
            .t40:  Color.rds("#9DC2F7"),
            .t30:  Color.rds("#B6D2FA"),
            .t20:  Color.rds("#CEE0FB"),
            .t10:  Color.rds("#E7F0FE"),
            .t5:   Color.rds("#F4F9FF")
        ]

        #warning("Replace dark palette when design provides dedicated values for Primary.LightBlue")
        public static let dark: [Tone: Color] = light
    }

    public enum DarkTextGray: RDSPaletteFamily {
        /// Tone scale for **Dark Text Gray** (`100 → 10`).
        public enum Tone: Int, CaseIterable, Sendable {
            case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
            case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
        }

        public static let light: [Tone: Color] = [
            .t100: Color.rds("#404040"),
            .t90:  Color.rds("#545454"),
            .t80:  Color.rds("#666666"),
            .t70:  Color.rds("#7A7A7A"),
            .t60:  Color.rds("#8C8C8C"),
            .t50:  Color.rds("#9F9F9F"),
            .t40:  Color.rds("#B3B3B3"),
            .t30:  Color.rds("#C6C6C6"),
            .t20:  Color.rds("#D9D9D9"),
            .t10:  Color.rds("#ECECEC")
        ]

        #warning("Replace dark palette when design provides dedicated values for Primary.DarkTextGray")
        public static let dark: [Tone: Color] = light
    }
}

