// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "CutBoxCLI",
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "4.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "9.0.0")
    ],
    targets: [
        .executableTarget(
            name: "CutBoxCLI",
            dependencies: ["CutBoxCLICore"]),
        .target(name: "CutBoxCLICore",
               dependencies: []),
        .testTarget(
            name: "CutBoxCLITests",
            dependencies: ["CutBoxCLICore", "Quick", "Nimble"],
            resources: [.copy("info.ocodo.CutBox.plist")])
    ]
)
