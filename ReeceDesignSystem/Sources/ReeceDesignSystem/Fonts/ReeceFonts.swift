//
//  ReeceFonts.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 02/09/25.
//
//  Overview
//  --------
//  Font resolution for the Design System with slant/italic support.
//  Supports:
//    • System fonts (default) with Dynamic Type
//    • Roboto custom family (Light/Regular/Medium shipped) + Italic name resolution
//
//  Slant handling
//  --------------
//  - For System fonts:
//      • We return a system `Font` and set `needsViewItalic = true` when slant == .italic,
//        so the caller can apply `.italic()` at the view level.
//  - For Roboto:
//      • If you have italic files (e.g., "Roboto-RegularItalic", "Roboto-MediumItalic"),
//        we return the exact custom font and set `needsViewItalic = false`.
//      • If italic variants are missing, we fallback to the upright file and set
//        `needsViewItalic = true` (so `.italic()` can be applied as a visual fallback).
//
//  Dynamic Type
//  ------------
//  For custom fonts we use `Font.custom(name:size:relativeTo:)` to preserve Dynamic Type.
//  For system fonts we return `.system(size:weight:design:)` and rely on usage-time scaling
//  via `UIFontMetrics`.
//
//  Notes
//  -----
//  • Extend `fontName(for:slant:)` when you add more Roboto weights or italic files.
//  • `ReeceResolvedFont` carries both the font and a flag indicating whether to apply
//    `.italic()` at the view layer.
//

import SwiftUI

// MARK: - ReeceFontSlant

/// Font slant descriptor used by the DS.
/// If your custom family provides italic files, the resolver will try to load them.
/// Otherwise, a view-level `.italic()` will be applied as a fallback.
public enum ReeceFontSlant: Sendable {
    case normal
    case italic
}

// MARK: - ReeceFontWeight (design numeric weights → enum)

/// Coarse DS weight that we derive from numeric design values (100..900).
/// Extend with more cases if you bundle additional font assets later.
public enum ReeceFontWeight: Sendable {
    case light
    case regular
    case medium
    case bold
    case black
    
    /// Mapping from numeric design weight to DS weight.
    /// Examples: 500 → .medium, 700 → .bold
    public static func weight(_ number: Int) -> ReeceFontWeight {
        switch number {
        case ..<200: return .light          // 100 Thin
        case 200..<400: return .light       // 200 ExtraLight / 300 Light
        case 400: return .regular           // 400 Regular
        case 401..<600: return .medium      // 500 Medium
        case 600..<700: return .bold        // 600 Semibold → Bold as approximation
        case 700..<900: return .bold        // 700 Bold / 800 ExtraBold
        default: return .black              // 900 Black
        }
    }
}

public enum ReeceFontFamily: Sendable {
    case system
    case roboto
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

/// Resolved font payload.
public struct ReeceResolvedFont {
    public let font: Font
    public let needsViewItalic: Bool
    
    public init(font: Font, needsViewItalic: Bool) {
        self.font = font
        self.needsViewItalic = needsViewItalic
    }
}

public struct ReeceFontResolver {
    /// Returns a resolved font for the given spec and family.
    /// - Parameters:
    ///   - spec: ReeceTextSpec (contains weight, slant, text style)
    ///   - family: system or roboto
    ///   - basePointSize: point size (px→pt conversion done upstream)
    public static func resolve(for spec: ReeceTextSpec,
                               family: ReeceFontFamily = .system,
                               basePointSize: CGFloat) -> ReeceResolvedFont {
        switch family {
        case .system:
            let f = Font.system(size: basePointSize, weight: swiftUIWeight(from: spec.weight), design: .default)
            let italic = (spec.slant == .italic)
            return .init(font: f, needsViewItalic: italic)
        case .roboto:
            let nameResolution = fontName(for: spec.weight, slant: spec.slant)
            let fontName = nameResolution.name
            let hasRealItalic = nameResolution.hasItalicFile
            let f = Font.custom(fontName, size: basePointSize, relativeTo: spec.relativeTo)
            // If we resolved an italic file, no need to apply view-level italic.
            return .init(font: f, needsViewItalic: !hasRealItalic && spec.slant == .italic)
        }
    }
    
    /// Maps DS weight + slant to the closest Roboto asset we ship.
    /// Extend this when you include more Roboto variants.
    private static func fontName(for weight: ReeceFontWeight,
                                 slant: ReeceFontSlant) -> (name: String, hasItalicFile: Bool) {
        // Base names we ship:
        //   Roboto-Light.ttf
        //   Roboto-Regular.ttf
        //   Roboto-Medium.ttf
        // Potential italic names if you add them:
        //   Roboto-LightItalic.ttf
        //   Roboto-Italic.ttf (Regular Italic)
        //   Roboto-MediumItalic.ttf
        
        let upright: String
        let italicCandidate: String
        
        switch weight {
        case .light:
            upright = "Roboto-Light"
            italicCandidate = "Roboto-LightItalic"
        case .regular:
            upright = "Roboto-Regular"
            italicCandidate = "Roboto-Italic"
        case .medium:
            upright = "Roboto-Medium"
            italicCandidate = "Roboto-MediumItalic"
        case .bold:
            upright = "Roboto-Bold"
            italicCandidate = "Roboto-BoldItalic"
        case .black:
            upright = "Roboto-Black"
            italicCandidate = "Roboto-BlackItalic"
        }
        
        // If slant == .italic and italic file is available, use it.
        if slant == .italic, _fontFileExists(named: italicCandidate) {
            return (italicCandidate, true)
        }
        // Otherwise, use upright and signal no real italic file.
        return (upright, false)
    }
    
    /// Naive existence check for custom font files; safe to return false in SPM if unavailable.
    private static func _fontFileExists(named: String) -> Bool {
        // In many build setups custom font names are registered via Info.plist or SPM resources
        // and not directly discoverable. We optimistically return false and rely on correct packaging.
        // If you want to implement a real check, load from Bundle.reeceBundle URLs as needed.
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
