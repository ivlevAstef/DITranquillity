// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "DITranquillity",
    platforms: [.iOS(.v13), .watchOS(.v8), .macOS(.v10_15), .tvOS(.v13)],
    products: [
        .library(name: "DITranquillity", targets: ["DITranquillity"])
    ],
    dependencies: [],
    targets: [
        .target(name: "DITranquillity", dependencies: [], path: "./Sources"),
        .testTarget(name: "DITranquillity_Tests", dependencies: [
          "DITranquillity"
        ], path: "./Tests")
    ]
)
