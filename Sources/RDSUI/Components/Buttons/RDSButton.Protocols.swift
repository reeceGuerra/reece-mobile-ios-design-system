//
//  RDSButton.Protocols.swift
//  RDSUI
//
//  Created by Carlos Lopez on 05/09/25.
//

import SwiftUI

// MARK: - Palette Provider

/// Provides palettes for a given button configuration.
///
/// Conform to this protocol to customize the look of ``RDSButton`` without
/// modifying the view itself. Typical implementations map design tokens
/// (e.g., from `RDSColors`) to concrete SwiftUI colors.
@MainActor
public protocol RDSButtonPaletteProvider {
    /// Resolves a palette for the specified configuration.
    /// - Parameters:
    ///   - variant: Visual variant (e.g., `.primary`, `.secondary`, `.alternative`).
    ///   - type: Visual type inside the variant (e.g., `.default`, `.textLink`).
    ///   - state: External control state.
    /// - Returns: A resolved ``RDSButtonPalette``.
    func palette(for variant: RDSButtonVariant,
                 type: RDSButtonType,
                 state: RDSButtonState) -> RDSButtonPalette
}

// MARK: - Typography Provider

/// Provides text style tokens and scale behavior for button sizes.
///
/// Conform to this protocol to connect your typography system to `RDSButton`.
public protocol RDSButtonTypographyProvider {
    /// Returns the text style token to use for a given size.
    func textStyleToken(for size: RDSButtonSize) -> RDSTextStyleToken
    
    /// Returns a minimum scale factor to mitigate truncation on fixed widths.
    func minimumScaleFactor(for size: RDSButtonSize) -> CGFloat
}
