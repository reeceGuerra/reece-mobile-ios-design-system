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
/// This view is intentionally **minimal**: it keeps only the public API and body.
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
    ///   - paletteProvider: Provider for visual palettes. Defaults to `RDSButtonTokens()`.
    ///   - typographyProvider: Provider for text tokens. Defaults to `RDSButtonTokens()`.
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
        let palette = paletteProvider.palette(for: variant, type: type, state: state)
        let dimensions = Self.dimensions(for: size)
        let isInteractive = (state != .disabled && state != .loading)
        
        Button(action: { if isInteractive { action() } }) {
            content(palette: palette) // Implemented in RDSButton.Layout.swift
                .frame(width: dimensions.width, height: dimensions.height, alignment: .center)
        }
        .buttonStyle(.plain) // We fully control visuals.
        .allowsHitTesting(isInteractive)
        .background(palette.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .stroke(palette.borderColor, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 2, style: .continuous))
    }
}
