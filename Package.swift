// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MKGameController",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "MKGameController",
            targets: ["MKGameController"])
    ],
    dependencies: [
        //
    ],
    targets: [
        .target(
            name: "MKGameController",
            dependencies: []),
        .testTarget(
            name: "MKGameControllerTests",
            dependencies: ["MKGameController"])
    ]
)
