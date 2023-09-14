// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWSignInWith3rd+Wechat",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(name: "WWSignInWith3rd+Wechat", targets: ["WWSignInWith3rd+Wechat"]),
    ],
    dependencies: [
        .package(name: "WWSignInWith3rd+Apple", url: "https://github.com/William-Weng/WWSignInWith3rd_Apple", .upToNextMinor(from: "1.0.2")),
        .package(url: "https://github.com/William-Weng/WWPrint", .upToNextMinor(from: "1.2.0")),
        .package(url: "https://github.com/yanyin1986/WechatOpenSDK", .upToNextMinor(from: "2.0.0")),
    ],
    targets: [
        .target(name: "WWSignInWith3rd+Wechat", dependencies: ["WWPrint", "WWSignInWith3rd+Apple", "WechatOpenSDK"],resources: [.process("WechatSDK")])
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
