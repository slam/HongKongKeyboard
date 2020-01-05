// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GoogleInputTools",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "GoogleInputTools",
            targets: ["GoogleInputTools"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0-rc.3"),
        .package(url: "https://github.com/Quick/Quick.git", from: "2.2.0"),
        .package(url: "https://github.com/Quick/Nimble.git", .exact("8.0.2")),
    ],
    targets: [
        .target(
            name: "GoogleInputTools",
            dependencies: ["Alamofire"]),
        .testTarget(
            name: "GoogleInputToolsTests",
            dependencies: ["GoogleInputTools", "Quick", "Nimble"]),
    ],
    swiftLanguageVersions: [.v5]
)
