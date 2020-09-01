// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "PayseraWalletSDK",
    platforms: [.macOS(.v10_12), .iOS(.v10), .tvOS(.v9), .watchOS(.v2)],
    products: [
        .library(name: "PayseraWalletSDK", targets: ["PayseraWalletSDK"]),
    ],
    dependencies: [
        .package(name: "PayseraCommonSDK", url: "https://github.com/paysera/swift-lib-common-sdk", from: "3.0.1"),
        .package(name: "PayseraAccountsSDK", url: "https://github.com/paysera/swift-lib-accounts-sdk", from: "6.0.2"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift", from: "1.3.0")
    ],
    targets: [
        .target(
            name: "PayseraWalletSDK",
            dependencies: ["PayseraCommonSDK", "PayseraAccountsSDK", "CryptoSwift"]
        ),
        .testTarget(
            name: "PayseraWalletSDKTests",
            dependencies: ["PayseraWalletSDK"]
        ),
    ]
)
