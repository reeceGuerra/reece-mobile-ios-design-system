//
//  File.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 02/09/25.
//
//  Provides a convenience `Text.reeceText(_:, slant:, color:)` API to apply typography tokens,
//  ensuring consistent Dynamic Type, italic behavior, tracking, and color.
//
//  Example:
//
//  ```swift
//  // Upright
//  Text("Title").reeceText(.headline)
//
//  // Italic
//  Text("Emphasis").reeceText(.bodyM, slant: .italic)
//
//  // With brand color
//  Text("Body with brand color")
//      .reeceText(.bodyM, color: ReeceColors.primary.DarkBlue.color(.t100, using: .light))
//  ```
//

import SwiftUI

/// Internal modifier that applies typographic attributes like tracking and color.
/// Line height is intentionally not forced to keep cross-platform behavior predictable.
struct ReeceTextAttributes: ViewModifier {

    /// Letter spacing in points to apply to the content.
    let tracking: CGFloat

    /// Optional foreground color; defaults to `.primary` when `nil`.
    let color: Color?

    func body(content: Content) -> some View {
        content
            .tracking(tracking)
            .foregroundStyle(color ?? .primary)
            .accessibilityAddTraits(.isStaticText)
    }
}

public extension Text {

    /// Applies a Reece text token to a `Text` view, handling font resolution,
    /// italic (via view modifier when needed), tracking, and color.
    ///
    /// - Parameters:
    ///   - token: The typography token to apply (e.g., `.bodyM`, `.headline`).
    ///   - slant: Optional slant (`.normal` or `.italic`). Default is `.normal`.
    ///   - color: Optional foreground `Color`. When `nil`, `.primary` is used.
    /// - Returns: A new view with the specified typographic style applied.
    ///
    /// - Note:
    ///   - For `.systemDefault`, this applies `.fontWeight(_:)` and `.italic()` as needed,
    ///     because the system dynamic font is constructed as `Font.system(_:)`.
    ///   - For `.named` / `.custom`, `Font.custom(name:size:relativeTo:)` is used to keep
    ///     Dynamic Type scaling. Italic is encoded in the PostScript name, so no extra
    ///     view modifier is required.
    ///
    /// - Example:
    ///   ```swift
    ///   Text("Hello, world!")
    ///       .reeceText(.bodyM, slant: .italic)
    ///   ```
    @MainActor func reeceText(
        _ token: ReeceTextStyleToken,
        slant: ReeceFontSlant = .normal,
        color: Color? = nil
    ) -> some View {
        let style = ReeceTypography.text(token, slant: slant)
        let resolved = style.resolve()

        return self
            .font(resolved.font)
            .reeceApplySystemWeightIfNeeded(resolved.systemWeight)
            .reeceApplyItalicIfNeeded(resolved.needsViewItalic)
            .modifier(ReeceTextAttributes(tracking: style.tracking, color: color))
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
