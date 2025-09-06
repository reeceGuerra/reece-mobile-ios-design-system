//
//  RDSButton.Protocols.swift
//  RDSUI
//
//  Created by Carlos Lopez on 05/09/25.
//

import SwiftUI

/// Provides palettes for any (variant, type, state) combination.
/// Supply your own to theme/brand the button without modifying the view.
@MainActor
public protocol RDSButtonPaletteProvider {
    /// Returns the palette for a given configuration.
    /// - Parameters:
    ///   - variant: The visual variant.
    ///   - type: The type within the variant.
    ///   - state: The visual state.
    /// - Returns: The resolved palette.
    func palette(
        for variant: RDSButtonVariant,
        type: RDSButtonType,
        state: RDSButtonState
    ) -> RDSButtonPalette
}

// MARK: - Typography (Token-based)

/// Provides the text style for each button size.
/// By default it returns system fonts sized to match typical "buttonM" / "buttonS" styles.
/// Replace the implementation to wire your `RDSTypography` tokens.
public protocol RDSButtonTypographyProvider {
    /// Returns the RDSUI `textStyleToken` to be used for a given button size.
    /// - Parameter size: The RDSButtonSize.
    /// - Returns: A `RDSTextStyleToken` to style the title text.
    func textStyleToken(for size: RDSButtonSize) -> RDSTextStyleToken
    
    /// Whether the text should be scaled down slightly to prevent truncation on fixed widths.
    /// - Parameter size: The RDSButtonSize.
    func minimumScaleFactor(for size: RDSButtonSize) -> CGFloat
}
