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
        .package(url: "https://github.com/YouClap/GoogleCloudKit.git", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "GoogleCloudPubSubKit",
            dependencies: ["GoogleCloudKit"]),
        .testTarget(
            name: "GoogleCloudPubSubKitTests",
            dependencies: ["GoogleCloudPubSubKit"]),
    ]
)
