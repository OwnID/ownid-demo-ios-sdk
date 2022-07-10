// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "OwnIDDemo",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "DemoAppComponents",
            targets: ["DemoAppComponents"]),
        .library(
            name: "DemoAppUIComponents",
            targets: ["DemoAppUIComponents"]),
        .library(
            name: "GigyaAndScreensetsShared",
            targets: ["GigyaAndScreensetsShared"]),
        .library(
            name: "NormalizedGigyaError",
            targets: ["NormalizedGigyaError"]),
        .library(
            name: "OwnIDAccount",
            targets: ["OwnIDAccount"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SAP/gigya-swift-sdk.git",
                 from: "1.2.0"),
        .package(url: "https://github.com/OwnID/ownid-core-ios-sdk.git",
                 from: "0.0.0"),
        .package(url: "https://github.com/OwnID/ownid-gigya-ios-sdk.git",
                 from: "0.0.0"),
    ],
    targets: [
        .target(name: "DemoAppComponents",
                dependencies: [
                    "DemoAppUIComponents",
                    .product(name: "OwnIDCoreSDK", package: "ownid-core-ios-sdk"),
                    .product(name: "OwnIDFlowsSDK", package: "ownid-core-ios-sdk"),
                    .product(name: "OwnIDUISDK", package: "ownid-core-ios-sdk"),
                ],
                path: "DemoAppComponents",
                resources: [ .copy("FeatureFlags.json") ]),
        
            .target(name: "DemoAppUIComponents",
                    dependencies: [ .product(name: "OwnIDUISDK", package: "ownid-core-ios-sdk"), ],
                    path: "DemoAppUIComponents"),
        
            .target(name: "GigyaAndScreensetsShared",
                    dependencies: [ .product(name: "OwnIDUISDK", package: "ownid-core-ios-sdk"), "DemoAppComponents", "OwnIDAccount" ],
                    path: "GigyaAndScreensetsShared"),
        
            .target(name: "NormalizedGigyaError",
                    dependencies: [ .product(name: "OwnIDGigyaSDK", package: "ownid-gigya-ios-sdk"), "GigyaAndScreensetsShared" ],
                    path: "NormalizedGigyaError"),
        
            .target(name: "OwnIDAccount",
                    dependencies: [ .product(name: "Gigya", package: "gigya-swift-sdk") ],
                    path: "OwnIDAccount"),
    ]
)
