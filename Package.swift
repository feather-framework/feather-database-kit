// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "database-kit",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "DatabaseMigrationKit", targets: ["DatabaseMigrationKit"]),
        .library(name: "DatabaseQueryKit", targets: ["DatabaseQueryKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log", from: "1.0.0"),
        .package(url: "https://github.com/feather-framework/feather-migration-kit", .upToNextMinor(from: "0.1.0")),
        .package(url: "https://github.com/feather-framework/feather-component", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/feather-framework/feather-relational-database", .upToNextMinor(from: "0.2.0")),
    ],
    targets: [
        .target(
            name: "DatabaseQueryKit",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "FeatherComponent", package: "feather-component"),
                .product(name: "FeatherRelationalDatabase", package: "feather-relational-database"),
            ]
        ),
        .target(
            name: "DatabaseMigrationKit",
            dependencies: [
                .product(name: "MigrationKit", package: "feather-migration-kit"),
                .product(name: "FeatherRelationalDatabase", package: "feather-relational-database"),
            ]
        ),
    ]
)
