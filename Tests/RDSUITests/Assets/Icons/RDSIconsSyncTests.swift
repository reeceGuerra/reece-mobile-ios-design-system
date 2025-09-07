//
//  RDSIconsSyncTests.swift
//  RDSUI
//
//  Created by Carlos Lopez on 06/09/25.
//
//  Purpose:
//  --------
//  Verifies 1:1 sync between `RDSIcon` enum cases and image sets inside
//  `Sources/RDSUI/Resources/Icons/RDSIcons.xcassets`.
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

    /// Returns the absolute URL to the `RDSIcons.xcassets` folder in the source tree.
    ///
    /// The test navigates relative to this file's location in `Tests/`.
    /// It ascends to the package root, then into `Sources/RDSUI/Resources/Icons/RDSIcons.xcassets`.
    ///
    /// - Returns: A file URL pointing to the asset catalog directory.
    /// - Throws: An error if the directory cannot be found at the expected path.
    private func iconsCatalogURL() throws -> URL {
        let thisFile = URL(fileURLWithPath: #filePath)
        let testsDir = thisFile.deletingLastPathComponent() // .../Tests/RDSUIIconTests
        let packageRoot = testsDir.deletingLastPathComponent() // .../Tests
            .deletingLastPathComponent() // .../(package root)

        let catalog = packageRoot
            .appendingPathComponent("Sources")
            .appendingPathComponent("RDSUI")
            .appendingPathComponent("Resources")
            .appendingPathComponent("Icons")
            .appendingPathComponent("RDSIcons.xcassets")

        guard FileManager.default.fileExists(atPath: catalog.path) else {
            throw NSError(domain: "RDSIconsSyncTests",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "RDSIcons.xcassets not found at \(catalog.path)"])
        }
        return catalog
    }

    /// Scans the `RDSIcons.xcassets` directory and collects all `.imageset` folder names.
    ///
    /// - Parameter catalogURL: The URL to the `RDSIcons.xcassets` directory.
    /// - Returns: A set containing each image set name (folder name without `.imageset`).
    /// - Throws: An error if enumeration fails.
    private func imageSetNames(in catalogURL: URL) throws -> Set<String> {
        let fm = FileManager.default
        var names: Set<String> = []

        guard let enumerator = fm.enumerator(at: catalogURL,
                                             includingPropertiesForKeys: [.isDirectoryKey],
                                             options: [.skipsHiddenFiles]) else {
            return names
        }

        for case let url as URL in enumerator {
            if url.pathExtension == "imageset" {
                names.insert(url.deletingPathExtension().lastPathComponent)
            }
        }
        return names
    }

    // MARK: - Tests

    /// Ensures every `RDSIcon` case has a corresponding `.imageset` folder.
    ///
    /// - Throws: Propagates file system errors when reading the catalog.
    @Test("All enum cases must exist in the asset catalog")
    func allEnumCasesExistInAssets() throws {
        let catalog = try iconsCatalogURL()
        let imageSets = try imageSetNames(in: catalog)

        let missing = RDSIcon.allCases
            .map { $0.rawValue }
            .filter { !imageSets.contains($0) }

        #expect(missing.isEmpty, "Missing imagesets for enum cases: \(missing)")
    }

    /// Ensures there are no extra `.imageset` folders without an enum case.
    ///
    /// - Throws: Propagates file system errors when reading the catalog.
    @Test("No extra image sets without a matching enum case")
    func noExtraImageSetsWithoutEnum() throws {
        let catalog = try iconsCatalogURL()
        let imageSets = try imageSetNames(in: catalog)

        let enumNames = Set(RDSIcon.allCases.map { $0.rawValue })
        let extras = imageSets.subtracting(enumNames)

        #expect(extras.isEmpty, "Extra imagesets without enum case: \(Array(extras))")
    }
}
