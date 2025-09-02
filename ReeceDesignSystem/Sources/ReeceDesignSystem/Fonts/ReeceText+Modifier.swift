//
//  ReeceText+Modifier.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 02/09/25.

import SwiftUI

// MARK: - Public API

public extension Text {

    /// Apply a token style.
    @MainActor
    func reeceText(
        _ token: ReeceTextStyleToken,
        slant: ReeceFontSlant = .normal,
        color: Color? = nil
    ) -> some View {
        let style = ReeceTypography.text(token, slant: slant)
        let resolved = style.resolve()
        let spacingAdjust: CGFloat? = style.lineHeight.map { max(0, $0 - style.size) }

        // Construimos sobre `Text` para poder usar .lineSpacing(_:)
        var txt: Text = self
            .font(resolved.font)
            .reeceApplySystemWeightIfNeeded(resolved.systemWeight)
            .reeceApplyItalicIfNeeded(resolved.needsViewItalic)

        if let s = spacingAdjust, s > 0 {
            txt = txt.lineSpacing(s) as! Text
        }

        return txt
            .tracking(style.tracking)
            .foregroundStyle(color ?? .primary)
            .accessibilityAddTraits(.isStaticText)
    }

    /// Apply a Figma-based style (px + % inputs).
    @MainActor
    func reeceText(
        figma spec: ReeceTextStyle,
        color: Color? = nil
    ) -> some View {
        let resolved = spec.resolve()
        let spacingAdjust: CGFloat? = spec.lineHeight.map { max(0, $0 - spec.size) }

        var txt: Text = self
            .font(resolved.font)
            .reeceApplySystemWeightIfNeeded(resolved.systemWeight)
            .reeceApplyItalicIfNeeded(resolved.needsViewItalic)

        if let s = spacingAdjust, s > 0 {
            txt = txt.lineSpacing(s) as! Text
        }

        return txt
            .tracking(spec.tracking)
            .foregroundStyle(color ?? .primary)
            .accessibilityAddTraits(.isStaticText)
    }
}

// MARK: - Helpers that stay on Text

private extension Text {
    func reeceApplySystemWeightIfNeeded(_ weight: Font.Weight?) -> Text {
        guard let w = weight else { return self }
        return self.fontWeight(w)
    }
    func reeceApplyItalicIfNeeded(_ enabled: Bool) -> Text {
        enabled ? self.italic() : self
    }
}


#if DEBUG
/// Preview demonstrating the token scale in various roles (upright vs italic).
///
/// - Note: You can also preview with larger Dynamic Type settings using
///   `.environment(\.dynamicTypeSize, .accessibility2)`.
struct ReeceTypography_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 12) {
            Group {
                Text("Display XL").reeceText(.displayXL)
                Text("Display L (Italic)").reeceText(.displayL, slant: .italic)
                Text("Display M").reeceText(.displayM)
            }
            Group {
                Text("Headline").reeceText(.headline)
                Text("Title L (Italic)").reeceText(.titleL, slant: .italic)
                Text("Title M").reeceText(.titleM)
                Text("Title S").reeceText(.titleS)
            }
            Group {
                Text("Body L").reeceText(.bodyL)
                Text("Body M (Italic)").reeceText(.bodyM, slant: .italic)
                Text("Body S").reeceText(.bodyS)
                Text("Label").reeceText(.label)
                Text("Caption").reeceText(.caption)
            }
            Group {
                Text("Code sample: let x = 42").reeceText(.code)
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
