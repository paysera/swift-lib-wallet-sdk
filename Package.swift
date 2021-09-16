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
            .exact("4.2.0")
        ),
        .package(
            name: "PayseraAccountsSDK",
            url: "https://github.com/paysera/swift-lib-accounts-sdk",
            from: "8.1.0"
        ),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift", .exact("1.4.1"))
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
