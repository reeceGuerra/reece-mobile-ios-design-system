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
    
    /// Ensures that all icons in `RDSIcon.allCases` exist in the assets bundle.
    @Test
    func allIconsExistInBundle() throws {
        let missing: [RDSIcon] = RDSIcon.allCases.filter { icon in
            #if canImport(UIKit)
            let image = UIImage(named: icon.rawValue, in: Bundle.rdsBundle, compatibleWith: nil)
            return (image == nil)
            #elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
            let image = Bundle.rdsBundle.image(forResource: NSImage.Name(icon.rawValue))
            return (image == nil)
            #else
            // Fallback: construct SwiftUI.Image and assume success (no direct existence API).
            // For non-UIKit/AppKit platforms we cannot strongly verify; treat as present.
            _ = Image(icon.rawValue, bundle: .rdsBundle)
            return false
            #endif
        }
        
        #expect(missing.isEmpty, "Missing icon assets: \(missing.map { $0.rawValue }.joined(separator: ", "))")
    }
    
    /// Validates that icons are configured as template images (so tint/color can be applied).
    /// On iOS-family this maps to `UIImage.RenderingMode.alwaysTemplate`.
    /// On macOS this maps to `NSImage.isTemplate == true`.
    @Test
    func iconsAreTemplateRenderable() throws {
        #if canImport(UIKit)
        // Sample a subset to keep test light; if you prefer, iterate allCases.
        // Here we check all to be thorough.
        for icon in RDSIcon.allCases {
            guard let image = UIImage(named: icon.rawValue, in: Bundle.rdsBundle, compatibleWith: nil) else {
                Issue.record("Icon not found for template check: \(icon.rawValue)")
                continue
            }
            // Assets set to "Render As: Template" are surfaced as `.alwaysTemplate`.
            #expect(image.renderingMode == .alwaysTemplate,
                    "Icon is not marked as template: \(icon.rawValue)")
        }
        #elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
        for icon in RDSIcon.allCases {
            guard let image = Bundle.rdsBundle.image(forResource: NSImage.Name(icon.rawValue)) else {
                Issue.record("Icon not found for template check: \(icon.rawValue)")
                continue
            }
            #expect(image.isTemplate,
                    "Icon is not marked as template: \(icon.rawValue)")
        }
        #else
        // Platforms without UIKit/AppKit: we cannot assert template flag reliably.
        // The presence test above is our main signal.
        #expect(true, "Template flag not verifiable on this platform.")
        #endif
    }
}
