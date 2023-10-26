// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "ProHUD",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "ProHUD", targets: ["ProHUD"]),
    ],
    dependencies: [
        .package(url: "git@codeup.aliyun.com:6333b695257dab51ddaa62e9/mirrors/SnapKit.git", "5.0.0" ..< "6.0.0"),
    ],
    targets: [
        .target(
            name: "ProHUD",
            dependencies: ["SnapKit"],
            resources: [.process("Resources/ProHUD.xcassets")]
        )
    ]
)
