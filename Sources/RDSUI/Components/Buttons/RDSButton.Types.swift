//
//  RDSButton.Types.swift
//  RDSUI
//
//  Created by Carlos Lopez on 05/09/25.
//
//  Notes:
//  - Public enums constitute the stable API surface consumed by apps.
//  - `RDSButtonPalette` is an immutable value type describing resolved colors for a given configuration.
//

import SwiftUI

// MARK: - Variants & Types

/// Visual variant of the button.
///
/// Variants control the overall look-and-feel (fill vs outline) and map to different
/// color tokens in the palette provider.
public enum RDSButtonVariant: Equatable {
    /// Filled button with strong emphasis.
    case primary
    /// Outline-like button; lighter emphasis than `.primary`.
    case secondary
    /// Alternative filled button used for contextual emphasis.
    case alternative
}

/// Visual presentation **type** inside a variant.
///
/// Types let a given variant render either as a standard button or as a text-only style.
public enum RDSButtonType: Equatable {
    /// Standard button for the chosen variant (filled or outlined depending on variant).
    case `default`
    /// Text-only style (e.g., link-like button) following the design system rules.
    case textLink
}

// MARK: - Size

/// Fixed layout configurations (width/height and icon placement).
///
/// Only `.iconLeft` and `.iconRight` render the optional `icon` if provided.
public enum RDSButtonSize: Equatable {
    /// 135x40, no icon.
    case `default`
    /// 151x56, no icon.
    case large
    /// 108x30, no icon.
    case small
    /// 148x40, icon leading.
    case iconLeft
    /// 148x40, icon trailing.
    case iconRight
}

// MARK: - State

/// External, design-specified control state.
///
/// Drives interactivity and the selected palette.
public enum RDSButtonState: Equatable {
    /// Normal, enabled, idle.
    case normal
    /// Pressed/highlighted/hovered state (platform-dependent visual feedback).
    case highlighted
    /// Non-interactive and de-emphasized.
    case disabled
    /// Busy state; interaction is blocked; a spinner is typically shown.
    case loading
    /// Positive acknowledgment state (e.g., success after an action).
    case confirmed
}
