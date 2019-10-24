// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GoogleCloudPubSubKit",
    products: [
        .library(
            name: "GoogleCloudPubSubKit",
            targets: ["GoogleCloudPubSubKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "GoogleCloudPubSubKit",
            dependencies: []),
        .testTarget(
            name: "GoogleCloudPubSubKitTests",
            dependencies: ["GoogleCloudPubSubKit"]),
    ]
)
