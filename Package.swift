// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "DecisionTree",
    dependencies: [
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "DecisionTree",
            dependencies: ["Rainbow"])
    ]
)
