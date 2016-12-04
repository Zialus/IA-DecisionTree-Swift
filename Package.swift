import PackageDescription

let package = Package(
    name: "DecisionTree",
    dependencies: [
        .Package(url: "https://github.com/onevcat/Rainbow.git", majorVersion: 2)
    ]
)
