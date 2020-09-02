// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BAUtilities",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "BAUtilities",
            targets: ["BAUtilities"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/maniramezan/DateTools", .branch("mani_swiftpm")),
        .package(url: "https://github.com/vhesener/Closures", .branch("master")),
        .package(url: "https://github.com/mxcl/PromiseKit", .branch("v7")),
        .package(url: "https://github.com/JohnSundell/Files", from: "3.1.0"),
        .package(url: "https://github.com/tonyarnold/Differ", .branch("master")),
        .package(url: "https://github.com/marmelroy/Zip", .branch("master")),
        .package(url: "https://github.com/marcosgriselli/ViewAnimator", from: "2.7.0"),

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "BAUtilities",
            dependencies: ["Closures", "PromiseKit", "Files", "DateToolsSwift", "Zip", "Differ", "ViewAnimator"]),
        .testTarget(
            name: "BAUtilitiesTests",
            dependencies: ["BAUtilities"]),
    ]
)
