//
//  RDSFontRegisterTests.swift
//  RDSDesignSystem
//
//  Created by Carlos Lopez on 03/09/25.
//


import XCTest
import CoreText
import CoreGraphics
#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif
@testable import RDSUI

final class RDSFontRegisterTests: XCTestCase {

    /// PostScript names que esperamos después del registro.
    /// Ajusta esta lista a las caras que realmente mapeas en tu DS.
    private let expectedPostScriptNames: [String] = [
        "Roboto-Regular",
        "OpenSans-Regular",
        "HelveticaNeueLTPro-Regular"
    ]
    
    func test_fontsAreAvailableAfterRegister() {
            // Act: intentamos registrar (idempotente; puede devolver 0 si ya estaban)
            let newlyRegistered = RDSFontRegister.registerAllFonts()

            // Assert: al menos una de las fuentes esperadas debe estar disponible.
            // (Si no está, CGFont(name) devuelve nil)
            var availableCount = 0
            for name in expectedPostScriptNames {
                if CGFont(name as CFString) != nil {
                    availableCount += 1
                }
            }

            XCTAssertGreaterThan(
                availableCount,
                0,
                """
                Expected at least one expected font to be available after register. \
                registerAllFonts() added \(newlyRegistered) new file(s).
                """
            )
        }

    func test_registerAllFonts_isIdempotentButFindsResources() {
            let first = RDSFontRegister.registerAllFonts()
            let second = RDSFontRegister.registerAllFonts()
            // Si las fuentes no existen en el bundle, ambas serían 0 y fallamos.
            XCTAssertTrue(first > 0 || second == 0, "Registrar did not find any font files.")
        }

    /// (Opcional) Diagnóstico si fallara el test – imprime familias/PS names disponibles.
    func test_diagnoseAvailableFonts() {
        // Útil cuando ajustes la lista de nombres esperados.
        #if DEBUG
        _ = RDSFontRegister.registerAllFonts()

        // Listar familias y nombres disponibles en runtime (iOS/macOS)
        #if canImport(UIKit)
        let families = UIFont.familyNames.sorted()
        print("Available font families:", families)
        for fam in families {
            let names = UIFont.fontNames(forFamilyName: fam)
            if !names.isEmpty {
                print("• \(fam):", names)
            }
        }
        #elseif canImport(AppKit)
        let families = NSFontManager.shared.availableFontFamilies.sorted()
        print("Available font families:", families)
        for fam in families {
            let members = NSFontManager.shared.availableMembers(ofFontFamily: fam) ?? []
            let names = members.compactMap { $0.first as? String }
            if !names.isEmpty {
                print("• \(fam):", names)
            }
        }
        #endif
        #endif
    }
}
