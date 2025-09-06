//
//  RDSButton.swift
//  RDSUI
//
//  Created by Carlos Lopez on 05/09/25.
//

import SwiftUI

// MARK: - RDSButton View

/// Design-system button with fixed sizes, explicit palettes per state, and optional icon placement.
///
/// Usage example:
/// ```swift
/// RDSButton(
///     title: "Continue",
///     variant: .primary,
///     type: .default,
///     size: .iconRight,
///     state: .normal,
///     icon: Image(systemName: "chevron.right"),
///     action: { /* handle tap */ }
/// )
/// ```
///
/// Notes:
/// - `.disabled` and `.loading` states are **non-interactive** (hit testing is disabled).
/// - In `.loading`, content is replaced by a centered `ProgressView` tinted with `selectionColor`.
/// - Text underline is controlled by the palette (`underline`).
public struct RDSButton: View {
    
    // MARK: Public API
    
    public let title: String
    public let variant: RDSButtonVariant
    public let type: RDSButtonType
    public let size: RDSButtonSize
    public let state: RDSButtonState
    public let icon: Image?
    public let action: () -> Void
    
    public var paletteProvider: RDSButtonPaletteProvider
    public var typographyProvider: RDSButtonTypographyProvider
    
    /// Creates a new RDSButton.
    /// - Parameters:
    ///   - title: The button title (centered).
    ///   - variant: Visual variant (`primary`, `secondary`, `alternative`).
    ///   - type: Visual type within the variant (`default`, `textLink`).
    ///   - size: Fixed layout size (`default`, `large`, `small`, `iconLeft`, `iconRight`).
    ///   - state: Visual state (`normal`, `highlighted`, `disabled`, `loading`, `confirmed`).
    ///   - icon: Optional icon (`Image`). Only rendered for `.iconLeft` / `.iconRight`.
    ///   - paletteProvider: Palette resolver. Defaults to a stateless provider instance.
    ///   - typographyProvider: Typography resolver. Defaults to `RDSDefaultButtonTypography()`.
    ///   - action: Closure executed on tap (no-op in `disabled`/`loading`).
    public init(
        title: String,
        variant: RDSButtonVariant,
        type: RDSButtonType,
        size: RDSButtonSize,
        state: RDSButtonState,
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
    
    // MARK: - Body
    
    public var body: some View {
        let palette = paletteProvider.palette(for: variant, type: type, state: state)
        let dimensions = Self.dimensions(for: size)
        
        // Non-interactive states:
        let isInteractive = !(state == .disabled || state == .loading)
        
        Button(action: {
            guard isInteractive else { return }
            action()
        }) {
            ZStack {
                if state == .loading {
                    // Spinner centered, tinted with selectionColor.
                    ProgressView()
                        .tint(palette.selectionColor)
                } else {
                    content(palette: palette)
                }
            }
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
