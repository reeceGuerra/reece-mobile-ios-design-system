//
//  ReeceText+Modifier.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 02/09/25.
//
//  Public APIs:
//   1) Builder: ReeceText(_:token:slant:color:family:designScale:)
//   2) View fallback: .reeceText(_:slant:color:family:designScale:)
// Implementation notes:
//   - @MainActor: all SwiftUI-facing APIs are main-actor isolated.
//   - _computeTextStyle(...) unwraps optional letterSpacingPercent safely.
//

import SwiftUI

/// Computes SwiftUI `Font`, kerning and line spacing for the given spec/family.
/// Uses `ReeceFontResolver.resolve(for:family:basePointSize:)` from ReeceFonts.swift.
///
/// - Parameters:
///   - spec: Fully design-driven text spec (px-based + metadata).
///   - family: Effective font family to use.
///   - designScale: Optional px→pt scale factor (if `nil`, spec uses 1.0).
/// - Returns: Tuple with `font`, `kerning` (points), `lineSpacing` (extra leading) and `needsViewItalic`.
func _computeTextStyle(spec: ReeceTextSpec,
                       family: ReeceFontFamily,
                       designScale: CGFloat?) -> (font: Font, kerning: CGFloat, lineSpacing: CGFloat, needsViewItalic: Bool) {
    
    // 1) Base size in points (pre–Dynamic Type)
    let basePt = spec.basePointSize(usingScale: designScale)
    
    // 2) Resolve font via central resolver
    let resolved = ReeceFontResolver.resolve(for: spec,
                                             family: family,
                                             basePointSize: basePt)
    
    // 3) Kerning from percent over point size (safe unwrap)
    let kernPercent: CGFloat = spec.letterSpacingPercent ?? 0.0
    let kerning = (kernPercent / 100.0) * basePt
    
    // 4) Extra spacing over the base point size (use multiple if present)
    let lineSpacing: CGFloat
    if let multiple = spec.lineHeightMultiple() {
        lineSpacing = (multiple * basePt) - basePt
    } else {
        lineSpacing = 0
    }
    
    return (resolved.font, kerning, lineSpacing, resolved.needsViewItalic)
}

// MARK: - Reece Text Modifier (Environment-aware)

/// Applies Reece Typography to any view using token specs and font-family resolution.
/// Family resolution priority (highest → lowest):
/// 1) Explicit `family:` at call site
/// 2) Token `preferredFamily`
/// 3) Environment `\.reeceFontFamily`
/// 4) `.system` fallback
public struct ReeceTextModifier: ViewModifier {
    // Inputs
    private let token: ReeceTextStyleToken
    private let slant: ReeceFontSlant?
    private let color: Color?
    private let explicitFamily: ReeceFontFamily?
    private let designScale: CGFloat?
    
    // Environment: global default family
    @Environment(\.reeceFontFamily) private var envFamily
    
    /// Creates a modifier that styles text according to a Reece token.
    /// - Parameters:
    ///   - token: Typography token describing size/weight/metrics.
    ///   - slant: Optional font slant (e.g., italic).
    ///   - color: Optional SwiftUI color to apply.
    ///   - family: Optional explicit font family override (highest priority).
    ///   - designScale: Optional design px → pt scale factor used for `basePointSize`.
    public init(token: ReeceTextStyleToken,
                slant: ReeceFontSlant? = nil,
                color: Color? = nil,
                family: ReeceFontFamily? = nil,
                designScale: CGFloat? = nil) {
        self.token = token
        self.slant = slant
        self.color = color
        self.explicitFamily = family
        self.designScale = designScale
    }
    
    /// Builds the styled view using the resolved spec and `_computeTextStyle`.
    /// - Parameter content: The input view.
    /// - Returns: A view styled with font, kerning and line spacing.
    public func body(content: Content) -> some View {
        // Base token spec
        var spec = token.spec
        
        // Apply slant override (if any)
        if let s = slant {
            spec = spec.with(slant: s)
        }
        
        // Resolve effective family
        let effectiveFamily = explicitFamily
        ?? spec.preferredFamily
        ?? envFamily
        
        // Compute final font & metrics via resolver
        let style = _computeTextStyle(spec: spec,
                                      family: effectiveFamily,
                                      designScale: designScale)
        
        // Apply to content
        let styled = content
            .font(style.font)
            .kerning(style.kerning)
            .lineSpacing(style.lineSpacing)
            .italicIf(style.needsViewItalic)
            .foregroundStyleIf(color)
        
        return styled
    }
}

// MARK: - View Convenience

@available(iOS 17, macOS 14, *)
public extension View {
    /// Applies Reece Typography using the given token and optional overrides.
    /// - Parameters:
    ///   - token: Typography token describing size/weight/metrics.
    ///   - slant: Optional font slant (e.g., italic).
    ///   - color: Optional SwiftUI color to apply.
    ///   - family: Optional explicit font family override. If `nil`, the environment is used.
    ///   - designScale: Optional design px → pt scale factor used for `basePointSize`.
    /// - Returns: A view styled with Reece typography rules.
    func reeceText(_ token: ReeceTextStyleToken,
                   slant: ReeceFontSlant? = nil,
                   color: Color? = nil,
                   family: ReeceFontFamily? = nil,
                   designScale: CGFloat? = nil) -> some View {
        modifier(ReeceTextModifier(token: token,
                                   slant: slant,
                                   color: color,
                                   family: family,
                                   designScale: designScale))
    }
    /// Conditionally applies `.italic()` when `flag` is true.
    /// - Parameter flag: When `true`, applies italic.
    @ViewBuilder
    func italicIf(_ flag: Bool) -> some View {
        if flag { self.italic() } else { self }
    }
    
    /// Conditionally applies `.foregroundStyle(_:)` if a color is provided.
    /// - Parameter color: Optional color to apply.
    @ViewBuilder
    func foregroundStyleIf(_ color: Color?) -> some View {
        if let c = color { self.foregroundStyle(c) } else { self }
    }
}
