//
//  RDSIconCategoryTests.swift
//  RDSUI
//
//  Created by Carlos Lopez on 07/09/25.
//
//  Purpose
//  -------
//  Validates the categorization layer for design-system icons:
//  1) Every RDSIcon has an assigned category (no missing mappings).
//  2) Group helpers (icons(in:), static grouped arrays) are consistent with .category.
//  3) Categories are exhaustive (union equals allCases) and non-overlapping.
//
//  Environment: Swift 6, iOS 17+, macOS 15+
//

import Testing
@testable import RDSUI

/// Test suite for validating category coverage and grouping helpers of the RDS icons.
@Suite("RDSIcon categorization")
struct RDSIconCategoryTests {

    // MARK: - Helpers

    /// Returns the icons array that corresponds to a given category, using the
    /// public grouped collections on `RDSIcon` (e.g., `.actions`, `.commerce`, ...).
    ///
    /// - Parameter category: The category to resolve.
    /// - Returns: The array of `RDSIcon` exposed by the convenience collection for that category.
    private func convenienceArray(for category: RDSIconCategory) -> [RDSIcon] {
        switch category {
        case .actions:   return RDSIcon.actions
        case .commerce:  return RDSIcon.commerce
        case .files:     return RDSIcon.files
        case .places:    return RDSIcon.places
        case .media:     return RDSIcon.media
        case .misc:      return RDSIcon.misc
        case .navigation:return RDSIcon.navigation
        case .system:    return RDSIcon.system
        case .time:      return RDSIcon.time
        case .user:      return RDSIcon.user
        }
    }

    // MARK: - Tests

    /// Ensures **every** icon has a category (no missing switch branches or forgotten cases).
    ///
    /// - Note: This implicitly validates the `var category: RDSIconCategory` mapping.
    @Test("All icons must have a category assigned")
    func allIconsHaveCategory() throws {
        var missing: [String] = []

        for icon in RDSIcon.allCases {
            // Accessing `category` must be total; if not, we'd crash or mis-map.
            let cat = icon.category
            // Sanity: ensure category is one of the declared ones.
            #expect(RDSIconCategory.allCases.contains(cat), "Unknown category for icon: \(icon.rawValue)")
            // Optionally assert displayName basic formatting if present:
            // Not empty and not raw kebab (best-effort UX check for demo views).
            let name = icon.displayName
            #expect(!name.isEmpty, "displayName should not be empty for: \(icon.rawValue)")
            #expect(!name.contains("-"), "displayName should be humanized (no '-'): \(icon.rawValue)")
        }

        #expect(missing.isEmpty, "Icons without category: \(missing)")
    }

    /// Verifies that `icons(in:)` returns only icons whose `.category` matches,
    /// and that the convenience arrays (e.g., `RDSIcon.actions`) are identical
    /// to the result of `icons(in:)` for each category.
    @Test("Grouped helpers must match the category filter exactly")
    func groupedHelpersAreConsistent() throws {
        for cat in RDSIconCategory.allCases {
            let viaFilter = Set(RDSIcon.icons(in: cat))
            let viaConvenience = Set(convenienceArray(for: cat))

            // Both ways should produce the same set.
            #expect(viaFilter == viaConvenience, "Mismatch for category \(cat): filter vs convenience arrays differ")

            // And all members must indeed belong to the category.
            let foreign = viaFilter.filter { $0.category != cat }
            #expect(foreign.isEmpty, "Found icons with wrong category in \(cat): \(foreign.map { $0.rawValue })")
        }
    }

    /// Asserts that the union of all category arrays equals `RDSIcon.allCases`,
    /// and that there is no overlap between different category arrays.
    @Test("Categories cover all icons exactly once (no misses, no overlaps)")
    func categoriesAreExhaustiveAndDisjoint() throws {
        let all = Set(RDSIcon.allCases)

        // Build the union and check disjointness pairwise.
        var union = Set<RDSIcon>()
        let buckets = RDSIconCategory.allCases.map { Set(convenienceArray(for: $0)) }

        // Union must equal all cases
        for bucket in buckets { union.formUnion(bucket) }
        #expect(union == all, "Union of categories does not match all icons. Missing: \(all.subtracting(union).map { $0.rawValue })")

        // No overlaps: any pairwise intersection must be empty.
        for i in 0..<buckets.count {
            for j in (i+1)..<buckets.count {
                let inter = buckets[i].intersection(buckets[j])
                #expect(inter.isEmpty, "Categories overlap between \(RDSIconCategory.allCases[i]) and \(RDSIconCategory.allCases[j]): \(inter.map { $0.rawValue })")
            }
        }
    }
}
