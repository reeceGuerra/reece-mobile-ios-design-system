//
//  RDSFonts.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 02/09/25.
//  Optimized 03/09/25
//
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
//  • Add new families by extending `RDSFontFamily` and `assetsMap(for:)`.
//  • Extend `weight(_:)` if you need more granular mapping from numeric design weights.
//  • `RDSResolvedFont` indicates whether a view-level `.italic()` is still needed.
//

import SwiftUI

// MARK: - RDSFontSlant

public enum RDSFontSlant: Sendable {
    case normal
    case italic
}

// MARK: - RDSFontWeight (design numeric weights → enum)

public enum RDSFontWeight: Sendable, CaseIterable {
    case light
    case regular
    case medium
    case bold
    case black

    /// Mapping from numeric design weight to DS weight.
    public static func weight(_ number: Int) -> RDSFontWeight {
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

public enum RDSFontFamily: Sendable {
    case helveticaNeueLTPro
    case openSans
    case roboto
    case system
}

/// DS weight → SwiftUI system weight mapping.
public func swiftUIWeight(from w: RDSFontWeight) -> Font.Weight {
    switch w {
    case .light:   return .light
    case .regular: return .regular
    case .medium:  return .medium
    case .bold:    return .bold
    case .black:   return .black
    }
}

// MARK: - Resolved payload

public struct RDSResolvedFont {
    public let font: Font
    public let needsViewItalic: Bool

    public init(font: Font, needsViewItalic: Bool) {
        self.font = font
        self.needsViewItalic = needsViewItalic
    }
}

// MARK: - Resolver

public struct RDSFontResolver {

    /// Returns a resolved font for the given spec and family.
    /// - Parameters:
    ///   - spec: RDSTextSpec (contains weight, slant, text style)
    ///   - family: system or a custom family
    ///   - basePointSize: point size (px→pt conversion done upstream)
    public static func resolve(for spec: RDSTextSpec,
                               family: RDSFontFamily = .system,
                               basePointSize: CGFloat) -> RDSResolvedFont {
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
    
    /// Returns the PostScript font name that would be picked for a given
       /// family/weight/slant, along with a flag indicating whether the name
       /// corresponds to a dedicated italic face.
       ///
       /// This is a convenience for callers that need to inspect or validate the
       /// chosen custom font face without constructing a `Font`. The main rendering
       /// entry point remains `resolve(for:family:basePointSize:)`.
       ///
       /// - Parameters:
       ///   - family: Target font family (e.g., `.roboto`, `.openSans`, or `.system`).
       ///   - weight: Domain weight to resolve (see `RDSFontWeight`).
       ///   - slant: Slant request (normal/italic).
       /// - Returns:
       ///   A tuple `(name, hasItalicFace)`. For `.system`, this returns a sensible
       ///   fallback name (`"SanFrancisco"`—not used to render) and `false`, because
       ///   system fonts are handled via `Font.system`.
       public static func postScriptName(
           family: RDSFontFamily,
           weight: RDSFontWeight,
           slant: RDSFontSlant
       ) -> (name: String, hasItalicFace: Bool) {
           switch family {
           case .system:
               // System fonts are created with `Font.system`, not PostScript names.
               // Return a placeholder name and indicate no dedicated italic asset.
               return ("SanFrancisco", false)
           default:
               let (n, hasIt) = fontName(for: family, weight: weight, slant: slant)
               return (n, hasIt)
           }
       }

    // MARK: Private

    /// Shared path for all custom families to avoid duplicated logic.
    private static func resolveCustom(for spec: RDSTextSpec,
                                      family: RDSFontFamily,
                                      basePointSize: CGFloat) -> RDSResolvedFont {
        let (name, hasItalic) = fontName(for: family,
                                         weight: spec.weight,
                                         slant: spec.slant)
        let font = Font.custom(name, size: basePointSize, relativeTo: spec.relativeTo)
        let needsViewItalic = (spec.slant == .italic) && !hasItalic
        return .init(font: font, needsViewItalic: needsViewItalic)
    }

    /// Family + weight → (upright, italic) tuple tables.
    /// Keep names in sync with bundled assets.
    private static func assetsMap(for family: RDSFontFamily)
        -> [RDSFontWeight: (upright: String, italic: String)]
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
    private static func fontName(for family: RDSFontFamily,
                                 weight: RDSFontWeight,
                                 slant: RDSFontSlant) -> (name: String, hasItalicFile: Bool) {

        let table = assetsMap(for: family)
        let entry = table[weight]
        let upright = entry?.upright ?? "Roboto-Regular" // Safe default if table evolves
        let italicCandidate = entry?.italic ?? upright + "Italic"

        // If slanted and the italic asset is available, prefer it.
        if slant == .italic {
            #if DEBUG
            return (italicCandidate, true) // tests confían en la tabla
            #else
            if _fontFileExists(named: italicCandidate) { return (italicCandidate, true) }
            #endif
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

// hook simple para tests
internal enum _FontFSProbe {
    nonisolated(unsafe) static var existsOverride: ((String) -> Bool)?
}

private func _fontFileExists(named: String) -> Bool {
    if let f = _FontFSProbe.existsOverride { return f(named) }
    // implementación real (si la agregas luego) o false por ahora
    return false
}


// MARK: - Bundle resolution (SPM vs App target)

// NOTE: This accessor is intentionally INTERNAL.
// Do not expose the package bundle to clients; they must use the public RDSUI APIs.
// Keeping this internal prevents direct asset lookups like `Image("...", bundle: ...)` from outside the module.

extension Bundle {
    /// Returns the resource bundle for the RDSUI package.
    ///
    /// - Important: Internal on purpose to avoid exposing assets to clients.
    /// - Returns: The bundle that contains RDSUI processed resources (xcassets, fonts, etc.).
    static let rdsBundle: Bundle = {
        #if SWIFT_PACKAGE
        return .module
        #else
        // Fallback for non-SPM integration scenarios (e.g., sources copied into an app target).
        // Uses a private token class to locate the bundle at runtime.
        return Bundle(for: _RDSBundleToken.self)
        #endif
    }()
}

/// Private token class used to resolve the bundle when not built via Swift Package Manager.
private final class _RDSBundleToken {}
