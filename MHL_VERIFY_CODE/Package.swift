// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "MHLDefaultApps",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "MHLDefaultApps",
            targets: ["MHLDefaultApps"]
        )
    ],
    targets: [
        .executableTarget(
            name: "MHLDefaultApps",
            path: "Sources"
        )
    ]
)
