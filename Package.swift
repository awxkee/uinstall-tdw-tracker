// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Uinstall",
    platforms: [
        .macOS(.v10_10), .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Uinstall",
            targets: ["Uinstall"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.3"))
    ],
    targets: [
        .target(
            name: "Uinstall",
            dependencies: [.product(name: "Alamofire", package: "Alamofire")],
            path: "uinstall-tracker/Classes"
    ]
)

