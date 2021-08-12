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
            .branch("xcode13")
        ),
        .package(
            name: "PayseraAccountsSDK",
            url: "https://github.com/paysera/swift-lib-accounts-sdk",
            .branch("xcode13")
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
