// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "DITranquillity",
    platforms: [.iOS(.v13), .watchOS(.v8), .macOS(.v10_15), .tvOS(.v13)],
    products: [
        .library(name: "DITranquillity",   targets: ["DITranquillity"])
    ],
    dependencies: [
        .package(url: "https://github.com/ivlevAstef/SwiftLazy.git", from: "1.6.1")
    ],
    targets: [
        .target(name: "DITranquillity", dependencies: [
            "SwiftLazy"
        ], path: "./Sources"),
        .testTarget(name: "DITranquillity_Tests", dependencies: [
          "DITranquillity"
        ], path: "./Tests")
    ]
)
