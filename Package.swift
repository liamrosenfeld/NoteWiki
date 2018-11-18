// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NoteWiki",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.5.0"),
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.7.1"),
        .package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", from: "1.10.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura-Markdown", from: "1.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "NoteWiki",
            dependencies: ["Kitura", "HeliumLogger", "KituraStencil", "KituraMarkdown"]
        ),
        .testTarget(
            name: "NoteWikiTests",
            dependencies: [.target(name: "NoteWiki"), "Kitura", "HeliumLogger"]
        )
    ]
)
