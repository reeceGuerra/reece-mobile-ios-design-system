//
//  ReeceFonts.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 02/09/25.
//
//  Font family resolution with italic support, known families (Roboto),
//  and helpers to bridge Figma numeric weights to semantic weights.
//
//  Notes:
//  - System fallback uses .system(relativeTo:) and applies italic/weight at view level.
//  - Named/custom families use Font.custom(name:size:relativeTo:) to keep Dynamic Type.
//

import SwiftUI

// MARK: - Public API

@MainActor
public enum ReeceFonts {

    /// Active font family (set once at app start).
    public static var activeFamily: ReeceFontFamily = .systemDefault

    /// Optional hook in case you want to do validation/logging later.
    public static func registerBundledFonts() {
        // SPM resource inclusion is enough for SwiftUI + Font.custom
    }

    /// Resolve a SwiftUI `Font` + metadata for italic/weight handling.
    public static func resolveFont(
        weight: ReeceFontWeight,
        size: CGFloat,
        relativeTo: Font.TextStyle,
        slant: ReeceFontSlant = .normal
    ) -> ReeceResolvedFont {
        switch activeFamily {
        case .systemDefault:
            let base = Font.system(relativeTo, design: .default)
            return .init(font: base, needsViewItalic: (slant == .italic), systemWeight: weight.swiftUI)

        case .named(let known):
            let name = known.resolveName(for: weight, slant: slant)
            let custom = Font.custom(name, size: size, relativeTo: relativeTo)
            return .init(font: custom, needsViewItalic: false, systemWeight: nil)

        case .custom(let prefix):
            let name = ReeceFontFamily.custom(prefix).resolveName(for: weight, slant: slant) ?? prefix
            let custom = Font.custom(name, size: size, relativeTo: relativeTo)
            return .init(font: custom, needsViewItalic: false, systemWeight: nil)
        }
    }
}

// MARK: - Families & Traits

public enum ReeceKnownFontFamily: String, CaseIterable, Sendable {
    case roboto = "Roboto"   // Roboto-Regular/Italic/Medium/MediumItalic/Bold/BoldItalic/Black...

    fileprivate func resolveName(for weight: ReeceFontWeight, slant: ReeceFontSlant) -> String {
        let base: String
        switch self {
        case .roboto:
            switch weight {
            case .light:   base = "Roboto-Light"
            case .regular: base = "Roboto-Regular"
            case .medium:  base = "Roboto-Medium"
            case .bold:    base = "Roboto-Bold"
            case .black:   base = "Roboto-Black"
            }
        }
        return slant == .italic ? base + "Italic" : base
    }
}

public enum ReeceFontFamily: Sendable, Equatable {
    case systemDefault
    case named(ReeceKnownFontFamily)
    case custom(String)

    func resolveName(for weight: ReeceFontWeight, slant: ReeceFontSlant) -> String? {
        switch self {
        case .systemDefault:
            return nil
        case .named(let known):
            return known.resolveName(for: weight, slant: slant)
        case .custom(let prefix):
            let base: String
            switch weight {
            case .light:   base = "\(prefix)-Light"
            case .regular: base = "\(prefix)-Regular"
            case .medium:  base = "\(prefix)-Medium"
            case .bold:    base = "\(prefix)-Bold"
            case .black:   base = "\(prefix)-Black"
            }
            return slant == .italic ? base + "Italic" : base
        }
    }
}

public enum ReeceFontWeight: Sendable {
    case light
    case regular
    case medium
    case bold
    case black

    var swiftUI: Font.Weight {
        switch self {
        case .light:   return .light
        case .regular: return .regular
        case .medium:  return .medium
        case .bold:    return .bold
        case .black:   return .black
        }
    }
    
    /// Map Figma numeric weights (100...900) to semantic weights.
    ///
    /// The mapping is tuned for Roboto (classic set has Light/Regular/Medium/Bold/Black).
    /// Adjust if you add a Semibold face.
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

public enum ReeceFontSlant: Sendable { case normal, italic }

// MARK: - Resolution Result

public struct ReeceResolvedFont: Sendable {
    public let font: Font
    public let needsViewItalic: Bool
    public let systemWeight: Font.Weight?
    public init(font: Font, needsViewItalic: Bool, systemWeight: Font.Weight?) {
        self.font = font
        self.needsViewItalic = needsViewItalic
        self.systemWeight = systemWeight
    }
}

// MARK: - View helpers

public extension View {
    @ViewBuilder func reeceApplyItalicIfNeeded(_ enabled: Bool) -> some View {
        if enabled { self.italic() } else { self }
    }
    @ViewBuilder func reeceApplySystemWeightIfNeeded(_ weight: Font.Weight?) -> some View {
        if let w = weight { self.fontWeight(w) } else { self }
    }
}

extension Bundle {
    @MainActor static var reeceBundle: Bundle = {
        #if SWIFT_PACKAGE
        .module
        #else
        .main
        #endif
    }()
}
