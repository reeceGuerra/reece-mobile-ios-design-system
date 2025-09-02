//
//  File.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 02/09/25.
//
//  Token API + Figma bridge API.
//  - Tokens: ReeceTypography.text(_:slant:)
//  - Figma:  ReeceTypography.figma(...), using px + % directly
//

import SwiftUI

// MARK: Tokens

public enum ReeceTextStyleToken: CaseIterable, Sendable {
    case h1B, h1M, h1R
    case h2B, h2M, h2R
    case h3B, h3M, h3R
    case h4B, h4M, h4R
    case h5B, h5M, h5R
    case buttonM, buttonS
    case body, caption
    case code
}

public struct ReeceTextStyle: Sendable {
    public let size: CGFloat        // base size (pt)
    public let weight: ReeceFontWeight
    public let relativeTo: Font.TextStyle
    public let slant: ReeceFontSlant

    @MainActor public func resolve() -> ReeceResolvedFont {
        ReeceFonts.resolveFont(weight: weight, size: size, relativeTo: relativeTo, slant: slant)
    }
}

@MainActor
public enum ReeceTypography {

    // --- Existing token scale (unchanged defaults) ---
    public static func text(_ token: ReeceTextStyleToken, slant: ReeceFontSlant = .normal) -> ReeceTextStyle {
        switch token {
        case .h1B: return .init(size: 48.83, weight: .weight(700), relativeTo: .headline, slant: slant)
        case .h1M: return .init(size: 48.83, weight: .weight(500), relativeTo: .headline, slant: slant)
        case .h1R: return .init(size: 48.83, weight: .weight(400), relativeTo: .headline, slant: slant)
            
        case .h2B: return .init(size: 39.06, weight: .weight(700), relativeTo: .headline, slant: slant)
        case .h2M: return .init(size: 39.06, weight: .weight(500), relativeTo: .headline, slant: slant)
        case .h2R: return .init(size: 39.06, weight: .weight(400), relativeTo: .headline, slant: slant)
            
        case .h3B: return .init(size: 31.25, weight: .weight(700), relativeTo: .subheadline, slant: slant)
        case .h3M: return .init(size: 31.25, weight: .weight(500), relativeTo: .subheadline, slant: slant)
        case .h3R: return .init(size: 31.25, weight: .weight(400), relativeTo: .subheadline, slant: slant)
            
        case .h4B: return .init(size: 25, weight: .weight(700), relativeTo: .subheadline, slant: slant)
        case .h4M: return .init(size: 25, weight: .weight(500), relativeTo: .subheadline, slant: slant)
        case .h4R: return .init(size: 25, weight: .weight(400), relativeTo: .subheadline, slant: slant)
            
        case .h5B: return .init(size: 20, weight: .weight(700), relativeTo: .subheadline, slant: slant)
        case .h5M: return .init(size: 20, weight: .weight(500), relativeTo: .subheadline, slant: slant)
        case .h5R: return .init(size: 20, weight: .weight(400), relativeTo: .subheadline, slant: slant)
            
        case .buttonM: return .init(size: 16, weight: .weight(500), relativeTo: .body, slant: slant)
        case .buttonS: return .init(size: 14, weight: .weight(500), relativeTo: .body, slant: slant)

        case .body: return .init(size: 16, weight: .weight(400), relativeTo: .body, slant: slant)
        case .caption: return .init(size: 12.8, weight: .weight(400), relativeTo: .caption, slant: slant)
        case .code: return .init(size: 12, weight: .weight(400), relativeTo: .caption2, slant: slant)
        }
    }
}
