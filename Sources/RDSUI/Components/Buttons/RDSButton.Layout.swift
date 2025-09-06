//
//  RDSButton.Layout.swift
//  RDSUI
//
//  Created by Carlos Lopez on 05/09/25.
//

import SwiftUI

extension RDSButton {
    // MARK: - Content
    
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
    
    /// Renders the 20x20pt icon colored with `selectionColor`.
    internal func iconView(_ image: Image, color: Color) -> some View {
        image
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .foregroundStyle(color)
            .accessibilityHidden(true)
    }
    
    /// Fixed dimensions per size.
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
