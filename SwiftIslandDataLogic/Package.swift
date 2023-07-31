// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftIslandDataLogic",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "SwiftIslandDataLogic",
            targets: ["SwiftIslandDataLogic"]),
    ],
    dependencies: [
        .package(url: "https://github.com/sindresorhus/Defaults.git", from: "7.1.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.11.0"),
    ],
    targets: [
        .target(
            name: "SwiftIslandDataLogic",
            dependencies: [
                .product(name: "Defaults", package: "Defaults"),
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk")
            ]),
        .testTarget(
            name: "SwiftIslandDataLogicTests",
            dependencies: ["SwiftIslandDataLogic"]),
    ]
)
