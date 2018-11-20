// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "NoteWiki",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"), // 💧
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0"), // 🍃
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0"), // 🔵
        .package(url: "https://github.com/vapor-community/markdown", from: "0.4.0") // ⬇
    ],
    targets: [
        .target(
            name: "App",
            dependencies: ["Vapor", "FluentSQLite", "Leaf", "SwiftMarkdown"]
        ),
        .target(
            name: "Run",
            dependencies: ["App"]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: ["App"]
        )
    ]
)

