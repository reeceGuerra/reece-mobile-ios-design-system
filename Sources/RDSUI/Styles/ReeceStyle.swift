//
//  ReeceStyle.swift
//  ReeceDesignSystem
//
//  Created by Carlos Lopez on 01/09/25.
//


//
//  ReeceStyle.swift
//  ReeceDesignSystem
//
//  Created by Carlos Guerra Lopez on 09/02/2025.
//
//  This file defines a lightweight abstraction for style tokens in the
//  Reece Design System. Instead of exposing only `Color`, it allows tokens
//  to represent either solid colors or gradients, and provides a unified
//  interface (`AnyShapeStyle`) that can be used across SwiftUI views.
//
//

import SwiftUI

/// A flexible style abstraction that supports solid colors and gradients.
/// Use this when you want to expose a design token that might be more than
/// a single `Color`, but still usable wherever a `ShapeStyle` is required.
///

public enum ReeceStyle {
    
    /// Represents a solid color style.
    case solid(Color)
    
    /// Represents a gradient style.
    case gradient(LinearGradient)
    
    /// Returns the unified `AnyShapeStyle` that can be applied to fills,
    /// strokes, and foreground styles.
    ///
    /// This allows consumers to use `ReeceStyle` in any SwiftUI API
    /// that expects a `ShapeStyle`.
    public var style: AnyShapeStyle {
        switch self {
        case .solid(let color):
            return AnyShapeStyle(color)
        case .gradient(let gradient):
            return AnyShapeStyle(gradient)
        }
    }
}
