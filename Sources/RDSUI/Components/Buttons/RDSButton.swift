//
//  RDSButton.swift
//  RDSUI
//
//  Created by Carlos Lopez on 05/09/25.
//

import SwiftUI

// MARK: - RDSButton

/// A design-system button that renders **fixed sizes** and **themed palettes** based on
/// `variant`, `type`, and `state`. The appearance (colors, underline) is sourced via
/// ``RDSButtonPaletteProvider`` and the text styling via ``RDSButtonTypographyProvider``.
///
/// This view is intentionally **minimal**: it keeps only the public API and delegates
/// visual feedback (pressed/hover/focus) to a `ButtonStyle`.
/// Layout helpers and metrics are implemented in `RDSButton.Layout.swift`,
/// Enums and tokens live in `RDSButton.Types.swift` and `RDSButtonTokens.swift`.
///
/// ### Usage
/// ```swift
/// RDSButton(
///     title: "Continue",
///     variant: .primary,
///     type: .default,
///     size: .default,
///     state: .normal,
///     icon: Image(systemName: "arrow.right"),
///     action: { /* perform action */ }
/// )
/// ```
public struct RDSButton: View {
    
    // MARK: Public API
    
    /// Visible text label.
    public let title: String
    
    /// Visual variant: `.primary`, `.secondary`, `.alternative`.
    public let variant: RDSButtonVariant
    
    /// Visual type inside a variant: `.default` or `.textLink`.
    public let type: RDSButtonType
    
    /// Fixed layout configuration (width/height and icon placement).
    public let size: RDSButtonSize
    
    /// External state of the control (drives palette and interactivity).
    public let state: RDSButtonState
    
    /// Optional icon. It is shown only for `.iconLeft` and `.iconRight` sizes.
    public let icon: Image?
    
    /// Action executed on tap when interactive.
    public let action: () -> Void
    
    // MARK: Internal dependencies (injected)
    
    /// Supplies the palette (background/border/selection/underline) for any configuration.
    internal let paletteProvider: RDSButtonPaletteProvider
    
    /// Supplies text tokens and scale behavior for each size.
    internal let typographyProvider: RDSButtonTypographyProvider
    
    // MARK: - Init
    
    /// Creates an `RDSButton`.
    /// - Parameters:
    ///   - title: Visible text.
    ///   - variant: Button variant. Defaults to `.primary`.
    ///   - type: Button type. Defaults to `.default`.
    ///   - size: Layout preset. Defaults to `.default`.
    ///   - state: External state. Defaults to `.normal`.
    ///   - icon: Optional icon. Only rendered for `.iconLeft`/`.iconRight` sizes.
    ///   - paletteProvider: Provider for visual palettes. Defaults to `RDSButtonTokensPaletteProvider()`.
    ///   - typographyProvider: Provider for text tokens. Defaults to `RDSButtonTypographyTokens()`.
    ///   - action: Closure executed on tap.
    public init(
        title: String,
        variant: RDSButtonVariant = .primary,
        type: RDSButtonType = .default,
        size: RDSButtonSize = .default,
        state: RDSButtonState = .normal,
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
    
    // MARK: - View
    
    public var body: some View {
        // Preserve existing “interactivity” rules: disabled and loading are not tappable.
        let isInteractive = (state != .disabled && state != .loading)
        
        Button(action: { if isInteractive { action() } }) {
            // We delegate full rendering to the style to react to press/hover/focus.
            EmptyView()
        }
        .buttonStyle(
            RDSPressAwareButtonStyle(
                title: title,
                icon: icon,
                variant: variant,
                type: type,
                size: size,
                state: state,
                paletteProvider: paletteProvider,
                typographyProvider: typographyProvider,
                isInteractive: isInteractive
            )
        )
        .allowsHitTesting(isInteractive)
    }
}

// MARK: - Press-Aware / Hover / Focus ButtonStyle

/// A `ButtonStyle` that renders RDS visuals and switches to the `.highlighted` palette
/// while the control is **pressed**, **hovered** (macOS), or **focused** (macOS),
/// but only when the external `state == .normal`.
///
/// The style reuses shared renderers from `RDSButton.Layout.swift` to keep a single
/// source of truth for layout and skin.
@MainActor
internal struct RDSPressAwareButtonStyle: ButtonStyle {
    
    // MARK: Configuration Inputs
    
    /// Text label to render.
    let title: String
    /// Optional leading/trailing icon (depending on `size`).
    let icon: Image?
    /// Variant selection.
    let variant: RDSButtonVariant
    /// Type selection.
    let type: RDSButtonType
    /// Fixed size (width/height and icon placement).
    let size: RDSButtonSize
    /// External state (may be overridden visually when pressed/hovered/focused).
    let state: RDSButtonState
    /// Palette provider that resolves colors and underline behavior.
    let paletteProvider: RDSButtonPaletteProvider
    /// Typography provider that resolves text tokens and minimum scale factor.
    let typographyProvider: RDSButtonTypographyProvider
    /// Interactivity flag (e.g., disabled/loading are non-interactive).
    let isInteractive: Bool
    
    // MARK: - ButtonStyle
    
    /// Builds the visual body using a wrapper that tracks hover/focus on macOS.
    /// - Parameter configuration: Provides the press-state via `isPressed`.
    /// - Returns: A view representing the complete button surface.
    func makeBody(configuration: Configuration) -> some View {
        Render(
            configuration: configuration,
            title: title,
            icon: icon,
            variant: variant,
            type: type,
            size: size,
            state: state,
            paletteProvider: paletteProvider,
            typographyProvider: typographyProvider,
            isInteractive: isInteractive
        )
    }
    
    // MARK: - Testable mapping helper
    
    /// Computes the effective visual state for the button skin.
    ///
    /// This helper is **pure** and marked `internal` so it can be validated from
    /// unit tests via `@testable import RDSUI`, without requiring UI hosting.
    ///
    /// - Parameters:
    ///   - externalState: The externally provided `RDSButtonState`.
    ///   - isPressed: Indicates if the control is currently pressed.
    ///   - isHovered: Indicates if the pointer is over the control (macOS only).
    ///   - isFocused: Indicates if the control has keyboard focus (macOS only).
    ///   - isInteractive: If `false`, interaction flags are ignored (e.g., disabled/loading).
    /// - Returns: `.highlighted` when `externalState == .normal` and at least one
    ///            interaction flag applies for the current platform; otherwise `externalState`.
    internal static func mapEffectiveState(
        externalState: RDSButtonState,
        isPressed: Bool,
        isHovered: Bool,
        isFocused: Bool,
        isInteractive: Bool
    ) -> RDSButtonState {
        guard externalState == .normal, isInteractive else { return externalState }
        #if os(macOS)
        if isPressed || isHovered || isFocused { return .highlighted }
        return .normal
        #else
        return isPressed ? .highlighted : .normal
        #endif
    }
    
    // MARK: - Internal Render View (tracks hover/focus on macOS)
    
    @MainActor
    private struct Render: View {
        let configuration: Configuration
        let title: String
        let icon: Image?
        let variant: RDSButtonVariant
        let type: RDSButtonType
        let size: RDSButtonSize
        let state: RDSButtonState
        let paletteProvider: RDSButtonPaletteProvider
        let typographyProvider: RDSButtonTypographyProvider
        let isInteractive: Bool
        
        @State private var isHovered: Bool = false
        #if os(macOS)
        @FocusState private var isFocused: Bool
        #endif
        
        var body: some View {
            let effective = RDSPressAwareButtonStyle.mapEffectiveState(
                externalState: state,
                isPressed: configuration.isPressed,
                isHovered: isHoveredOnCurrentPlatform,
                isFocused: isFocusedOnCurrentPlatform,
                isInteractive: isInteractive
            )
            
            let palette = paletteProvider.palette(
                for: variant,
                type: type,
                state: effective
            )
            
            let label = RDSButton.buildLabel(
                title: title,
                icon: icon,
                size: size,
                state: state, // spinner/line-limit driven by external state
                palette: palette, // colors/underline driven by effective visual state
                typographyProvider: typographyProvider
            )
            
            let base = RDSButton
                .buildSurface(label, size: size, state: state, palette: palette)
                .animation(.easeInOut(duration: 0.12),
                           value: configuration.isPressed || isHoveredOnCurrentPlatform || isFocusedOnCurrentPlatform)
            
            #if os(macOS)
            return AnyView(
                base
                    .focusable(isInteractive)
                    .focused($isFocused)
                    .onHover { isHovered = $0 }
                    .overlay(
                        Group {
                            if isFocused {
                                RoundedRectangle(cornerRadius: 3, style: .continuous)
                                    .stroke(Color.accentColor.opacity(0.9), lineWidth: 2)
                            }
                        }
                    )
            )
            #else
            return AnyView(base)
            #endif
        }
        
        // MARK: - Platform flags
        
        /// Whether the control is hovered on the current platform.
        private var isHoveredOnCurrentPlatform: Bool {
            #if os(macOS)
            return isHovered
            #else
            return false
            #endif
        }
        
        /// Whether the control is focused on the current platform.
        private var isFocusedOnCurrentPlatform: Bool {
            #if os(macOS)
            return isFocused
            #else
            return false
            #endif
        }
    }
}
