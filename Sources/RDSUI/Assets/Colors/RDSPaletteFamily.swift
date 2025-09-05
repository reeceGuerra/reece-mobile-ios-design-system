//
//  PaletteFamily.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 01/09/25.
//
import SwiftUI

// MARK: - Abstractions
/// Contract for a color family that exposes a tone scale and light/dark palettes.
@MainActor
public protocol RDSPaletteFamily {
    associatedtype Tone: Hashable & Sendable
    static var light: [Tone: Color] { get }
    static var dark:  [Tone: Color] { get }
}

@MainActor
public extension RDSPaletteFamily {
    /// Resolves the effective color for the given tone & scheme.
    static func color(_ tone: Tone, using scheme: ColorScheme) -> Color {
        guard let light = light[tone], let dark = dark[tone] else {
            assertionFailure("Missing tone \(tone) in \(Self.self)")
            return Color.clear // safe fallback in release
        }
        return RDSColorEngine.pick(light: light, dark: dark, using: scheme)
    }
}
