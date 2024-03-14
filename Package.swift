// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWSignInWith3rd_Wechat",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(name: "WWSignInWith3rd_Wechat", targets: ["WWSignInWith3rd_Wechat"]),
    ],
    dependencies: [
        .package(url: "https://github.com/William-Weng/WWSignInWith3rd_Apple", .upToNextMinor(from: "1.1.0")),
        .package(url: "https://github.com/William-Weng/WWPrint", .upToNextMinor(from: "1.3.0")),
        .package(url: "https://github.com/yanyin1986/WechatOpenSDK", .upToNextMinor(from: "2.0.0")),
    ],
    targets: [
        .target(name: "WWSignInWith3rd_Wechat",
                dependencies: ["WWPrint", "WWSignInWith3rd_Apple", "WechatOpenSDK"],
                resources: [.process("WechatSDK"), .copy("Privacy")]
               )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
