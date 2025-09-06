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

// MARK: - Default Palette Provider (Stateless & De-duplicated)

/// Default palette provider for RDSButton.
/// This implementation is **stateless** to be concurrency-friendly under strict checks.
/// It deduplicates repeated palettes using private helper methods and aliases.
/// Replace the `TODO` color placeholders with your `RDSColors` tokens.
public struct RDSDefaultButtonPalettes: RDSButtonPaletteProvider {

    public init() {}

    // MARK: Private Helpers (replace placeholders with RDSColors tokens)

    // Primary-like solids (used by Primary.Default & aliased by Alternative.Default)
    private func primaryDefaultNormal() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: Color(red: 0.00, green: 0.31, blue: 0.56), // TODO
            borderColor:     Color(red: 0.00, green: 0.31, blue: 0.56), // TODO
            selectionColor:  .white,                                     // TODO
            underline: false
        )
    }
    private func primaryDefaultHighlighted() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: Color(red: 0.00, green: 0.26, blue: 0.47), // TODO
            borderColor:     Color(red: 0.00, green: 0.26, blue: 0.47), // TODO
            selectionColor:  .white,                                     // TODO
            underline: false
        )
    }
    private func primaryDefaultDisabled() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: Color(red: 0.90, green: 0.93, blue: 0.96), // TODO
            borderColor:     Color(red: 0.90, green: 0.93, blue: 0.96), // TODO
            selectionColor:  Color(red: 0.60, green: 0.65, blue: 0.70), // TODO
            underline: false
        )
    }
    private func primaryDefaultConfirmed() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: Color(red: 0.00, green: 0.55, blue: 0.31), // TODO
            borderColor:     Color(red: 0.00, green: 0.55, blue: 0.31), // TODO
            selectionColor:  .white,                                     // TODO
            underline: false
        )
    }

    // Alternative.Default: custom normal; other states alias Primary.Default
    private func alternativeDefaultNormal() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: Color(red: 0.07, green: 0.44, blue: 0.75), // TODO
            borderColor:     Color(red: 0.07, green: 0.44, blue: 0.75), // TODO
            selectionColor:  .white,                                     // TODO
            underline: false
        )
    }

    // Secondary.Default (outline-like)
    private func secondaryDefaultNormal() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: .white,                                     // or .clear per DS
            borderColor:     Color(red: 0.00, green: 0.31, blue: 0.56),  // TODO
            selectionColor:  Color(red: 0.00, green: 0.31, blue: 0.56),  // TODO
            underline: false
        )
    }
    private func secondaryDefaultHighlighted() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: .white,                                     // or .clear
            borderColor:     Color(red: 0.00, green: 0.26, blue: 0.47),  // TODO
            selectionColor:  Color(red: 0.00, green: 0.26, blue: 0.47),  // TODO
            underline: false
        )
    }
    private func secondaryDefaultDisabled() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: .white,                                     // or .clear
            borderColor:     Color(red: 0.85, green: 0.88, blue: 0.92),  // TODO
            selectionColor:  Color(red: 0.60, green: 0.65, blue: 0.70),  // TODO
            underline: false
        )
    }
    private func secondaryDefaultConfirmed() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: .white,                                     // or .clear
            borderColor:     Color(red: 0.00, green: 0.55, blue: 0.31),  // TODO
            selectionColor:  Color(red: 0.00, green: 0.55, blue: 0.31),  // TODO
            underline: false
        )
    }

    // Primary.TextLink (underline = true; white/clear background/border)
    private func primaryTextLinkNormal() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: .white,                                     // or .clear
            borderColor:     .white,                                     // or .clear
            selectionColor:  Color(red: 0.00, green: 0.31, blue: 0.56),  // TODO
            underline: true
        )
    }
    private func primaryTextLinkHighlighted() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: .white,                                     // or .clear
            borderColor:     .white,                                     // or .clear
            selectionColor:  Color(red: 0.00, green: 0.26, blue: 0.47),  // TODO
            underline: true
        )
    }
    private func primaryTextLinkDisabled() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: .white,                                     // or .clear
            borderColor:     .white,                                     // or .clear
            selectionColor:  Color(red: 0.60, green: 0.65, blue: 0.70),  // TODO
            underline: true
        )
    }
    private func primaryTextLinkConfirmed() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: .white,                                     // or .clear
            borderColor:     .white,                                     // or .clear
            selectionColor:  Color(red: 0.00, green: 0.55, blue: 0.31),  // TODO
            underline: true
        )
    }

    // Secondary.TextLink (underline = false; white/clear background/border)
    private func secondaryTextLinkNormal() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: .white,                                     // or .clear
            borderColor:     .white,                                     // or .clear
            selectionColor:  Color(red: 0.00, green: 0.31, blue: 0.56),  // TODO
            underline: false
        )
    }
    private func secondaryTextLinkHighlighted() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: .white,                                     // or .clear
            borderColor:     .white,                                     // or .clear
            selectionColor:  Color(red: 0.07, green: 0.44, blue: 0.75),  // TODO
            underline: false
        )
    }
    private func secondaryTextLinkDisabled() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: .white,                                     // or .clear
            borderColor:     .white,                                     // or .clear
            selectionColor:  Color(red: 0.60, green: 0.65, blue: 0.70),  // TODO
            underline: false
        )
    }
    private func secondaryTextLinkConfirmed() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: .white,                                     // or .clear
            borderColor:     .white,                                     // or .clear
            selectionColor:  Color(red: 0.00, green: 0.55, blue: 0.31),  // TODO
            underline: false
        )
    }

    public func palette(
        for variant: RDSButtonVariant,
        type: RDSButtonType,
        state: RDSButtonState
    ) -> RDSButtonPalette {
        switch (variant, type, state) {

        case (.primary, .default, .normal):       return primaryDefaultNormal()
        case (.primary, .default, .highlighted):  return primaryDefaultHighlighted()
        case (.primary, .default, .disabled):     return primaryDefaultDisabled()
        case (.primary, .default, .loading):      return primaryDefaultDisabled() // same visuals; spinner used
        case (.primary, .default, .confirmed):    return primaryDefaultConfirmed()

        case (.primary, .textLink, .normal):      return primaryTextLinkNormal()
        case (.primary, .textLink, .highlighted): return primaryTextLinkHighlighted()
        case (.primary, .textLink, .disabled):    return primaryTextLinkDisabled()
        case (.primary, .textLink, .loading):     return primaryTextLinkDisabled() // same visuals; spinner used
        case (.primary, .textLink, .confirmed):   return primaryTextLinkConfirmed()

        case (.secondary, .default, .normal):     return secondaryDefaultNormal()
        case (.secondary, .default, .highlighted):return secondaryDefaultHighlighted()
        case (.secondary, .default, .disabled):   return secondaryDefaultDisabled()
        case (.secondary, .default, .loading):    return secondaryDefaultDisabled() // same visuals; spinner used
        case (.secondary, .default, .confirmed):  return secondaryDefaultConfirmed()

        case (.secondary, .textLink, .normal):    return secondaryTextLinkNormal()
        case (.secondary, .textLink, .highlighted):return secondaryTextLinkHighlighted()
        case (.secondary, .textLink, .disabled):  return secondaryTextLinkDisabled()
        case (.secondary, .textLink, .loading):   return secondaryTextLinkDisabled() // same visuals; spinner used
        case (.secondary, .textLink, .confirmed): return secondaryTextLinkConfirmed()

        case (.alternative, .default, .normal):    return alternativeDefaultNormal()
        case (.alternative, .default, .highlighted):return primaryDefaultHighlighted() // alias
        case (.alternative, .default, .disabled):  return primaryDefaultDisabled()     // alias
        case (.alternative, .default, .loading):   return primaryDefaultDisabled()     // alias
        case (.alternative, .default, .confirmed): return primaryDefaultConfirmed()    // alias

        // Alternative.TextLink does not exist by design.
        default:
            // Fallback to a sensible default to avoid crash in case of unsupported combos.
            return primaryDefaultNormal()
        }
    }
}

// MARK: - Typography Hook

/// Provides the text style for each button size.
/// By default it returns system fonts sized to match typical "buttonM" / "buttonS" styles.
/// Replace the implementation to wire your `RDSTypography` tokens.
public protocol RDSButtonTypographyProvider {
    /// Returns the SwiftUI `Font` to be used for a given button size.
    /// - Parameter size: The RDSButtonSize.
    /// - Returns: A `Font` to style the title text.
    func font(for size: RDSButtonSize) -> Font

    /// Whether the text should be scaled down slightly to prevent truncation on fixed widths.
    /// - Parameter size: The RDSButtonSize.
    func minimumScaleFactor(for size: RDSButtonSize) -> CGFloat
}

/// Default typography provider.
/// - Mapping suggestion:
///   - `.default`, `.iconLeft`, `.iconRight`, `.large` -> "buttonM" token
///   - `.small` -> "buttonS" token
public struct RDSDefaultButtonTypography: RDSButtonTypographyProvider {
    public init() {}

    public func font(for size: RDSButtonSize) -> Font {
        switch size {
        case .small:
            // TODO: Replace with RDSTypography token, e.g. RDSTextStyleToken.buttonS
            return .system(size: 12, weight: .medium, design: .default)
        case .default, .iconLeft, .iconRight:
            // TODO: Replace with RDSTypography token, e.g. RDSTextStyleToken.buttonM
            return .system(size: 14, weight: .semibold, design: .default)
        case .large:
            // TODO: Replace with RDSTypography token, e.g. RDSTextStyleToken.buttonM (larger container)
            return .system(size: 14, weight: .semibold, design: .default)
        }
    }

    public func minimumScaleFactor(for size: RDSButtonSize) -> CGFloat {
        // Fixed widths may need slight scaling for longer labels.
        switch size {
        case .small: return 0.9
        default:     return 0.95
        }
    }
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
        paletteProvider: RDSButtonPaletteProvider = RDSDefaultButtonPalettes(),
        typographyProvider: RDSButtonTypographyProvider = RDSDefaultButtonTypography(),
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
                .font(typographyProvider.font(for: size))
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
