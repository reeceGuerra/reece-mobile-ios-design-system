//
//  RDSIconsSyncTests.swift
//  RDSUI
//
//  Created by Carlos Lopez on 06/09/25.
//
//  Purpose:
//  --------
//  Verifies 1:1 sync between `RDSIcon` enum cases and image sets inside
//  `RDSIcons.xcassets`. The test is resilient to execution paths by discovering
//  the package root via `Package.swift` and then searching for the catalog.
//
//  Environment: Swift 6, iOS 17+, macOS 15+
//

import Foundation
import Testing
@testable import RDSUI

/// Test suite that validates the design-system icon enumeration matches the asset catalog.
@Suite("RDSIcons <-> RDSIcons.xcassets sync")
struct RDSIconsSyncTests {

    // MARK: - Helpers

    /// Walks up from the current test file to find the package root (directory containing `Package.swift`).
    ///
    /// - Returns: The URL of the package root directory.
    /// - Throws: If `Package.swift` cannot be found in any ancestor directories.
    private func packageRootURL() throws -> URL {
        var candidate = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
        let fm = FileManager.default

        // Ascend until we find Package.swift or reach filesystem root.
        while candidate.pathComponents.count > 1 {
            let pkg = candidate.appendingPathComponent("Package.swift")
            if fm.fileExists(atPath: pkg.path) {
                return candidate
            }
            candidate.deleteLastPathComponent()
        }

        throw NSError(domain: "RDSIconsSyncTests",
                      code: 100,
                      userInfo: [NSLocalizedDescriptionKey: "Package.swift not found when ascending from \(#filePath)"])
    }

    /// Searches for the first `RDSIcons.xcassets` catalog within the package.
    /// Prefers `Sources/` subtree but falls back to a full-package search.
    ///
    /// - Returns: URL to the `RDSIcons.xcassets` directory.
    /// - Throws: If the catalog cannot be located.
    private func findIconsCatalogURL() throws -> URL {
        let root = try packageRootURL()
        let fm = FileManager.default

        func search(from base: URL) -> URL? {
            guard let it = fm.enumerator(at: base,
                                         includingPropertiesForKeys: [.isDirectoryKey],
                                         options: [.skipsHiddenFiles]) else { return nil }
            for case let url as URL in it {
                if url.lastPathComponent == "RDSIcons.xcassets" {
                    var isDir: ObjCBool = false
                    if fm.fileExists(atPath: url.path, isDirectory: &isDir), isDir.boolValue {
                        return url
                    }
                }
            }
            return nil
        }

        // 1) Try within Sources first (expected location in SwiftPM)
        if let inSources = search(from: root.appendingPathComponent("Sources")) {
            return inSources
        }
        // 2) Fallback: search entire package (in case structure changes)
        if let anywhere = search(from: root) {
            return anywhere
        }

        throw NSError(domain: "RDSIconsSyncTests",
                      code: 101,
                      userInfo: [NSLocalizedDescriptionKey: "RDSIcons.xcassets not found under \(root.path)"])
    }

    /// Scans the `RDSIcons.xcassets` directory and collects all `.imageset` folder names.
    ///
    /// - Parameter catalogURL: URL to the `RDSIcons.xcassets` directory.
    /// - Returns: Set of image set names (folder names without the `.imageset` suffix).
    private func imageSetNames(in catalogURL: URL) throws -> Set<String> {
        let fm = FileManager.default
        var names: Set<String> = []

        guard let enumerator = fm.enumerator(at: catalogURL,
                                             includingPropertiesForKeys: [.isDirectoryKey],
                                             options: [.skipsHiddenFiles]) else {
            return names
        }

        for case let url as URL in enumerator where url.pathExtension == "imageset" {
            names.insert(url.deletingPathExtension().lastPathComponent)
        }
        return names
    }

    // MARK: - Tests

    /// Ensures every `RDSIcon` case has a corresponding `.imageset` folder.
    @Test("All enum cases must exist in the asset catalog")
    func allEnumCasesExistInAssets() throws {
        let catalog = try findIconsCatalogURL()
        let imageSets = try imageSetNames(in: catalog)

        let missing = RDSIcon.allCases
            .map { $0.rawValue }
            .filter { !imageSets.contains($0) }

        #expect(missing.isEmpty, "Missing imagesets for enum cases: \(missing)")
    }

    /// Ensures there are no extra `.imageset` folders without an enum case.
    @Test("No extra image sets without a matching enum case")
    func noExtraImageSetsWithoutEnum() throws {
        let catalog = try findIconsCatalogURL()
        let imageSets = try imageSetNames(in: catalog)

        let enumNames = Set(RDSIcon.allCases.map { $0.rawValue })
        let extras = imageSets.subtracting(enumNames)

        #expect(extras.isEmpty, "Extra imagesets without enum case: \(Array(extras))")
    }
}
