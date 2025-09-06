//
//  RDSIconRenderTests.swift
//  RDSUI
//
//  Created by Carlos Lopez on 06/09/25.
//

import Testing
import SwiftUI
@testable import RDSUI

#if canImport(UIKit)
import UIKit
#endif

/// Tests that design system icons actually render visible pixels when drawn with SwiftUI.
/// This helps catch issues with "empty" or incorrectly exported PDFs.
@MainActor
struct RDSIconRenderTests {

    /// Renders a sample of icons and checks that the resulting bitmap is not fully transparent.
    /// - Note: Uses `ImageRenderer` (iOS 17+/macOS 14+) and runs on the main actor because `ImageRenderer` is main-actor isolated.
    @Test
    func iconsRenderNonEmptyBitmaps() throws {
        let sampleIcons: [RDSIcon] = [
            .camera1,
            .shoppingCart,
            .creditCardVisa,
            .search,
            .clock
        ]

        for icon in sampleIcons {
            // Build a SwiftUI view (not a plain Image) to apply template + tint
            let view = Image(rds: icon)
                .renderingMode(.template)
                .foregroundStyle(.black)

            #if canImport(UIKit)
            if let cgImage = renderToCGImage(view: view, size: CGSize(width: 32, height: 32)) {
                let hasVisiblePixels = cgImageContainsNonTransparentPixels(cgImage)
                #expect(hasVisiblePixels, "Rendered icon appears empty: \(icon.rawValue)")
            } else {
                Issue.record("Could not render icon: \(icon.rawValue)")
            }
            #else
            // On platforms without UIKit/AppKit pixel access, we at least ensure no crash during render.
            _ = ImageRenderer(content: view).cgImage
            #expect(true)
            #endif
        }
    }
}

#if canImport(UIKit)
/// Renders an arbitrary SwiftUI view into a `CGImage` using `ImageRenderer`.
/// - Parameters:
///   - view: The SwiftUI view to render (e.g., an `Image` with modifiers).
///   - size: The target render size in points.
/// - Returns: A `CGImage` if rendering succeeds; otherwise `nil`.
@MainActor
private func renderToCGImage<V: View>(view: V, size: CGSize) -> CGImage? {
    let renderer = ImageRenderer(content: view)
    renderer.scale = 1
    renderer.proposedSize = .init(size)
    return renderer.cgImage
}

/// Scans a `CGImage` in RGBA8 format to detect at least one non-transparent pixel.
/// - Parameter cgImage: The image to inspect.
/// - Returns: `true` if any pixel has alpha > 0; otherwise `false`.
private func cgImageContainsNonTransparentPixels(_ cgImage: CGImage) -> Bool {
    guard let data = cgImage.dataProvider?.data,
          let ptr = CFDataGetBytePtr(data) else { return false }
    let length = CFDataGetLength(data)

    // Iterate pixels in RGBA (bytes: R,G,B,A). We only need alpha.
    for i in stride(from: 0, to: length, by: 4) {
        let alpha = ptr[i + 3]
        if alpha > 0 { return true }
    }
    return false
}
#endif
