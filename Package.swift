// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Rainy",
    platforms: [
        .iOS(.v16)
    ],
    targets: [
        .executableTarget(
            name: "Rainy",
            path: "Sources"
        )
    ]
)
