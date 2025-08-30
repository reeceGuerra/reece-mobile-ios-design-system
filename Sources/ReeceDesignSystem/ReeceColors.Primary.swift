//
//  ReeceColors.Primary.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 29/08/25.
//

import SwiftUI

/// Numeric scale for a single hue (e.g., Dark Blue).
public enum ReeceTone: Int, CaseIterable, Sendable {
    case t100 = 100, t90 = 90, t80 = 80, t70 = 70, t60 = 60
    case t50 = 50, t40 = 40, t30 = 30, t20 = 20, t10 = 10
}

public enum ReeceColors {
    public static let primary = PrimaryNamespace()
}

@MainActor
public struct PrimaryNamespace {
    /// Raw palette access for the "Dark Blue" family by tone.
    /// For now, dark == light until design provides dark-specific values.
    public func darkBlue(_ tone: ReeceTone, using scheme: ColorScheme) -> Color {
        guard
            let light = Palette.DarkBlue.light[tone],
            let dark  = Palette.DarkBlue.dark[tone]
        else {
            preconditionFailure("Missing DarkBlue tone \(tone)")
        }
        return ReeceColorSupport.pick(light: light, dark: dark, using: scheme)
    }
}

// MARK: - Internal palette storage
private enum Palette {
    enum DarkBlue {
        static let light: [ReeceTone: Color] = [
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
        // Temporary: dark uses light until design delivers dark palette
        static let dark: [ReeceTone: Color] = light
    }
}
