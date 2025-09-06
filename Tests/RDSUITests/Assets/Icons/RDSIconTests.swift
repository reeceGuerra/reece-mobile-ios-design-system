//
//  RDSIconTests.swift
//  RDSUI
//
//  Created by Carlos Lopez on 06/09/25.
//

import Testing
@testable import RDSUI
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

// MARK: - RDSIcon existence & template tests

/// Verifies that every `RDSIcon` case resolves to a concrete image resource
/// in the RDSUI package bundle, and that icons are configured as template images
/// so they can be tinted via SwiftUI `.foregroundStyle` or `.tint()`.
struct RDSIconTests {

    // MARK: Existence

    /// Ensures that all icons in `RDSIcon.allCases` exist in the assets bundle.
    @Test
    func allIconsExistInBundle() throws {
        let missing: [RDSIcon] = RDSIcon.allCases.filter { icon in
            #if canImport(UIKit)
            let image = UIImage(
                named: icon.rawValue,
                in: Bundle.rdsBundle,
                compatibleWith: nil
            )
            return (image == nil)

            #elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
            // AppKit: load from the asset catalog inside the package bundle.
            let name = NSImage.Name(icon.rawValue)
            let image = Bundle.rdsBundle.image(forResource: name) ?? NSImage(named: name)
            return (image == nil)

            #else
            // Fallback: there is no direct existence API; assume present.
            _ = Image(icon.rawValue, bundle: .rdsBundle)
            return false
            #endif
        }

        #expect(
            missing.isEmpty,
            "Missing icon assets: \(missing.map { $0.rawValue }.joined(separator: ", "))"
        )
    }

    // MARK: Template rendering

    /// Validates that icons are configured as template images (so tint/color can be applied).
    /// On iOS-family this maps to `UIImage.RenderingMode.alwaysTemplate`.
    /// On macOS this maps to `NSImage.isTemplate == true`.
    @Test
    func iconsAreTemplateRenderable() throws {
        #if canImport(UIKit)
        for icon in RDSIcon.allCases {
            guard let image = UIImage(
                named: icon.rawValue,
                in: Bundle.rdsBundle,
                compatibleWith: nil
            ) else {
                Issue.record("Icon not found for template check: \(icon.rawValue)")
                continue
            }
            // Assets set to "Render As: Template" surface as `.alwaysTemplate`.
            #expect(
                image.renderingMode == .alwaysTemplate,
                "Icon is not marked as template: \(icon.rawValue)"
            )
        }

        #elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
        for icon in RDSIcon.allCases {
            let name = NSImage.Name(icon.rawValue)
            guard let image = Bundle.rdsBundle.image(forResource: name) ?? NSImage(named: name) else {
                Issue.record("Icon not found for template check: \(icon.rawValue)")
                continue
            }
            #expect(
                image.isTemplate,
                "Icon is not marked as template: \(icon.rawValue)"
            )
        }

        #else
        // Platforms without UIKit/AppKit: cannot assert the template flag reliably.
        #expect(true, "Template flag not verifiable on this platform.")
        #endif
    }
}
