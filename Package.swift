// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "DITranquillity",
    platforms: [.iOS(.v13), .watchOS(.v8), .macOS(.v10_15), .tvOS(.v13)],
    products: [
        .library(name: "DITranquillity", targets: ["DITranquillity"])
    ],
    dependencies: [
//        .package(url: "https://github.com/ivlevAstef/SwiftLazy.git", from: "1.3.0")
      .package(url: "https://github.com/ivlevAstef/SwiftLazy.git", branch: "swift_concurrency")
    ],
    targets: [
        .target(name: "DITranquillity", dependencies: [
            "SwiftLazy"
        ], path: "./Sources", swiftSettings: [.swiftLanguageMode(.v6)]),
        .testTarget(name: "DITranquillity_Tests", dependencies: [
          "DITranquillity"
        ], path: "./Tests")
    ]
)

