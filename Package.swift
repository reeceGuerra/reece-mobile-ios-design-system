// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReeceDesignSystem",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "ReeceDesignSystem",
            targets: ["ReeceDesignSystem"]
        )
    ],
    targets: [
        .target(
            name: "ReeceDesignSystem",
            path: "Sources/ReeceDesignSystem",
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "ReeceDesignSystemTests",
            dependencies: ["ReeceDesignSystem"],
            path: "Tests/ReeceDesignSystemTests",
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        )
    ]
)
