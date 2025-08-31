//
//  ReeceColorExport.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 31/08/25.
//


// Sources/ReeceDesignSystem/Colors/ReeceColorExport.swift
import SwiftUI

public enum ReeceColorExport {
    /// Devuelve "#RRGGBB" o "#RRGGBBAA" para un `Color`.
    /// - Parameters:
    ///   - color: Color de SwiftUI (puede ser dinámico).
    ///   - scheme: Si se pasa, se resuelve con Light/Dark explícito; si es nil, se usa la configuración del sistema.
    ///   - includeAlpha: Si `true`, incluye componente alpha.
    /// - Returns: Cadena HEX o `nil` si el color no es convertible a sRGB.
    public static func hexString(
        for color: Color,
        scheme: ColorScheme? = nil,
        includeAlpha: Bool = false
    ) -> String? {
        #if canImport(UIKit)
        let uiBase = UIColor(color)
        let traits = scheme.map { UITraitCollection(userInterfaceStyle: $0 == .dark ? .dark : .light) }
        let ui = traits.map { uiBase.resolvedColor(with: $0) } ?? uiBase

        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard ui.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }

        let R = Int(round(r * 255)), G = Int(round(g * 255)), B = Int(round(b * 255)), A = Int(round(a * 255))
        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X", R, G, B, A)
        } else {
            return String(format: "#%02X%02X%02X", R, G, B)
        }
        #else
        return nil
        #endif
    }
}
