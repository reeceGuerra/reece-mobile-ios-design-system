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

// MARK: - Default Palette Provider (with de-duplication)

/// Default palette provider for RDSButton.
/// This implementation deduplicates repeated palettes using shared constants.
/// Replace the `TODO` token stubs with your `RDSColors` tokens.
@MainActor
public final class RDSDefaultButtonPalettes: RDSButtonPaletteProvider {

    public static let shared = RDSDefaultButtonPalettes()

    // MARK: Constants (Replace with your RDSColors tokens)

    // NOTE:
    // All color values below are placeholders to keep this file self-contained.
    // Replace them with your concrete tokens from RDSColors, e.g.:
    // let PrimaryBG = RDSColors.primary.DarkBlue.color(.t600, using: scheme)
    // Use fixed colors if you need the file to compile before wiring the tokens.

    // Primary-like solids (used by Primary.Default & Alternative.Default)
    private let kPrimaryBG_Normal     = Color(red: 0.00, green: 0.31, blue: 0.56) // TODO: RDSColors primary solid
    private let kPrimaryBorder_Normal = Color(red: 0.00, green: 0.31, blue: 0.56) // TODO: RDSColors primary border
    private let kPrimarySel_Normal    = Color.white                                // TODO: RDSColors selection on primary

    private let kPrimaryBG_Highlight  = Color(red: 0.00, green: 0.26, blue: 0.47) // TODO: Hover/Pressed
    private let kPrimaryBorder_High   = Color(red: 0.00, green: 0.26, blue: 0.47) // TODO
    private let kPrimarySel_High      = Color.white

    private let kPrimaryBG_Disabled   = Color(red: 0.90, green: 0.93, blue: 0.96) // TODO: Disabled bg
    private let kPrimaryBorder_Dis    = Color(red: 0.90, green: 0.93, blue: 0.96) // TODO: Disabled border
    private let kPrimarySel_Dis       = Color(red: 0.60, green: 0.65, blue: 0.70) // TODO: Disabled label

    private let kPrimaryBG_Confirmed  = Color(red: 0.00, green: 0.55, blue: 0.31) // TODO: Success bg
    private let kPrimaryBorder_Conf   = Color(red: 0.00, green: 0.55, blue: 0.31) // TODO: Success border
    private let kPrimarySel_Conf      = Color.white

    // Alternative specific normal (if differs from Primary normal)
    private let kAlternativeBG_Normal = Color(red: 0.07, green: 0.44, blue: 0.75) // TODO: Alternative bg normal
    private let kAlternativeBorder_Normal = Color(red: 0.07, green: 0.44, blue: 0.75)
    private let kAlternativeSel_Normal = Color.white

    // Secondary (outline-like)
    private let kSecondaryBG_Clear    = Color.white      // or .clear depending on your DS
    private let kSecondaryBorder_Norm = Color(red: 0.00, green: 0.31, blue: 0.56) // TODO
    private let kSecondarySel_Norm    = Color(red: 0.00, green: 0.31, blue: 0.56) // TODO

    private let kSecondaryBorder_High = Color(red: 0.00, green: 0.26, blue: 0.47) // TODO
    private let kSecondarySel_High    = Color(red: 0.00, green: 0.26, blue: 0.47) // TODO

    private let kSecondaryBorder_Dis  = Color(red: 0.85, green: 0.88, blue: 0.92) // TODO
    private let kSecondarySel_Dis     = Color(red: 0.60, green: 0.65, blue: 0.70) // TODO

    private let kSecondaryBorder_Conf = Color(red: 0.00, green: 0.55, blue: 0.31) // TODO
    private let kSecondarySel_Conf    = Color(red: 0.00, green: 0.55, blue: 0.31) // TODO

    // TextLink backgrounds (white/clear) and per-variant selections
    private let kLinkBG = Color.white              // or .clear per your design
    private let kLinkBorder = Color.white          // or .clear per your design

    private let kPrimaryLinkSel_Norm = Color(red: 0.00, green: 0.31, blue: 0.56) // TODO
    private let kPrimaryLinkSel_High = Color(red: 0.00, green: 0.26, blue: 0.47) // TODO
    private let kPrimaryLinkSel_Dis  = Color(red: 0.60, green: 0.65, blue: 0.70) // TODO
    private let kPrimaryLinkSel_Conf = Color(red: 0.00, green: 0.55, blue: 0.31) // TODO

    private let kSecondaryLinkSel_Norm = Color(red: 0.00, green: 0.31, blue: 0.56) // TODO
    private let kSecondaryLinkSel_High = Color(red: 0.07, green: 0.44, blue: 0.75) // TODO
    private let kSecondaryLinkSel_Dis  = Color(red: 0.60, green: 0.65, blue: 0.70) // TODO
    private let kSecondaryLinkSel_Conf = Color(red: 0.00, green: 0.55, blue: 0.31) // TODO

    // MARK: Shared Palettes (De-duplicated)

    private lazy var kPalette_PrimaryDefault_Normal = RDSButtonPalette(
        backgroundColor: kPrimaryBG_Normal,
        borderColor:     kPrimaryBorder_Normal,
        selectionColor:  kPrimarySel_Normal,
        underline: false
    )

    private lazy var kPalette_PrimaryDefault_Highlighted = RDSButtonPalette(
        backgroundColor: kPrimaryBG_Highlight,
        borderColor:     kPrimaryBorder_High,
        selectionColor:  kPrimarySel_High,
        underline: false
    )

    private lazy var kPalette_PrimaryDefault_Disabled = RDSButtonPalette(
        backgroundColor: kPrimaryBG_Disabled,
        borderColor:     kPrimaryBorder_Dis,
        selectionColor:  kPrimarySel_Dis,
        underline: false
    )

    // Loading == Disabled in visuals; spinner shown with selectionColor.
    private lazy var kPalette_PrimaryDefault_Loading = kPalette_PrimaryDefault_Disabled

    private lazy var kPalette_PrimaryDefault_Confirmed = RDSButtonPalette(
        backgroundColor: kPrimaryBG_Confirmed,
        borderColor:     kPrimaryBorder_Conf,
        selectionColor:  kPrimarySel_Conf,
        underline: false
    )

    // Alternative.Default aliasing most states to Primary.Default
    private lazy var kPalette_AlternativeDefault_Normal = RDSButtonPalette(
        backgroundColor: kAlternativeBG_Normal,
        borderColor:     kAlternativeBorder_Normal,
        selectionColor:  kAlternativeSel_Normal,
        underline: false
    )
    private lazy var kPalette_AlternativeDefault_Highlighted = kPalette_PrimaryDefault_Highlighted
    private lazy var kPalette_AlternativeDefault_Disabled    = kPalette_PrimaryDefault_Disabled
    private lazy var kPalette_AlternativeDefault_Loading     = kPalette_PrimaryDefault_Loading
    private lazy var kPalette_AlternativeDefault_Confirmed   = kPalette_PrimaryDefault_Confirmed

    // Secondary.Default (outline-like)
    private lazy var kPalette_SecondaryDefault_Normal = RDSButtonPalette(
        backgroundColor: kSecondaryBG_Clear,
        borderColor:     kSecondaryBorder_Norm,
        selectionColor:  kSecondarySel_Norm,
        underline: false
    )
    private lazy var kPalette_SecondaryDefault_Highlighted = RDSButtonPalette(
        backgroundColor: kSecondaryBG_Clear,
        borderColor:     kSecondaryBorder_High,
        selectionColor:  kSecondarySel_High,
        underline: false
    )
    private lazy var kPalette_SecondaryDefault_Disabled = RDSButtonPalette(
        backgroundColor: kSecondaryBG_Clear,
        borderColor:     kSecondaryBorder_Dis,
        selectionColor:  kSecondarySel_Dis,
        underline: false
    )
    private lazy var kPalette_SecondaryDefault_Loading  = kPalette_SecondaryDefault_Disabled
    private lazy var kPalette_SecondaryDefault_Confirmed = RDSButtonPalette(
        backgroundColor: kSecondaryBG_Clear,
        borderColor:     kSecondaryBorder_Conf,
        selectionColor:  kSecondarySel_Conf,
        underline: false
    )

    // Primary.TextLink (underline true; white/clear background/border)
    private lazy var kPalette_PrimaryTextLink_Normal = RDSButtonPalette(
        backgroundColor: kLinkBG,
        borderColor:     kLinkBorder,
        selectionColor:  kPrimaryLinkSel_Norm,
        underline: true
    )
    private lazy var kPalette_PrimaryTextLink_Highlighted = RDSButtonPalette(
        backgroundColor: kLinkBG,
        borderColor:     kLinkBorder,
        selectionColor:  kPrimaryLinkSel_High,
        underline: true
    )
    private lazy var kPalette_PrimaryTextLink_Disabled = RDSButtonPalette(
        backgroundColor: kLinkBG,
        borderColor:     kLinkBorder,
        selectionColor:  kPrimaryLinkSel_Dis,
        underline: true
    )
    private lazy var kPalette_PrimaryTextLink_Loading  = kPalette_PrimaryTextLink_Disabled
    private lazy var kPalette_PrimaryTextLink_Confirmed = RDSButtonPalette(
        backgroundColor: kLinkBG,
        borderColor:     kLinkBorder,
        selectionColor:  kPrimaryLinkSel_Conf,
        underline: true
    )

    // Secondary.TextLink (underline false; white/clear background/border)
    private lazy var kPalette_SecondaryTextLink_Normal = RDSButtonPalette(
        backgroundColor: kLinkBG,
        borderColor:     kLinkBorder,
        selectionColor:  kSecondaryLinkSel_Norm,
        underline: false
    )
    private lazy var kPalette_SecondaryTextLink_Highlighted = RDSButtonPalette(
        backgroundColor: kLinkBG,
        borderColor:     kLinkBorder,
        selectionColor:  kSecondaryLinkSel_High,
        underline: false
    )
    private lazy var kPalette_SecondaryTextLink_Disabled = RDSButtonPalette(
        backgroundColor: kLinkBG,
        borderColor:     kLinkBorder,
        selectionColor:  kSecondaryLinkSel_Dis,
        underline: false
    )
    private lazy var kPalette_SecondaryTextLink_Loading  = kPalette_SecondaryTextLink_Disabled
    private lazy var kPalette_SecondaryTextLink_Confirmed = RDSButtonPalette(
        backgroundColor: kLinkBG,
        borderColor:     kLinkBorder,
        selectionColor:  kSecondaryLinkSel_Conf,
        underline: false
    )

    public init() {}

    public func palette(
        for variant: RDSButtonVariant,
        type: RDSButtonType,
        state: RDSButtonState
    ) -> RDSButtonPalette {
        switch (variant, type, state) {

        case (.primary, .default, .normal):       return kPalette_PrimaryDefault_Normal
        case (.primary, .default, .highlighted):  return kPalette_PrimaryDefault_Highlighted
        case (.primary, .default, .disabled):     return kPalette_PrimaryDefault_Disabled
        case (.primary, .default, .loading):      return kPalette_PrimaryDefault_Loading
        case (.primary, .default, .confirmed):    return kPalette_PrimaryDefault_Confirmed

        case (.primary, .textLink, .normal):      return kPalette_PrimaryTextLink_Normal
        case (.primary, .textLink, .highlighted): return kPalette_PrimaryTextLink_Highlighted
        case (.primary, .textLink, .disabled):    return kPalette_PrimaryTextLink_Disabled
        case (.primary, .textLink, .loading):     return kPalette_PrimaryTextLink_Loading
        case (.primary, .textLink, .confirmed):   return kPalette_PrimaryTextLink_Confirmed

        case (.secondary, .default, .normal):     return kPalette_SecondaryDefault_Normal
        case (.secondary, .default, .highlighted):return kPalette_SecondaryDefault_Highlighted
        case (.secondary, .default, .disabled):   return kPalette_SecondaryDefault_Disabled
        case (.secondary, .default, .loading):    return kPalette_SecondaryDefault_Loading
        case (.secondary, .default, .confirmed):  return kPalette_SecondaryDefault_Confirmed

        case (.secondary, .textLink, .normal):    return kPalette_SecondaryTextLink_Normal
        case (.secondary, .textLink, .highlighted):return kPalette_SecondaryTextLink_Highlighted
        case (.secondary, .textLink, .disabled):  return kPalette_SecondaryTextLink_Disabled
        case (.secondary, .textLink, .loading):   return kPalette_SecondaryTextLink_Loading
        case (.secondary, .textLink, .confirmed): return kPalette_SecondaryTextLink_Confirmed

        case (.alternative, .default, .normal):    return kPalette_AlternativeDefault_Normal
        case (.alternative, .default, .highlighted):return kPalette_AlternativeDefault_Highlighted
        case (.alternative, .default, .disabled):  return kPalette_AlternativeDefault_Disabled
        case (.alternative, .default, .loading):   return kPalette_AlternativeDefault_Loading
        case (.alternative, .default, .confirmed): return kPalette_AlternativeDefault_Confirmed

        // Alternative.TextLink does not exist by design.
        default:
            // Fallback to a sensible default to avoid crash in case of unsupported combos.
            return kPalette_PrimaryDefault_Normal
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
    ///   - paletteProvider: Palette resolver. Defaults to `RDSDefaultButtonPalettes.shared`.
    ///   - typographyProvider: Typography resolver. Defaults to `RDSDefaultButtonTypography()`.
    ///   - action: Closure executed on tap (no-op in `disabled`/`loading`).
    public init(
        title: String,
        variant: RDSButtonVariant,
        type: RDSButtonType,
        size: RDSButtonSize,
        state: RDSButtonState,
        icon: Image? = nil,
        paletteProvider: RDSButtonPaletteProvider = RDSDefaultButtonPalettes.shared,
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
        let hasIcon = (size == .iconLeft || size == .iconRight) && icon != nil

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
        // If no icon allowed, ignore provided icon to respect size rules.
        .opacity(1.0) // Keep a placeholder for future conditional styles if needed.
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

// MARK: - Previews (Optional)
/*
struct RDSButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            RDSButton(
                title: "Primary",
                variant: .primary,
                type: .default,
                size: .default,
                state: .normal
            ) {}

            RDSButton(
                title: "Loading",
                variant: .primary,
                type: .default,
                size: .iconRight,
                state: .loading,
                icon: Image(systemName: "arrow.clockwise")
            ) {}

            RDSButton(
                title: "Text Link",
                variant: .primary,
                type: .textLink,
                size: .default,
                state: .normal
            ) {}

            RDSButton(
                title: "Secondary",
                variant: .secondary,
                type: .default,
                size: .small,
                state: .highlighted
            ) {}

            RDSButton(
                title: "Alternative",
                variant: .alternative,
                type: .default,
                size: .iconLeft,
                state: .confirmed,
                icon: Image(systemName: "checkmark")
            ) {}
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
*/

