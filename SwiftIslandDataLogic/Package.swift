// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftIslandDataLogic",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "SwiftIslandDataLogic",
            targets: ["SwiftIslandDataLogic"])
    ],
    dependencies: [
        .package(url: "https://github.com/sindresorhus/Defaults.git", from: "8.0.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.26.0")
    ],
    targets: [
        .target(
            name: "SwiftIslandDataLogic",
            dependencies: [
                .product(name: "Defaults", package: "Defaults"),
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
            ]),
        .testTarget(
            name: "SwiftIslandDataLogicTests",
            dependencies: ["SwiftIslandDataLogic"])
    ]
)
