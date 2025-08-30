//
//  ReeceColors.Primary.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 29/08/25.
//

import SwiftUI

public extension ReeceColors {
    /// Value-namespace for the **Primary** color family.
    ///
    /// Access raw palettes (by tone) using:
    /// ```swift
    /// // Dark Blue tones (100 → 10)
    /// let primaryButton = ReeceColors.primary.darkBlue(.t80, using: scheme)
    ///
    /// // Light Blue tones (includes t5)
    /// let infoBadge = ReeceColors.primary.lightBlue(.t30, using: scheme)
    ///
    /// // Dark Text Gray tones (100 → 10)
    /// let bodyText = ReeceColors.primary.darkTextGray(.t80, using: scheme)
    /// ```
    ///
    /// - Important: Dark variants currently fallback to light until design provides a dedicated dark palette.
    static let primary = PrimaryNamespace()
}

// MARK: - Primary namespace

/// Public API for **Primary** color tokens (SwiftUI).
///
/// All methods are **MainActor**-isolated to align with UI rendering and the global theme state.
@MainActor
public struct PrimaryNamespace {
    
    /// Raw palette access for the **Dark Blue** family by tone.
    ///
    /// - Parameters:
    ///   - tone: One of the `DarkBlueTone` steps (`t100 … t10`).
    ///   - scheme: Caller’s environment `ColorScheme`.
    /// - Returns: The resolved color for the effective scheme (system/light/dark).
    /// - Precondition: Crashes in debug if the requested tone is not present in the palette.
    public func darkBlue(_ tone: DarkBlueTone, using scheme: ColorScheme) -> Color {
        guard
            let light = Palette.Primary.DarkBlue.light[tone],
            let dark  = Palette.Primary.DarkBlue.dark[tone]
        else {
            preconditionFailure("Missing DarkBlue tone \(tone)")
        }
        return ReeceColorSupport.pick(light: light, dark: dark, using: scheme)
    }
    
    /// Raw palette access for the **Light Blue** family by tone.
    ///
    /// This family includes an extra `t5` tone as provided by design.
    ///
    /// - Parameters:
    ///   - tone: One of the `LightBlueTone` steps (`t100 … t10`, plus `t5`).
    ///   - scheme: Caller’s environment `ColorScheme`.
    /// - Returns: The resolved color for the effective scheme.
    /// - Precondition: Crashes in debug if the requested tone is not present.
    public func lightBlue(_ tone: LightBlueTone, using scheme: ColorScheme) -> Color {
        guard
            let light = Palette.Primary.LightBlue.light[tone],
            let dark  = Palette.Primary.LightBlue.dark[tone]
        else {
            preconditionFailure("Missing LightBlue tone \(tone)")
        }
        return ReeceColorSupport.pick(light: light, dark: dark, using: scheme)
    }
    
    /// Raw palette access for the **Dark Text Gray** family by tone.
    ///
    /// - Parameters:
    ///   - tone: One of the `DarkTextGrayTone` steps (`t100 … t10`).
    ///   - scheme: Caller’s environment `ColorScheme`.
    /// - Returns: The resolved color for the effective scheme.
    /// - Precondition: Crashes in debug if the requested tone is not present.
    public func darkTextGray(_ tone: DarkTextGrayTone, using scheme: ColorScheme) -> Color {
        guard
            let light = Palette.Primary.DarkTextGray.light[tone],
            let dark  = Palette.Primary.DarkTextGray.dark[tone]
        else {
            preconditionFailure("Missing DarkTextGray tone \(tone)")
        }
        return ReeceColorSupport.pick(light: light, dark: dark, using: scheme)
    }
}

// MARK: - Tone enums (Primary)

/// Tone scale for **Dark Blue** (`100 → 10`).
///
/// Higher values (e.g., `t100`) are typically darker; lower values (e.g., `t10`) lighter.
/// Use `CaseIterable` to iterate tones in tests or previews.
public enum DarkBlueTone: Int, CaseIterable, Sendable {
    case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
    case t50 = 50, t40 = 40, t30 = 30, t20 = 20, t10 = 10
}

/// Tone scale for **Light Blue** (`100 → 10`) plus **`t5`** as defined by design.
public enum LightBlueTone: Int, CaseIterable, Sendable {
    case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
    case t50 = 50, t40 = 40, t30 = 30, t20 = 20, t10 = 10
    case t5 = 5
}

/// Tone scale for **Dark Text Gray** (`100 → 10`).
public enum DarkTextGrayTone: Int, CaseIterable, Sendable {
    case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
    case t50 = 50, t40 = 40, t30 = 30, t20 = 20, t10 = 10
}

// MARK: - Internal palette storage
private enum Palette {
    enum Primary {
        enum DarkBlue {
            static let light: [DarkBlueTone: Color] = [
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
            static let dark: [DarkBlueTone: Color] = light
        }
        
        enum LightBlue {
            static let light: [LightBlueTone: Color] = [
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
            static let dark: [LightBlueTone: Color] = light
        }
        
        enum DarkTextGray {
            static let light: [DarkTextGrayTone: Color] = [
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
            static let dark: [DarkTextGrayTone: Color] = light
        }
    }
}
