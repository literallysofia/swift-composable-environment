// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "swift-composable-environment",
  platforms: [
    .iOS(.v11),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(
      name: "ComposableEnvironment",
      targets: ["ComposableEnvironment"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/trading-point/reactiveswift-composable-architecture.git", from: "0.18.0"),
  ],
  targets: [
    .target(
      name: "ComposableEnvironment",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "reactiveswift-composable-architecture"),
      ]
    ),
    .testTarget(
      name: "ComposableEnvironmentTests",
      dependencies: ["ComposableEnvironment"]
    ),
  ]
)
