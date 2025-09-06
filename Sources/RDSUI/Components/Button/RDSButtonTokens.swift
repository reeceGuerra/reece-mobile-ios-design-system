//
//  RDSButtonTokens.swift
//  RDSUI
//
//  Created by Carlos Lopez on 05/09/25.
//

import SwiftUI

// MARK: - RDSButtonTokens Palette Provider
//
// Bridges the YAML color spec (backgroundColor, borderColor, selectionColor, underline)
// to concrete SwiftUI Colors used by RDSButton.
// This provider is stateless (aside from an optional color scheme hint) to be concurrency-friendly.

/// A palette provider that wires design tokens (RDSColors) as defined by the YAML spec.
/// Initialize with a `ColorScheme` hint if your color tokens depend on the scheme.
public struct RDSButtonTokensPaletteProvider: RDSButtonPaletteProvider {

    // If your RDSColors API requires a scheme, keep it here.
    private let scheme: ColorScheme

    /// Creates a palette provider backed by your color tokens.
    /// - Parameter scheme: Color scheme hint for token selection (if applicable).
    public init(scheme: ColorScheme = .light) {
        self.scheme = scheme
    }

    // MARK: Primary / Default

    private func primaryDefault_normal() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: RDSColors.primary.DarkBlue.color(.t100, using: scheme),
            borderColor:     RDSColors.primary.DarkBlue.color(.t100, using: scheme),
            selectionColor:  RDSColors.secondary.White.color(using: scheme),
            underline: false
        )
    }

    private func primaryDefault_highlighted() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: RDSColors.support.HoverBlue.color(using: scheme),
            borderColor:     RDSColors.support.HoverBlue.color(using: scheme),
            selectionColor:  RDSColors.secondary.White.color(using: scheme),
            underline: false
        )
    }

    private func primaryDefault_disabled() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: RDSColors.primary.DarkTextGray.color(.t60, using: scheme),
            borderColor:     RDSColors.primary.DarkTextGray.color(.t60, using: scheme),
            selectionColor:  RDSColors.secondary.White.color(using: scheme),
            underline: false
        )
    }

    private func primaryDefault_confirmed() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: RDSColors.support.Green.color(.t100, using: scheme),
            borderColor:     RDSColors.support.Green.color(.t100, using: scheme),
            selectionColor:  RDSColors.secondary.White.color(using: scheme),
            underline: false
        )
    }

    // MARK: Primary / TextLink

    private func primaryTextLink_normal() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: RDSColors.secondary.White.color(using: scheme),
            borderColor:     RDSColors.secondary.White.color(using: scheme),
            selectionColor:  RDSColors.primary.LightBlue.color(.t100, using: scheme),
            underline: true
        )
    }

    private func primaryTextLink_highlighted() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: RDSColors.secondary.White.color(using: scheme),
            borderColor:     RDSColors.secondary.White.color(using: scheme),
            selectionColor:  RDSColors.support.HoverBlue.color(using: scheme),
            underline: true
        )
    }

    private func primaryTextLink_disabled() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: RDSColors.secondary.White.color(using: scheme),
            borderColor:     RDSColors.secondary.White.color(using: scheme),
            selectionColor:  RDSColors.secondary.TextGray.color(.t60, using: scheme),
            underline: true
        )
    }

    private func primaryTextLink_confirmed() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: RDSColors.secondary.White.color(using: scheme),
            borderColor:     RDSColors.secondary.White.color(using: scheme),
            selectionColor:  RDSColors.support.Green.color(.t100, using: scheme),
            underline: true
        )
    }

    // MARK: Secondary / Default

    private func secondaryDefault_normal() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: RDSColors.secondary.White.color(using: scheme),
            borderColor:     RDSColors.primary.DarkBlue.color(.t100, using: scheme),
            selectionColor:  RDSColors.primary.DarkBlue.color(.t100, using: scheme),
            underline: false
        )
    }

    private func secondaryDefault_highlighted() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: RDSColors.secondary.White.color(using: scheme),
            borderColor:     RDSColors.support.HoverBlue.color(using: scheme),
            selectionColor:  RDSColors.support.HoverBlue.color(using: scheme),
            underline: false
        )
    }

    private func secondaryDefault_disabled() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: RDSColors.secondary.White.color(using: scheme),
            borderColor:     RDSColors.secondary.TextGray.color(.t60, using: scheme),
            selectionColor:  RDSColors.secondary.TextGray.color(.t60, using: scheme),
            underline: false
        )
    }

    private func secondaryDefault_confirmed() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: RDSColors.secondary.White.color(using: scheme),
            borderColor:     RDSColors.support.Green.color(.t100, using: scheme),
            selectionColor:  RDSColors.support.Green.color(.t100, using: scheme),
            underline: false
        )
    }

    // MARK: Secondary / TextLink

    private func secondaryTextLink_normal() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: RDSColors.secondary.White.color(using: scheme),
            borderColor:     RDSColors.secondary.White.color(using: scheme),
            selectionColor:  RDSColors.primary.DarkBlue.color(.t100, using: scheme),
            underline: false
        )
    }

    private func secondaryTextLink_highlighted() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: RDSColors.secondary.White.color(using: scheme),
            borderColor:     RDSColors.secondary.White.color(using: scheme),
            selectionColor:  RDSColors.support.HoverBlue.color(using: scheme),
            underline: false
        )
    }

    private func secondaryTextLink_disabled() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: RDSColors.secondary.White.color(using: scheme),
            borderColor:     RDSColors.secondary.White.color(using: scheme),
            selectionColor:  RDSColors.secondary.TextGray.color(.t60, using: scheme),
            underline: false
        )
    }

    private func secondaryTextLink_confirmed() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: RDSColors.secondary.White.color(using: scheme),
            borderColor:     RDSColors.secondary.White.color(using: scheme),
            selectionColor:  RDSColors.support.Green.color(.t100, using: scheme),
            underline: false
        )
    }

    // MARK: Alternative / Default

    private func alternativeDefault_normal() -> RDSButtonPalette {
        RDSButtonPalette(
            backgroundColor: RDSColors.primary.LightBlue.color(.t100, using: scheme),
            borderColor:     RDSColors.primary.LightBlue.color(.t100, using: scheme),
            selectionColor:  RDSColors.secondary.White.color(using: scheme),
            underline: false
        )
    }

    // Other Alternative states alias Primary.Default according to the design.
    private func alternativeDefault_highlighted() -> RDSButtonPalette { primaryDefault_highlighted() }
    private func alternativeDefault_disabled() -> RDSButtonPalette { primaryDefault_disabled() }
    private func alternativeDefault_confirmed() -> RDSButtonPalette { primaryDefault_confirmed() }

    // MARK: RDSButtonPaletteProvider

    public func palette(
        for variant: RDSButtonVariant,
        type: RDSButtonType,
        state: RDSButtonState
    ) -> RDSButtonPalette {
        switch (variant, type, state) {
        case (.primary, .default, .normal):        return primaryDefault_normal()
        case (.primary, .default, .highlighted):   return primaryDefault_highlighted()
        case (.primary, .default, .disabled):      return primaryDefault_disabled()
        case (.primary, .default, .loading):       return primaryDefault_disabled() // visuals = disabled; spinner tinted with selectionColor
        case (.primary, .default, .confirmed):     return primaryDefault_confirmed()

        case (.primary, .textLink, .normal):       return primaryTextLink_normal()
        case (.primary, .textLink, .highlighted):  return primaryTextLink_highlighted()
        case (.primary, .textLink, .disabled):     return primaryTextLink_disabled()
        case (.primary, .textLink, .loading):      return primaryTextLink_disabled()
        case (.primary, .textLink, .confirmed):    return primaryTextLink_confirmed()

        case (.secondary, .default, .normal):      return secondaryDefault_normal()
        case (.secondary, .default, .highlighted): return secondaryDefault_highlighted()
        case (.secondary, .default, .disabled):    return secondaryDefault_disabled()
        case (.secondary, .default, .loading):     return secondaryDefault_disabled()
        case (.secondary, .default, .confirmed):   return secondaryDefault_confirmed()

        case (.secondary, .textLink, .normal):     return secondaryTextLink_normal()
        case (.secondary, .textLink, .highlighted):return secondaryTextLink_highlighted()
        case (.secondary, .textLink, .disabled):   return secondaryTextLink_disabled()
        case (.secondary, .textLink, .loading):    return secondaryTextLink_disabled()
        case (.secondary, .textLink, .confirmed):  return secondaryTextLink_confirmed()

        case (.alternative, .default, .normal):     return alternativeDefault_normal()
        case (.alternative, .default, .highlighted):return alternativeDefault_highlighted()
        case (.alternative, .default, .disabled):   return alternativeDefault_disabled()
        case (.alternative, .default, .loading):    return alternativeDefault_disabled()
        case (.alternative, .default, .confirmed):  return alternativeDefault_confirmed()

        default:
            // Alternative.TextLink does not exist by design.
            return primaryDefault_normal()
        }
    }
}

// MARK: - RDSButtonTypographyTokens
//
// Bridges the YAML typography spec to concrete SwiftUI Fonts used by RDSButton.
// Replace the implementation with your `RDSTypography` tokens.

/// Typography provider wired to design tokens (RDSTypography).
public struct RDSButtonTypographyTokens: RDSButtonTypographyProvider {

    public init() {}

    /// Returns the SwiftUI `Font` to be used for a given button size.
    /// Map sizes to your RDSTypography tokens (e.g., buttonM, buttonS).
    public func font(for size: RDSButtonSize) -> Font {
        switch size {
        case .small:
            // TODO: wire RDSTypography (e.g., RDSTextStyleToken.buttonS)
            return .system(size: 12, weight: .medium)
        case .default, .iconLeft, .iconRight, .large:
            // TODO: wire RDSTypography (e.g., RDSTextStyleToken.buttonM)
            return .system(size: 14, weight: .semibold)
        }
    }

    /// Slight scaling to avoid truncation on fixed widths.
    public func minimumScaleFactor(for size: RDSButtonSize) -> CGFloat {
        switch size {
        case .small: return 0.9
        default:     return 0.95
        }
    }
}

// MARK: - Convenience Initializers (Optional)
//
// These helpers make it easy to construct a button using your tokens
// without having to pass providers at each call site.
//

public extension RDSButton {
    /// Convenience init that defaults to `RDSButtonTokensPaletteProvider` and `RDSButtonTypographyTokens`.
    /// - Parameters:
    ///   - title: The button title (centered).
    ///   - variant: Visual variant (`primary`, `secondary`, `alternative`).
    ///   - type: Visual type within the variant (`default`, `textLink`).
    ///   - size: Fixed layout size (`default`, `large`, `small`, `iconLeft`, `iconRight`).
    ///   - state: Visual state (`normal`, `highlighted`, `disabled`, `loading`, `confirmed`).
    ///   - icon: Optional icon (`Image`). Only rendered for `.iconLeft` / `.iconRight`.
    ///   - colorScheme: Optional color scheme hint for token selection (default: `.light`).
    ///   - action: Closure executed on tap (no-op in `disabled`/`loading`).
    init(
        title: String,
        variant: RDSButtonVariant,
        type: RDSButtonType,
        size: RDSButtonSize,
        state: RDSButtonState,
        icon: Image? = nil,
        colorScheme: ColorScheme = .light,
        action: @escaping () -> Void
    ) {
        self.init(
            title: title,
            variant: variant,
            type: type,
            size: size,
            state: state,
            icon: icon,
            paletteProvider: RDSButtonTokensPaletteProvider(scheme: colorScheme),
            typographyProvider: RDSButtonTypographyTokens(),
            action: action
        )
    }
}
