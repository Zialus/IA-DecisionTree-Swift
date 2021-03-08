// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "DecisionTree",
    dependencies: [
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "DecisionTree",
            dependencies: ["Rainbow"]
        )
    ]
)
