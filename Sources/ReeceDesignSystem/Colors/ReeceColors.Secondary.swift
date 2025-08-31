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
        return ReeceColorEngine.pick(light: light, dark: dark, using: scheme)
    }
    
    /// Raw palette access for the **Text Gray** family by tone.
    ///
    /// - Parameters:
    ///   - tone: One of the `SecondaryTextGrayTone` steps (`t100 … t10`).
    ///   - scheme: Caller’s environment `ColorScheme`.
    /// - Returns: The resolved color for the effective scheme.
    /// - Precondition: Crashes in debug if the requested tone is not present.
    public func textGray(_ tone: SecondaryTextGrayTone, using scheme: ColorScheme) -> Color {
        guard
            let light = Palette.Secondary.TextGray.light[tone],
            let dark  = Palette.Secondary.TextGray.dark[tone]
        else {
            preconditionFailure("Missing Text Gray tone \(tone)")
        }
        return ReeceColorEngine.pick(light: light, dark: dark, using: scheme)
    }
    
    /// Raw palette access for the **Medium Grey** family by tone.
    ///
    /// - Parameters:
    ///   - tone: One of the `MediumGreyTone` steps (`t100 … t10`).
    ///   - scheme: Caller’s environment `ColorScheme`.
    /// - Returns: The resolved color for the effective scheme.
    public func mediumGrey(_ tone: MediumGreyTone, using scheme: ColorScheme) -> Color {
        guard
            let light = Palette.Secondary.MediumGrey.light[tone],
            let dark  = Palette.Secondary.MediumGrey.dark[tone]
        else {
            preconditionFailure("Missing Medium Grey tone \(tone)")
        }
        return ReeceColorEngine.pick(light: light, dark: dark, using: scheme)
    }
    /// Raw palette access for the **Light Gray** family by tone.
    ///
    /// - Parameters:
    ///   - tone: One of the `LightGrayTone` steps (`t100 … t10`).
    ///   - scheme: Caller’s environment `ColorScheme`.
    /// - Returns: The resolved color for the effective scheme.
    public func lightGray(_ tone: LightGrayTone, using scheme: ColorScheme) -> Color {
        guard
            let light = Palette.Secondary.LightGray.light[tone],
            let dark  = Palette.Secondary.LightGray.dark[tone]
        else {
            preconditionFailure("Missing Light Gray tone \(tone)")
        }
        return ReeceColorEngine.pick(light: light, dark: dark, using: scheme)
    }
    
    /// Single-tone color for **White**.
    /// - Returns: The same value for light/dark until design provides a separate dark token.
    public func white(using scheme: ColorScheme) -> Color {
        let base = Palette.Secondary.White.base
        return ReeceColorEngine.pick(light: base, dark: base, using: scheme)
    }

    /// Single-tone color for **Off-White**.
    public func offWhite(using scheme: ColorScheme) -> Color {
        let base = Palette.Secondary.OffWhite.base
        return ReeceColorEngine.pick(light: base, dark: base, using: scheme)
    }

    /// Single-tone color for **Black**.
    public func black(using scheme: ColorScheme) -> Color {
        let base = Palette.Secondary.Black.base
        return ReeceColorEngine.pick(light: base, dark: base, using: scheme)
    }

}

// MARK: - Tone enums (Secondary)

/// Tone scale for **Orange** (`100 → 10`).
public enum OrangeTone: Int, CaseIterable, Sendable {
    case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
    case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
}

/// Tone scale for **Text Gray** (`100 → 10`).
public enum SecondaryTextGrayTone: Int, CaseIterable, Sendable {
    case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
    case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
}

/// Tone scale for **Medium Grey** (`100 → 10`).
public enum MediumGreyTone: Int, CaseIterable, Sendable {
    case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
    case t50 = 50,  t40 = 40, t30 = 30, t20 = 20, t10 = 10
}
/// Tone scale for **Light Gray** (`100 → 10`).
public enum LightGrayTone: Int, CaseIterable, Sendable {
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
        
        enum TextGray {
            static let light: [SecondaryTextGrayTone: Color] = [
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
            static let dark: [SecondaryTextGrayTone: Color] = light
        }
        
        enum MediumGrey {
            static let light: [MediumGreyTone: Color] = [
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
            static let dark: [MediumGreyTone: Color] = light
        }
        enum LightGray {
            static let light: [LightGrayTone: Color] = [
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
            static let dark: [LightGrayTone: Color] = light
        }
        
        enum White {
            static let base: Color = Color(hex: "#FFFFFF")
        }
        enum OffWhite {
            static let base: Color = Color(hex: "#F5F1ED")
        }
        enum Black {
            static let base: Color = Color(hex: "#000000")
        }

    }
}
