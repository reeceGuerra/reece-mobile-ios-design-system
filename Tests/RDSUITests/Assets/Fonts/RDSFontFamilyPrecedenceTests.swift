//
//  RDSFontFamilyPrecedenceTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 04/09/25.
//


//
//  RDSFontFamilyPrecedenceTests.swift
//  RDSDesignSystemTests
//
//  Purpose: sanity checks around family precedence mechanics and spec propagation.
//  Note: We verify compute-level effects and spec behavior; environment precedence
//  is exercised indirectly via `.reeceText(...)` in existing tests.
//
import Testing
import SwiftUI
@testable import RDSUI

// Test doubles for providers
private struct FakeTypographyProvider: RDSTypographyTokenProviding {
    let suppliedSpec: RDSTypographySpec
    func spec(for token: RDSTextStyleToken) -> RDSTypographySpec { suppliedSpec }
}

private struct FakeFamilyProvider: RDSFontFamilyProviding {
    let fallback: RDSFontFamily
    func resolvePreferredFamily(for token: RDSTextStyleToken) -> RDSFontFamily { fallback }
}

/// Small helper to mimic the family precedence we specify in the design:
/// explicit > spec.preferredFamily > provider.resolvePreferredFamily
private func resolveFamily(explicit: RDSFontFamily?,
                           spec: RDSTypographySpec,
                           token: RDSTextStyleToken,
                           provider: RDSFontFamilyProviding) -> RDSFontFamily {
    return explicit ?? spec.preferredFamily ?? provider.resolvePreferredFamily(for: token)
}

@Suite("RDS Font Family Precedence")
struct RDSFontFamilyPrecedenceTests {

    @MainActor
    @Test("Explicit family overrides preferred and provider")
    func explicitFamilyBeatsPreferredAndProvider() async {
        // Spec declares a preferred family (Roboto)
        let spec = RDSTextSpec(
            designFontSizePx: 16,
            pointSizeOverride: nil,
            weight: .regular,
            slant: .italic,           // use italic to make the difference observable
            relativeTo: .body,
            designLineHeightPx: 24,
            letterSpacingPercent: 0,
            preferredFamily: .roboto  // preferred from token/spec
        )

        let token: RDSTextStyleToken = .buttonM
        let typography = FakeTypographyProvider(suppliedSpec: spec)
        let familyProvider = FakeFamilyProvider(fallback: .system)

        // Precedence: explicit (.system) should win over preferred (.roboto)
        let chosen = resolveFamily(explicit: .system,
                                   spec: typography.spec(for: token),
                                   token: token,
                                   provider: familyProvider)

        #expect(chosen == .system)

        // Observability: system+italic relies on view-level italic
        let base = spec.basePointSize(usingScale: 1.0)
        let resolved = RDSFontResolver.resolve(for: spec, family: chosen, basePointSize: base)
        #expect(resolved.needsViewItalic == true)
    }

    @MainActor
    @Test("Preferred family overrides provider when no explicit family")
    func preferredBeatsProvider() async {
        let spec = RDSTextSpec(
            designFontSizePx: 16,
            pointSizeOverride: nil,
            weight: .regular,
            slant: .italic,
            relativeTo: .body,
            designLineHeightPx: 24,
            letterSpacingPercent: 0,
            preferredFamily: .roboto
        )

        let token: RDSTextStyleToken = .buttonM
        let typography = FakeTypographyProvider(suppliedSpec: spec)
        let familyProvider = FakeFamilyProvider(fallback: .system)

        // No explicit -> preferred (roboto) should be used
        let chosen = resolveFamily(explicit: nil,
                                   spec: typography.spec(for: token),
                                   token: token,
                                   provider: familyProvider)

        #expect(chosen == .roboto)

        // Observability: roboto has real italic faces -> no view-level italic
        let base = spec.basePointSize(usingScale: 1.0)
        let resolved = RDSFontResolver.resolve(for: spec, family: chosen, basePointSize: base)
        #expect(resolved.needsViewItalic == false)
    }

    @MainActor
    @Test("Provider is used when neither explicit nor preferred is set")
    func providerUsedWhenNoExplicitOrPreferred() async {
        let spec = RDSTextSpec(
            designFontSizePx: 16,
            pointSizeOverride: nil,
            weight: .regular,
            slant: .italic,
            relativeTo: .body,
            designLineHeightPx: 24,
            letterSpacingPercent: 0,
            preferredFamily: nil
        )

        let token: RDSTextStyleToken = .body
        let typography = FakeTypographyProvider(suppliedSpec: spec)

        // Use a non-system provider fallback to make it observable
        let familyProvider = FakeFamilyProvider(fallback: .roboto)

        let chosen = resolveFamily(explicit: nil,
                                   spec: typography.spec(for: token),
                                   token: token,
                                   provider: familyProvider)

        #expect(chosen == .roboto)

        let base = spec.basePointSize(usingScale: 1.0)
        let resolved = RDSFontResolver.resolve(for: spec, family: chosen, basePointSize: base)
        #expect(resolved.needsViewItalic == false)
    }
}
