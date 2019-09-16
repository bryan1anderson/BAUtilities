// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EMUtilities",
    platforms: [.iOS(.v12)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "EMUtilities",
            targets: ["EMUtilities"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
//    .package(url: "https://github.com/Adorkable-forkable/Closures/tree/SwiftPM.git", bra: "0.6")
        .package(url: "https://github.com/maniramezan/DateTools", .branch("swiftpm_support")),
        .package(url: "https://github.com/Adorkable-forkable/Closures", .branch("SwiftPM")),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON", from: "5.0.0"),
        .package(url: "https://github.com/realm/realm-cocoa", from: "3.17.3"),
        .package(url: "https://github.com/mxcl/PromiseKit", from: "6.10.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0-beta.6"),
        .package(url: "https://github.com/JohnSundell/Files", from: "3.1.0"),
        .package(url: "https://github.com/tonyarnold/Differ", .branch("master")),
        .package(url: "https://github.com/sersoft-gmbh/Zip", .branch("spm_support")),
        .package(url: "https://github.com/kean/Nuke", from: "8.0.1"),
        .package(url: "https://github.com/utahiosmac/Marshal", from: "1.2.8")

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "EMUtilities",
            dependencies: ["Closures", "SwiftyJSON", "RealmSwift", "PromiseKit", "Alamofire", "Files", "DateToolsSwift", "Zip", "Differ", "Nuke", "Marshal"]),
        .testTarget(
            name: "EMUtilitiesTests",
            dependencies: ["EMUtilities"]),
    ]
)
