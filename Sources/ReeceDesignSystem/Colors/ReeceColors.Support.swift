//
//  ReeceColors.Support.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 30/08/25.
//

import SwiftUI

public extension ReeceColors {
    /// Value-namespace for the **Support** color family.
    ///
    /// Examples:
    /// ```swift
    /// let ok     = ReeceColors.support.green(.t60, using: scheme)
    /// let alert  = ReeceColors.support.orangyRed(.t70, using: scheme)
    /// let warn   = ReeceColors.support.yellow(.t50, using: scheme)
    /// let accent = ReeceColors.support.hoverBlue(using: scheme) // single tone
    /// ```
    static let support = SupportNamespace()
}

// MARK: - Support namespace

/// Public API for **Support** color tokens (SwiftUI).
///
/// Each subfamily provides design tokens as tones (`t100 → t10`) or single-tone.
/// All methods are **MainActor**-isolated to align with UI rendering and theme resolution.
@MainActor
public struct SupportNamespace {

    /// Raw palette access for the **Green** family by tone (`t100 → t10`).
    ///
    /// - Parameters:
    ///   - tone: One of the `GreenTone` steps.
    ///   - scheme: Caller’s environment `ColorScheme`.
    /// - Returns: The resolved color for the effective scheme.
    public func green(_ tone: GreenTone, using scheme: ColorScheme) -> Color {
        guard
            let light = Palette.Support.Green.light[tone],
            let dark  = Palette.Support.Green.dark[tone]
        else {
            preconditionFailure("Missing Support.Green tone \(tone)")
        }
        return ReeceColorEngine.pick(light: light, dark: dark, using: scheme)
    }

    /// Raw palette access for the **Orangy Red** family by tone (`t100 → t10`).
    public func orangyRed(_ tone: OrangyRedTone, using scheme: ColorScheme) -> Color {
        guard
            let light = Palette.Support.OrangyRed.light[tone],
            let dark  = Palette.Support.OrangyRed.dark[tone]
        else {
            preconditionFailure("Missing Support.OrangyRed tone \(tone)")
        }
        return ReeceColorEngine.pick(light: light, dark: dark, using: scheme)
    }

    /// Raw palette access for the **Yellow** family by tone (`t100 → t10`).
    public func yellow(_ tone: YellowTone, using scheme: ColorScheme) -> Color {
        guard
            let light = Palette.Support.Yellow.light[tone],
            let dark  = Palette.Support.Yellow.dark[tone]
        else {
            preconditionFailure("Missing Support.Yellow tone \(tone)")
        }
        return ReeceColorEngine.pick(light: light, dark: dark, using: scheme)
    }

    /// Raw palette access for the **Teal** family by tone (`t100 → t10`).
    public func teal(_ tone: TealTone, using scheme: ColorScheme) -> Color {
        guard
            let light = Palette.Support.Teal.light[tone],
            let dark  = Palette.Support.Teal.dark[tone]
        else {
            preconditionFailure("Missing Support.Teal tone \(tone)")
        }
        return ReeceColorEngine.pick(light: light, dark: dark, using: scheme)
    }

    /// Raw palette access for the **Sky Blue** family by tone (`t100 → t10`).
    public func skyBlue(_ tone: SkyBlueTone, using scheme: ColorScheme) -> Color {
        guard
            let light = Palette.Support.SkyBlue.light[tone],
            let dark  = Palette.Support.SkyBlue.dark[tone]
        else {
            preconditionFailure("Missing Support.SkyBlue tone \(tone)")
        }
        return ReeceColorEngine.pick(light: light, dark: dark, using: scheme)
    }

    /// Raw palette access for the **Purple** family by tone (`t100 → t10`).
    public func purple(_ tone: PurpleTone, using scheme: ColorScheme) -> Color {
        guard
            let light = Palette.Support.Purple.light[tone],
            let dark  = Palette.Support.Purple.dark[tone]
        else {
            preconditionFailure("Missing Support.Purple tone \(tone)")
        }
        return ReeceColorEngine.pick(light: light, dark: dark, using: scheme)
    }

    /// Single-tone accent color for **Hover Blue**.
    ///
    /// - Returns: The same value for light/dark until design provides a dedicated dark token.
    public func hoverBlue(using scheme: ColorScheme) -> Color {
        let v = Palette.Support.HoverBlue.base
        return ReeceColorEngine.pick(light: v, dark: v, using: scheme)
    }
}

// MARK: - Tone enums (10 steps each)

/// Tone scale for **Green** (`100 → 10`).
public enum GreenTone: Int, CaseIterable, Sendable {
    case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
    case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
}

/// Tone scale for **Orangy Red** (`100 → 10`).
public enum OrangyRedTone: Int, CaseIterable, Sendable {
    case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
    case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
}

/// Tone scale for **Yellow** (`100 → 10`).
public enum YellowTone: Int, CaseIterable, Sendable {
    case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
    case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
}

/// Tone scale for **Teal** (`100 → 10`).
public enum TealTone: Int, CaseIterable, Sendable {
    case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
    case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
}

/// Tone scale for **Sky Blue** (`100 → 10`).
public enum SkyBlueTone: Int, CaseIterable, Sendable {
    case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
    case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
}

/// Tone scale for **Purple** (`100 → 10`).
public enum PurpleTone: Int, CaseIterable, Sendable {
    case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
    case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
}

// MARK: - Internal palette storage
// HEX values provided by design (light). For now, dark == light.

private enum Palette {
    enum Support {

        enum Green {
            static let light: [GreenTone: Color] = [
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
            static let dark: [GreenTone: Color] = light
        }

        enum OrangyRed {
            static let light: [OrangyRedTone: Color] = [
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
            static let dark: [OrangyRedTone: Color] = light
        }

        enum Yellow {
            static let light: [YellowTone: Color] = [
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
            static let dark: [YellowTone: Color] = light
        }

        enum Teal {
            static let light: [TealTone: Color] = [
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
            static let dark: [TealTone: Color] = light
        }

        enum SkyBlue {
            static let light: [SkyBlueTone: Color] = [
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
            static let dark: [SkyBlueTone: Color] = light
        }

        enum Purple {
            static let light: [PurpleTone: Color] = [
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
            static let dark: [PurpleTone: Color] = light
        }

        enum HoverBlue {
            static let base: Color = Color(hex: "#024E8E")
        }
    }
}
