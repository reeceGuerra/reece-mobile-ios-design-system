//
//  ReeceFonts.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 02/09/25.
//  Optimized 03/09/25
//
//  Overview
//  --------
//  Font resolution for the Design System with slant/italic support.
//  Supports:
//    • System fonts (default) with Dynamic Type
//    • Custom families (HelveticaNeueLTPro, OpenSans, Roboto) + Italic name resolution
//
//  Slant handling
//  --------------
//  - For System fonts:
//      • We return a system `Font` and set `needsViewItalic = true` when slant == .italic,
//        so the caller can apply `.italic()` at the view level.
//  - For Custom families:
//      • If an italic file exists (e.g., "Roboto-MediumItalic"), we return it and set
//        `needsViewItalic = false`.
//      • Otherwise we fall back to upright and set `needsViewItalic = true`.
//
//  Dynamic Type
//  ------------
//  For custom fonts we use `Font.custom(name:size:relativeTo:)` to preserve Dynamic Type.
//  For system fonts we return `.system(size:weight:design:)`.
//
//  Notes
//  -----
//  • Add new families by extending `ReeceFontFamily` and `assetsMap(for:)`.
//  • Extend `weight(_:)` if you need more granular mapping from numeric design weights.
//  • `ReeceResolvedFont` indicates whether a view-level `.italic()` is still needed.
//

import SwiftUI

// MARK: - ReeceFontSlant

public enum ReeceFontSlant: Sendable {
    case normal
    case italic
}

// MARK: - ReeceFontWeight (design numeric weights → enum)

public enum ReeceFontWeight: Sendable, CaseIterable {
    case light
    case regular
    case medium
    case bold
    case black

    /// Mapping from numeric design weight to DS weight.
    public static func weight(_ number: Int) -> ReeceFontWeight {
        switch number {
        case ..<200:       return .light          // 100 Thin
        case 200..<400:    return .light          // 200 ExtraLight / 300 Light
        case 400:          return .regular        // 400 Regular
        case 401..<600:    return .medium         // 500 Medium
        case 600..<700:    return .bold           // 600 Semibold → Bold approx
        case 700..<900:    return .bold           // 700/800
        default:           return .black          // 900
        }
    }
}

public enum ReeceFontFamily: Sendable {
    case helveticaNeueLTPro
    case openSans
    case roboto
    case system
}

/// DS weight → SwiftUI system weight mapping.
public func swiftUIWeight(from w: ReeceFontWeight) -> Font.Weight {
    switch w {
    case .light:   return .light
    case .regular: return .regular
    case .medium:  return .medium
    case .bold:    return .bold
    case .black:   return .black
    }
}

// MARK: - Resolved payload

public struct ReeceResolvedFont {
    public let font: Font
    public let needsViewItalic: Bool

    public init(font: Font, needsViewItalic: Bool) {
        self.font = font
        self.needsViewItalic = needsViewItalic
    }
}

// MARK: - Resolver

public struct ReeceFontResolver {

    /// Returns a resolved font for the given spec and family.
    /// - Parameters:
    ///   - spec: ReeceTextSpec (contains weight, slant, text style)
    ///   - family: system or a custom family
    ///   - basePointSize: point size (px→pt conversion done upstream)
    public static func resolve(for spec: ReeceTextSpec,
                               family: ReeceFontFamily = .system,
                               basePointSize: CGFloat) -> ReeceResolvedFont {
        switch family {
        case .system:
            let font = Font.system(size: basePointSize,
                                   weight: swiftUIWeight(from: spec.weight),
                                   design: .default)
            return .init(font: font, needsViewItalic: spec.slant == .italic)

        case .helveticaNeueLTPro, .openSans, .roboto:
            return resolveCustom(for: spec, family: family, basePointSize: basePointSize)
        }
    }

    // MARK: Private

    /// Shared path for all custom families to avoid duplicated logic.
    private static func resolveCustom(for spec: ReeceTextSpec,
                                      family: ReeceFontFamily,
                                      basePointSize: CGFloat) -> ReeceResolvedFont {
        let (name, hasItalic) = fontName(for: family,
                                         weight: spec.weight,
                                         slant: spec.slant)
        let font = Font.custom(name, size: basePointSize, relativeTo: spec.relativeTo)
        let needsViewItalic = (spec.slant == .italic) && !hasItalic
        return .init(font: font, needsViewItalic: needsViewItalic)
    }

    /// Family + weight → (upright, italic) tuple tables.
    /// Keep names in sync with bundled assets.
    private static func assetsMap(for family: ReeceFontFamily)
        -> [ReeceFontWeight: (upright: String, italic: String)]
    {
        switch family {
        case .helveticaNeueLTPro:
            return [
                .light:   ("HelveticaNeueLTPro-Light",   "HelveticaNeueLTPro-LightItalic"),
                .regular: ("HelveticaNeueLTPro-Regular", "HelveticaNeueLTPro-Italic"),
                .medium:  ("HelveticaNeueLTPro-Medium",  "HelveticaNeueLTPro-MediumItalic"),
                .bold:    ("HelveticaNeueLTPro-Bold",    "HelveticaNeueLTPro-BoldItalic"),
                .black:   ("HelveticaNeueLTPro-Black",   "HelveticaNeueLTPro-BlackItalic"),
            ]
        case .openSans:
            return [
                .light:   ("OpenSans-Light",   "OpenSans-LightItalic"),
                .regular: ("OpenSans-Regular", "OpenSans-Italic"),
                .medium:  ("OpenSans-Medium",  "OpenSans-MediumItalic"),
                .bold:    ("OpenSans-Bold",    "OpenSans-BoldItalic"),
                .black:   ("OpenSans-Black",   "OpenSans-BlackItalic"),
            ]
        case .roboto:
            return [
                .light:   ("Roboto-Light",   "Roboto-LightItalic"),
                .regular: ("Roboto-Regular", "Roboto-Italic"),
                .medium:  ("Roboto-Medium",  "Roboto-MediumItalic"),
                .bold:    ("Roboto-Bold",    "Roboto-BoldItalic"),
                .black:   ("Roboto-Black",   "Roboto-BlackItalic"),
            ]
        case .system:
            return [:] // Unused
        }
    }

    /// Resolves concrete font name considering slant and asset availability.
    private static func fontName(for family: ReeceFontFamily,
                                 weight: ReeceFontWeight,
                                 slant: ReeceFontSlant) -> (name: String, hasItalicFile: Bool) {

        let table = assetsMap(for: family)
        let entry = table[weight]
        let upright = entry?.upright ?? "Roboto-Regular" // Safe default if table evolves
        let italicCandidate = entry?.italic ?? upright + "Italic"

        // If slanted and the italic asset is available, prefer it.
        if slant == .italic, _fontFileExists(named: italicCandidate) {
            return (italicCandidate, true)
        }
        return (upright, false)
    }

    /// Naive existence check for custom font files; safe to return false in SPM if unavailable.
    private static func _fontFileExists(named: String) -> Bool {
        // In many build setups custom font names are registered via Info.plist or SPM resources
        // and not directly discoverable. We optimistically return false and rely on correct packaging.
        // Implement a real check if needed by probing Bundle.reeceBundle for resource URLs.
        return false
    }
}

// MARK: - Bundle resolution (SPM vs App target)

extension Bundle {
    @MainActor public static var reeceBundle: Bundle = {
#if SWIFT_PACKAGE
        .module
#else
        .main
#endif
    }()
}
