// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RDSUI",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17), .macOS(.v15)
    ],
    products: [
        .library(name: "RDSUI", targets: ["RDSUI"])
    ],
    targets: [
        .target(
            name: "RDSUI",
            path: "Sources/RDSUI",
            resources: [
                .process("Icons/RDSIcons.xcassets"),
                .process("Resources")
            ],
            swiftSettings: [.swiftLanguageMode(.v6)]
        ),
        .testTarget(
            name: "RDSUITests",
            dependencies: ["RDSUI"],
            path: "Tests/RDSUITests",
            swiftSettings: [.swiftLanguageMode(.v6)]
        )
    ]
)
