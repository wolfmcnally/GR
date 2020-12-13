// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "GR",
    platforms: [
        .iOS(.v14), .tvOS(.v14)
    ],
    products: [
        .library(
            name: "GR",
            targets: ["GR"]),
    ],
    dependencies: [
         .package(url: "https://github.com/wolfmcnally/Interpolate.git", from: "0.2.0"),
    ],
    targets: [
        .target(
            name: "GR",
            dependencies: ["Interpolate"]),
        .testTarget(
            name: "GRTests",
            dependencies: ["GR"]),
    ]
)
