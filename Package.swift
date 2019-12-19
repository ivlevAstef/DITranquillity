// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "DITranquillity",
    products: [
        .library(name: "DITranquillity", targets: ["DITranquillity"])
    ],
    dependencies: [
        .package(url: "https://github.com/ivlevAstef/SwiftLazy.git", from: "1.1.6")
    ],
    targets: [
        .target(name: "DITranquillity", dependencies: [
            "SwiftLazy"
        ], path: "./Sources/Core"),

        .testTarget(name: "DITranquillityTest", dependencies: [
            "SwiftLazy", "DITranquillity"
        ])
    ]
)

