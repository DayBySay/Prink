// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Prink",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Prink",
            targets: ["Prink"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Prink",
            dependencies: []),
        .testTarget(
            name: "PrinkTests",
            dependencies: ["Prink"]),
    ]
)
