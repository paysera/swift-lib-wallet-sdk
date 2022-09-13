// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "PayseraWalletSDK",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "PayseraWalletSDK", targets: ["PayseraWalletSDK"]),
    ],
    dependencies: [
        .package(
            name: "PayseraCommonSDK",
            url: "https://github.com/paysera/swift-lib-common-sdk",
            .exact("4.2.2")
        ),
        .package(
            name: "PayseraAccountsSDK",
            url: "https://github.com/paysera/swift-lib-accounts-sdk",
            from: "8.2.1"
        ),
        .package(
            url: "https://github.com/krzyzanowskim/CryptoSwift",
            .exact("1.4.2")
        ),
        .package(
            url: "https://github.com/konkab/AlamofireNetworkActivityLogger",
            .upToNextMajor(from: "3.0.0")
        ),
    ],
    targets: [
        .target(
            name: "PayseraWalletSDK",
            dependencies: [
                "PayseraCommonSDK",
                "PayseraAccountsSDK",
                "CryptoSwift",
                "AlamofireNetworkActivityLogger"
            ]
        ),
        .testTarget(
            name: "PayseraWalletSDKTests",
            dependencies: ["PayseraWalletSDK"]
        ),
    ]
)
