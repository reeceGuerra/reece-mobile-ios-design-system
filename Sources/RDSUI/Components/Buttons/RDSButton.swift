//
//  RDSButton.swift
//  RDSUI
//
//  Created by Carlos Lopez on 05/09/25.
//

import SwiftUI

// MARK: - RDSButton

/// A design-system button that renders **fixed sizes** and **themed palettes** based on
/// `variant`, `type`, and `state`. The appearance (colors, underline) is sourced via
/// ``RDSButtonPaletteProvider`` and the text styling via ``RDSButtonTypographyProvider``.
///
/// This view is intentionally **minimal**: it keeps only the public API and delegates
/// visual feedback (e.g., pressed/highlighted) to a `ButtonStyle`.
/// Layout helpers and metrics are implemented in `RDSButton.Layout.swift`,
/// Enums and tokens live in `RDSButton.Types.swift` and `RDSButtonTokens.swift`.
///
/// ### Usage
/// ```swift
/// RDSButton(
///     title: "Continue",
///     variant: .primary,
///     type: .default,
///     size: .default,
///     state: .normal,
///     icon: Image(systemName: "arrow.right"),
///     action: { /* perform action */ }
/// )
/// ```
public struct RDSButton: View {
    
    // MARK: Public API
    
    /// Visible text label.
    public let title: String
    
    /// Visual variant: `.primary`, `.secondary`, `.alternative`.
    public let variant: RDSButtonVariant
    
    /// Visual type inside a variant: `.default` or `.textLink`.
    public let type: RDSButtonType
    
    /// Fixed layout configuration (width/height and icon placement).
    public let size: RDSButtonSize
    
    /// External state of the control (drives palette and interactivity).
    public let state: RDSButtonState
    
    /// Optional icon. It is shown only for `.iconLeft` and `.iconRight` sizes.
    public let icon: Image?
    
    /// Action executed on tap when interactive.
    public let action: () -> Void
    
    // MARK: Internal dependencies (injected)
    
    /// Supplies the palette (background/border/selection/underline) for any configuration.
    internal let paletteProvider: RDSButtonPaletteProvider
    
    /// Supplies text tokens and scale behavior for each size.
    internal let typographyProvider: RDSButtonTypographyProvider
    
    // MARK: - Init
    
    /// Creates an `RDSButton`.
    /// - Parameters:
    ///   - title: Visible text.
    ///   - variant: Button variant. Defaults to `.primary`.
    ///   - type: Button type. Defaults to `.default`.
    ///   - size: Layout preset. Defaults to `.default`.
    ///   - state: External state. Defaults to `.normal`.
    ///   - icon: Optional icon. Only rendered for `.iconLeft`/`.iconRight` sizes.
    ///   - paletteProvider: Provider for visual palettes. Defaults to `RDSButtonTokensPaletteProvider()`.
    ///   - typographyProvider: Provider for text tokens. Defaults to `RDSButtonTypographyTokens()`.
    ///   - action: Closure executed on tap.
    public init(
        title: String,
        variant: RDSButtonVariant = .primary,
        type: RDSButtonType = .default,
        size: RDSButtonSize = .default,
        state: RDSButtonState = .normal,
        icon: Image? = nil,
        paletteProvider: RDSButtonPaletteProvider = RDSButtonTokensPaletteProvider(),
        typographyProvider: RDSButtonTypographyProvider = RDSButtonTypographyTokens(),
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.type = type
        self.size = size
        self.state = state
        self.icon = icon
        self.paletteProvider = paletteProvider
        self.typographyProvider = typographyProvider
        self.action = action
    }
    
    // MARK: - View
    
    public var body: some View {
        // Preserve existing “interactivity” rules: disabled and loading are not tappable.
        let isInteractive = (state != .disabled && state != .loading)
        
        Button(action: { if isInteractive { action() } }) {
            // We delegate full rendering to the style to react to `isPressed`.
            // The label here is intentionally empty.
            EmptyView()
        }
        .buttonStyle(
            RDSPressAwareButtonStyle(
                title: title,
                icon: icon,
                variant: variant,
                type: type,
                size: size,
                state: state,
                paletteProvider: paletteProvider,
                typographyProvider: typographyProvider,
                isInteractive: isInteractive
            )
        )
        .allowsHitTesting(isInteractive)
    }
}

// MARK: - Press-Aware ButtonStyle

/// A `ButtonStyle` that renders the RDS button visuals and switches to the
/// `.highlighted` palette **while the control is pressed**, but only when the
/// external `state == .normal`.
///
/// This style centralizes the visual skin (background, border, text/icon color,
/// underline and fixed dimensions), allowing UI feedback to react to the user
/// interaction through `configuration.isPressed`.
@MainActor
internal struct RDSPressAwareButtonStyle: ButtonStyle {
    
    // MARK: Configuration Inputs
    
    /// Text label to render.
    let title: String
    /// Optional leading/trailing icon (depending on `size`).
    let icon: Image?
    /// Variant selection.
    let variant: RDSButtonVariant
    /// Type selection.
    let type: RDSButtonType
    /// Fixed size (width/height and icon placement).
    let size: RDSButtonSize
    /// External state (may be overridden to `.highlighted` when pressed).
    let state: RDSButtonState
    /// Palette provider that resolves colors and underline behavior.
    let paletteProvider: RDSButtonPaletteProvider
    /// Typography provider that resolves text tokens and minimum scale factor.
    let typographyProvider: RDSButtonTypographyProvider
    /// Interactivity flag (e.g., disabled/loading are non-interactive).
    let isInteractive: Bool
    
    // MARK: - ButtonStyle
    
    /// Builds the visual body for the button using shared renderers from
    /// `RDSButton.Layout.swift` to ensure a single source of truth (SRP/DRY).
    ///
    /// - Parameter configuration: Provides the press-state via `isPressed`.
    /// - Returns: A view representing the complete button surface.
    func makeBody(configuration: Configuration) -> some View {
        let effectiveState = effectiveState(
            externalState: state,
            isPressed: configuration.isPressed
        )
        
        let palette = paletteProvider.palette(
            for: variant,
            type: type,
            state: effectiveState
        )
        
        // Reuse shared renderers: label (spinner/text/icon) + surface (bg/border/clip/opacity)
        let label = RDSButton.buildLabel(
            title: title,
            icon: icon,
            size: size,
            state: state, // spinner/line-limit driven by external state (not by pressed)
            palette: palette,
            typographyProvider: typographyProvider
        )
        
        return RDSButton
            .buildSurface(label, size: size, state: state, palette: palette)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
    
    // MARK: - Helpers
    
    /// Computes the effective visual state for the button skin.
    ///
    /// - Parameters:
    ///   - externalState: The externally provided `RDSButtonState`.
    ///   - isPressed: A Boolean that indicates if the control is currently pressed.
    /// - Returns: `.highlighted` when `externalState == .normal` and `isPressed == true`;
    ///            otherwise returns `externalState`.
    private func effectiveState(
        externalState: RDSButtonState,
        isPressed: Bool
    ) -> RDSButtonState {
        guard externalState == .normal else { return externalState }
        return isPressed ? .highlighted : .normal
    }
}
