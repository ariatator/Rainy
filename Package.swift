// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Rainy",
    platforms: [
        .iOS(.v17)
    ],
    targets: [
        .executableTarget(
            name: "Rainy",
            path: "Sources",
            resources: [
                .process("Assets.xcassets")
            ]
        )
    ]
)
