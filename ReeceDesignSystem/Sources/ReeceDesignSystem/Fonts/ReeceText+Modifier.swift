//
//  ReeceText+Modifier.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 02/09/25.//
//
//  Convenience APIs for tokens and Figma specs.
//  - Text.reeceText(_:slant:color:)
//  - Text.reeceText(figma:color:)
//
//  Line height note:
//  SwiftUI does not expose a fixed "line-height" for Text.
//  We approximate with `.lineSpacing(lineHeight - fontSize)` when a lineHeight is provided.
//

import SwiftUI

// MARK: - Lightweight modifiers (local, no cross-file deps)

/// Applies optional foreground color and accessibility traits.
private struct ReeceTextPaint: ViewModifier {
    let color: Color?
    func body(content: Content) -> some View {
        content
            .foregroundStyle(color ?? .primary)
            .accessibilityAddTraits(.isStaticText)
    }
}

/// Applies `.fontWeight(_:)` only when `weight` is non-nil.
private struct ApplyFontWeightIfNeeded: ViewModifier {
    let weight: Font.Weight?
    func body(content: Content) -> some View {
        if let w = weight { content.fontWeight(w) } else { content }
    }
}

/// Applies `.italic()` only when `enabled` is true.
private struct ApplyItalicIfNeeded: ViewModifier {
    let enabled: Bool
    func body(content: Content) -> some View {
        enabled ? AnyView(content.italic()) : AnyView(content)
    }
}

// MARK: - Small view helpers

private extension View {
    /// Conditionally applies `.lineSpacing(_)` only when `value` is > 0.
    @ViewBuilder
    func reeceLineSpacing(_ value: CGFloat?) -> some View {
        if let v = value, v > 0 {
            self.lineSpacing(v)
        } else {
            self
        }
    }
}

// MARK: - Public API

public extension Text {

    /// Apply a design-system **token** to a `Text` while handling:
    /// - optional line spacing approximation,
    /// - tracking,
    /// - font resolution (system / named / custom),
    /// - conditional weight & italic,
    /// - color.
    @MainActor
    func reeceText(
        _ token: ReeceTextStyleToken,
        slant: ReeceFontSlant = .normal,
        color: Color? = nil
    ) -> some View {
        let style = ReeceTypography.text(token, slant: slant)
        let resolved = style.resolve()

        // extra space between baselines = desiredLineHeight - baseFontSize
        let spacingAdjust: CGFloat? = style.lineHeight.map { max(0, $0 - style.size) }

        // Compose as View (no Text-typed reassignment):
        return self
            .reeceLineSpacing(spacingAdjust)                       // <-- safe, conditional
            .tracking(style.tracking)
            .font(resolved.font)
            .modifier(ApplyFontWeightIfNeeded(weight: resolved.systemWeight))
            .modifier(ApplyItalicIfNeeded(enabled: resolved.needsViewItalic))
            .modifier(ReeceTextPaint(color: color))
    }

    /// Apply a **Figma-based** style (px + % inputs) to a `Text`.
    ///
    /// Use when mirroring Figma specs directly:
    /// - sizePx (≈ pt), optional lineHeightPx, letterSpacingPercent → points,
    /// - numeric weight (100–900), italic flag, and relativeTo.
    @MainActor
    func reeceText(
        figma spec: ReeceTextStyle,
        color: Color? = nil
    ) -> some View {
        let resolved = spec.resolve()
        let spacingAdjust: CGFloat? = spec.lineHeight.map { max(0, $0 - spec.size) }

        return self
            .reeceLineSpacing(spacingAdjust)                       // <-- safe, conditional
            .tracking(spec.tracking)
            .font(resolved.font)
            .modifier(ApplyFontWeightIfNeeded(weight: resolved.systemWeight))
            .modifier(ApplyItalicIfNeeded(enabled: resolved.needsViewItalic))
            .modifier(ReeceTextPaint(color: color))
    }
}

#if DEBUG
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
