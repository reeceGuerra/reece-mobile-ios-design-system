//
//  RDSButton.Layout.swift
//  RDSUI
//
//  Created by Carlos Lopez on 05/09/25.
//

import SwiftUI

extension RDSButton {
    
    // MARK: - Content
    
    /// Builds the visible content of the button (text + optional icon).
    ///
    /// - Parameter palette: Palette resolved for the current configuration.
    /// - Returns: A horizontal stack with icon/text/icon depending on size.
    @ViewBuilder
    internal func content(palette: RDSButtonPalette) -> some View {
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
    
    /// Renders a 20×20pt icon tinted with the given color.
    /// - Parameters:
    ///   - image: The image to render.
    ///   - color: The foreground color applied to the icon.
    /// - Returns: A resizable, scaled icon view.
    internal func iconView(_ image: Image, color: Color) -> some View {
        image
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .foregroundStyle(color)
            .accessibilityHidden(true)
    }
    
    /// Resolves fixed dimensions for each button size.
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
