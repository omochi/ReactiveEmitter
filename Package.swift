// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReactiveEmitter",
    products: [
        .library(
            name: "ReactiveEmitter",
            targets: ["ReactiveEmitter"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ReactiveEmitter",
            dependencies: []),
        .testTarget(
            name: "ReactiveEmitterTests",
            dependencies: ["ReactiveEmitter"]),
    ]
)
