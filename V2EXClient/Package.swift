// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
        name: "V2EXClient",
        platforms: [
            .iOS(.v15),
            .macOS(.v12)
        ],
        products: [
            // Products define the executables and libraries a package produces, and make them visible to other packages.
            .library(
                    name: "V2EXClient",
                    targets: ["V2EXClient"]),
        ],
        dependencies: [
            // Dependencies declare other packages that this package depends on.
            // .package(url: /* package url */, from: "1.0.0"),
            .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.4.3"),
            .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.1"),
            .package(url: "https://github.com/ZhgChgLi/ZMarkupParser.git", from: "1.3.5"),
        ],
        targets: [
            // Targets are the basic building blocks of a package. A target can define a module or a test suite.
            // Targets can depend on other targets in this package, and on products in packages this package depends on.
            .target(
                    name: "V2EXClient",
                    dependencies: ["SwiftSoup", "SwiftyJSON","ZMarkupParser"],
                    resources: [
                        .copy("V2EXClient.bundle")
                    ]),
            .testTarget(
                    name: "V2EXClientTests",
                    dependencies: ["V2EXClient"]),
        ]
)
