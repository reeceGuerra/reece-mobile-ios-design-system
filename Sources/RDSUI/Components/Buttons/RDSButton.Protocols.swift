//
//  RDSButton.Protocols.swift
//  RDSUI
//
//  Created by Carlos Lopez on 05/09/25.
//

import SwiftUI

// MARK: - Button Providers (Contracts)

/**
 A palette that describes the visual skin of the button for a given configuration.

 Providers must return a palette that is **pure** with respect to the input parameters:
 same (variant, type, state) → same output, without side effects.

 Notes:
 - The decision to render `.highlighted` while pressing/hovering/focusing is handled
   by the `ButtonStyle` (interaction layer), not by the provider. Providers only map
   (variant, type, *effective* state) to colors and underline flags.
 */
public struct RDSButtonPalette {
    /// Background color of the button surface.
    public let backgroundColor: Color
    /// Border color of the button surface.
    public let borderColor: Color
    /// Foreground color used for text and icons.
    public let selectionColor: Color
    /// Whether the text should be underlined (typically for TextLink types).
    public let underline: Bool

    /// Creates a palette instance.
    /// - Parameters:
    ///   - backgroundColor: Background color.
    ///   - borderColor: Border color.
    ///   - selectionColor: Foreground color for text/icon.
    ///   - underline: Whether the text is underlined.
    public init(
        backgroundColor: Color,
        borderColor: Color,
        selectionColor: Color,
        underline: Bool
    ) {
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.selectionColor = selectionColor
        self.underline = underline
    }
}

/**
 Provides button palettes for any (variant, type, state) combination.

 Implementations are expected to be **stateless** or behave as pure functions with
 respect to input parameters. If they need environmental information (e.g., color
 scheme), it should be passed at initialization and **not** mutated during rendering.
 */
public protocol RDSButtonPaletteProvider {
    /**
     Resolves the effective palette (colors and underline) for the given configuration.

     - Parameters:
       - variant: The visual variant, e.g. `.primary`, `.secondary`, `.alternative`.
       - type: The inner type within the variant, e.g. `.default`, `.textLink`.
       - state: The **effective** visual state, already decided by the interaction layer
                (e.g., normal/highlighted/disabled/confirmed). Providers must **not**
                inspect gestures; they only map this value to tokens.
     - Returns: A `RDSButtonPalette` describing background, border, selection and underline.
     */
    @MainActor
    func palette(
        for variant: RDSButtonVariant,
        type: RDSButtonType,
        state: RDSButtonState
    ) -> RDSButtonPalette
}

/**
 Provides typography tokens for each fixed button size.

 Implementations typically map `RDSButtonSize` to a text style token and a minimum
 scale factor so titles can shrink gracefully within fixed widths.
 */
public protocol RDSButtonTypographyProvider {
    /**
     Resolves the text style token (font, size, weight, letter spacing) used by the title.

     - Parameter size: The fixed size of the button.
     - Returns: A text style token compatible with the design system.
     */
    @MainActor
    func textStyleToken(for size: RDSButtonSize) -> ReeceTextStyleToken

    /**
     Resolves the minimum scale factor applied to the title.

     - Parameter size: The fixed size of the button.
     - Returns: A factor in `(0, 1]` used by `minimumScaleFactor(_:)` to prevent truncation.
     */
    @MainActor
    func minimumScaleFactor(for size: RDSButtonSize) -> CGFloat
}
