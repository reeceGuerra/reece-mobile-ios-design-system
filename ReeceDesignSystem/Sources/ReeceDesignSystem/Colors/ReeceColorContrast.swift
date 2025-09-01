//
//  ReeceColorContrast.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 31/08/25.
//
#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif
import SwiftUI

public enum ReeceColorContrast {
    /// Devuelve un color de texto (blanco/negro) con buen contraste sobre `background`.
    public static func preferredLabelColor(
        over background: Color,
        scheme: ColorScheme? = nil,
        threshold: Double = 0.57
    ) -> Color {
        guard let hex = ReeceColorExport.hexString(for: background, scheme: scheme),
              let bg = UIColor(Color(hex: hex)).cgColor.converted(
                    to: CGColorSpace(name: CGColorSpace.sRGB)!,
                    intent: .defaultIntent, options: nil),
              let comps = bg.components, comps.count >= 3
        else { return .white }

        let r = Double(comps[0]), g = Double(comps[1]), b = Double(comps[2])
        let luminance = 0.2126*r + 0.7152*g + 0.0722*b
        return luminance > threshold ? .black : .white
    }
}
