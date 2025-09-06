//
//  RDSTypography.Providers.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 05/09/25.
//
//  Purpose
//  -------
//  Introduces provider protocols and default adapters to decouple the RDSText modifier
//  from concrete token/family resolution (DIP/ISP).
//
//  Usage
//  -----
//  - Inject custom providers via Environment:
//      .environment(\._rdsTypographyProvider, MyTypographyProvider())
//      .environment(\._rdsFontFamilyProvider, MyFontFamilyProvider())
//
//  - Or rely on defaults (RDSTypographyTokensProvider + RDSDefaultFontFamilyProvider).
//

import SwiftUI

// MARK: - Provider Protocols

/// Provides the typography spec (design-driven) for a given token.
/// Implement this to plug a different token source without touching the modifier.
public protocol RDSTypographyTokenProviding {
    func spec(for token: RDSTextStyleToken) -> RDSTypographySpec
}

/// Resolves the preferred font family for a given token.
/// Implement this to override typography families per brand/app.
public protocol RDSFontFamilyProviding {
    func resolvePreferredFamily(for token: RDSTextStyleToken) -> RDSFontFamily
}

// MARK: - Default Providers

/// Default typography provider that defers to `RDSTypography` static tokens/specs.
public struct RDSTypographyTokensProvider: RDSTypographyTokenProviding {
    public init() {}
    public func spec(for token: RDSTextStyleToken) -> RDSTypographySpec {
        RDSTypography.spec(for: token)
    }
}

/// Default family provider:
/// - If the token declares a `preferredFamily`, it wins.
/// - Otherwise, fall back to `.system`.
public struct RDSDefaultFontFamilyProvider: RDSFontFamilyProviding {
    public init() {}
    public func resolvePreferredFamily(for token: RDSTextStyleToken) -> RDSFontFamily {
        RDSTypography.preferredFamily(for: token) ?? .system
    }
}

// MARK: - Environment Wiring

private struct _RDSTypographyProviderKey: EnvironmentKey {
    static let defaultValue: RDSTypographyTokenProviding = RDSTypographyTokensProvider()
}

private struct _RDSFontFamilyProviderKey: EnvironmentKey {
    static let defaultValue: RDSFontFamilyProviding = RDSDefaultFontFamilyProvider()
}

public extension EnvironmentValues {
    /// Typography token provider used by RDS text APIs.
    var _rdsTypographyProvider: RDSTypographyTokenProviding {
        get { self[_RDSTypographyProviderKey.self] }
        set { self[_RDSTypographyProviderKey.self] = newValue }
    }
    /// Font family provider used by RDS text APIs.
    var _rdsFontFamilyProvider: RDSFontFamilyProviding {
        get { self[_RDSFontFamilyProviderKey.self] }
        set { self[_RDSFontFamilyProviderKey.self] = newValue }
    }
}

// MARK: - View helpers

public extension View {
    /// Injects a custom typography token provider for RDS text rendering.
    func rdsTypographyProvider(_ provider: RDSTypographyTokenProviding) -> some View {
        environment(\._rdsTypographyProvider, provider)
    }
    /// Injects a custom font family provider for RDS text rendering.
    func rdsFontFamilyProvider(_ provider: RDSFontFamilyProviding) -> some View {
        environment(\._rdsFontFamilyProvider, provider)
    }
}
