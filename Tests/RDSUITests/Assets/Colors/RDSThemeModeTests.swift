//
//  RDSThemeModeTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 03/09/25.
//


//
//  RDSThemeModeTests.swift
//  RDSDesignSystemTests
//
//  Verifies RDSThemeMode semantics and RDSTheme global configuration.
//  - Ensures allCases has expected cases and order
//  - Ensures id mirrors title
//  - Ensures effectiveScheme logic (system passthrough vs forced schemes)
//  - Ensures RDSTheme.mode default and mutability on the main actor
//
import Testing
import SwiftUI
@testable import RDSUI

@Suite("RDSThemeMode", .serialized)
struct RDSThemeModeTests {

    @Test("Orden y cantidad de casos")
    func allCasesOrderAndCount() {
        #expect(RDSThemeMode.allCases == [.system, .light, .dark])
    }

    @Test("id coincide con title")
    func idMatchesTitle() {
        for mode in RDSThemeMode.allCases {
            #expect(mode.id == mode.title)
        }
    }

    @Test("system hace passthrough del scheme")
    func resolveSystemPassthrough() {
        #expect(RDSThemeMode.system.resolve(.light) == .light)
        #expect(RDSThemeMode.system.resolve(.dark) == .dark)
    }

    @Test("light/dark forzados")
    func resolveForced() {
        #expect(RDSThemeMode.light.resolve(.dark) == .light)
        #expect(RDSThemeMode.dark.resolve(.light) == .dark)
    }

    @MainActor
    @Test("RDSTheme.mode default y mutabilidad")
    func globalThemeDefaultAndMutability() async {
        let original = RDSTheme.mode
        #expect(original == .system)

        RDSTheme.mode = .dark
        #expect(RDSTheme.mode == .dark)

        RDSTheme.mode = original
        #expect(RDSTheme.mode == .system)
    }
}
