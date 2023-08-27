// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "CutBoxCLI",
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "4.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "9.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "CutBoxCLI",
            dependencies: ["CutBoxCLICore"]),
        .target(name: "CutBoxCLICore",
               dependencies: []),
        .testTarget(
            name: "CutBoxCLITests",
            dependencies: ["CutBoxCLICore", "Quick", "Nimble"],
            resources: [.copy("info.ocodo.CutBox.plist")]),
    ]
)
