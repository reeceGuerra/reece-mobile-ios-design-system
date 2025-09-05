//
//  RDSColors.Root.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 30/08/25.
//

/// Root namespace for Reece Design System color tokens.
///
/// This type acts as a container for value-namespaces (e.g., `primary`, `secondary`)
/// that expose color tokens resolved for SwiftUI. You typically don't interact with
/// this type directly; instead use:
///
/// ```swift
/// // Primary family
/// let c1 = RDSColors.primary.darkBlue(.t80, using: scheme)
///
/// // Secondary family
/// let c2 = RDSColors.secondary.orange(.t40, using: scheme)
/// ```
///
/// - Note: Resolution honors `RDSTheme.mode` (system / light / dark).

@MainActor
public enum RDSColors {}
