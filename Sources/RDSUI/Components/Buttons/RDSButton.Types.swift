//
//  RDSButton.Types.swift
//  RDSUI
//
//  Created by Carlos Lopez on 05/09/25.
//

import SwiftUI

// MARK: - RDSButton Public API

/// Visual variant of the button.
/// - Primary: Solid background + border, selection color for text/icon.
/// - Secondary: Outline-like; text/icon/border share color; background is white/clear.
/// - Alternative: Solid background + border, selection color for text/icon.
public enum RDSButtonVariant: Equatable {
    case primary
    case secondary
    case alternative
}

/// Visual type inside a variant.
/// - default: Standard filled/outlined button depending on variant.
/// - textLink: Text-only style as defined by design system rules.
public enum RDSButtonType: Equatable {
    case `default`
    case textLink
}

/// Fixed layout configurations (width/height and icon placement).
/// Only `.iconLeft` and `.iconRight` render an icon if provided.
public enum RDSButtonSize: Equatable {
    case `default`    // 135x40, no icon
    case large        // 151x56, no icon
    case small        // 108x30, no icon
    case iconLeft     // 148x40, icon leading
    case iconRight    // 148x40, icon trailing
}

/// External button state as specified by design.
/// - normal: Default visual state.
/// - highlighted: Pressed/hovered/highlighted visual state.
/// - disabled: Non-interactive. Same interaction as `loading`.
/// - loading: Non-interactive with a centered spinner (uses `selectionColor` as tint).
/// - confirmed: Success acknowledgment visual state.
public enum RDSButtonState: Equatable {
    case normal
    case highlighted
    case disabled
    case loading
    case confirmed
}

/// Immutable color palette used by `RDSButton`.
/// `selectionColor` is applied to both text and icon.
/// `underline` is used for text decoration (e.g., Primary.TextLink).
public struct RDSButtonPalette: Equatable {
    public let backgroundColor: Color
    public let borderColor: Color
    public let selectionColor: Color
    public let underline: Bool
    
    /// Initializes a palette.
    /// - Parameters:
    ///   - backgroundColor: Color for the button background.
    ///   - borderColor: Color for the 1pt border stroke.
    ///   - selectionColor: Color for text and icon (and spinner tint in `loading`).
    ///   - underline: Whether the title is underlined.
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
