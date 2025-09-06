//
//  RDSButton.swift
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
    
    // MARK: - Content
    
    @ViewBuilder
    private func content(palette: RDSButtonPalette) -> some View {
        HStack(spacing: 0) {
            if size == .iconLeft, let icon {
                iconView(icon, color: palette.selectionColor)
                Spacer().frame(width: 12)
            }
            
            Text(title)
                .rdsTextStyle(typographyProvider.textStyleToken(for: size))
                .minimumScaleFactor(typographyProvider.minimumScaleFactor(for: size))
                .foregroundStyle(palette.selectionColor)
                .underline(palette.underline)
                .lineLimit(1)
            
            if size == .iconRight, let icon {
                Spacer().frame(width: 12)
                iconView(icon, color: palette.selectionColor)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 24)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
    
    // MARK: - Helpers
    
    /// Renders the 20x20pt icon colored with `selectionColor`.
    private func iconView(_ image: Image, color: Color) -> some View {
        image
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .foregroundStyle(color)
            .accessibilityHidden(true)
    }
    
    /// Fixed dimensions per size.
    private static func dimensions(for size: RDSButtonSize) -> (width: CGFloat, height: CGFloat) {
        switch size {
        case .default:   return (135, 40)
        case .large:     return (151, 56)
        case .small:     return (108, 30)
        case .iconLeft:  return (148, 40)
        case .iconRight: return (148, 40)
        }
    }
}
