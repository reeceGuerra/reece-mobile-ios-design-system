//
//  RDSButton.Layout.swift
//  RDSUI
//
//  Created by Carlos Lopez on 05/09/25.
//

import SwiftUI

extension RDSButton {
    
    // MARK: - Content (Instance Reuse)
    
    /// Builds the visible content of the button (text + optional icon) and wraps it
    /// with the standard surface (background, border, clip) for the current configuration.
    ///
    /// - Parameter palette: Palette resolved for the current configuration (variant, type, state).
    /// - Returns: A view that renders the full button surface.
    @MainActor
    internal func content(palette: RDSButtonPalette) -> some View {
        let label = Self.buildLabel(
            title: title,
            icon: icon,
            size: size,
            state: state,
            palette: palette,
            typographyProvider: typographyProvider
        )
        return Self.buildSurface(
            label,
            size: size,
            state: state,
            palette: palette
        )
    }
    
    // MARK: - Static Renderers (Single Source of Truth)
    
    /// Builds the button label (text + optional icon or spinner) following
    /// design tokens and fixed spacing rules.
    ///
    /// - Parameters:
    ///   - title: Title to display.
    ///   - icon: Optional icon; used for `.iconLeft` and `.iconRight` sizes.
    ///   - size: Fixed size that drives icon placement and dimensions.
    ///   - state: External state (may be `.loading`, in which case we render a spinner).
    ///   - palette: Resolved colors/underline for the current configuration.
    ///   - typographyProvider: Provider to resolve text style tokens and scale factor.
    /// - Returns: The label view without background/border/clip.
    @MainActor
    internal static func buildLabel(
        title: String,
        icon: Image?,
        size: RDSButtonSize,
        state: RDSButtonState,
        palette: RDSButtonPalette,
        typographyProvider: RDSButtonTypographyProvider
    ) -> some View {
        Group {
            HStack(spacing: 0) {
                if state == .loading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(palette.selectionColor)
                } else {
                    if size == .iconLeft, let icon {
                        icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(palette.selectionColor)
                            .accessibilityHidden(true)
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
                        icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(palette.selectionColor)
                            .accessibilityHidden(true)
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 24)
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isButton)
        }
    }
    
    /// Wraps a given label with the standard RDS button surface: fixed width/height,
    /// background, border, clip and content shape. Also applies state-driven opacity.
    ///
    /// - Parameters:
    ///   - label: The inner label built by `buildLabel`.
    ///   - size: Fixed size to resolve button width/height.
    ///   - state: External state controlling visual emphasis (e.g., `disabled`).
    ///   - palette: Resolved palette with background and border colors.
    /// - Returns: A view representing the full button surface.
    @MainActor
    internal static func buildSurface<Label: View>(
        _ label: Label,
        size: RDSButtonSize,
        state: RDSButtonState,
        palette: RDSButtonPalette
    ) -> some View {
        let dimensions = dimensions(for: size)
        return label
            .frame(width: dimensions.width, height: dimensions.height, alignment: .center)
            .background(palette.backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .stroke(palette.borderColor, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 2, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: 2, style: .continuous))
            .opacity(opacity(for: state))
    }
    
    /// Computes an opacity for the outer surface based on the external state.
    ///
    /// - Parameter state: The external `RDSButtonState`.
    /// - Returns: An opacity value in the range `[0, 1]`.
    @MainActor
    internal static func opacity(for state: RDSButtonState) -> CGFloat {
        switch state {
        case .disabled: return 0.7
        default:        return 1.0
        }
    }
    
    /// Resolves fixed dimensions for each button size.
    ///
    /// - Parameter size: The `RDSButtonSize` variant.
    /// - Returns: A tuple of `(width, height)` in points.
    internal static func dimensions(for size: RDSButtonSize) -> (width: CGFloat, height: CGFloat) {
        switch size {
        case .default:   return (135, 40)
        case .large:     return (151, 56)
        case .small:     return (108, 30)
        case .iconLeft:  return (148, 40)
        case .iconRight: return (148, 40)
        }
    }
}
