// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SemanticVersion",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SemanticVersion",
            targets: ["SemanticVersion"]
        )
    ],
    targets: [
        .target(
            name: "SemanticVersion"
        ),
        .testTarget(
            name: "SemanticVersionTests",
            dependencies: ["SemanticVersion"]
        )
    ]
)
