// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "feather-database-kit",
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
        .package(url: "https://github.com/apple/swift-nio", from: "2.61.0"),
        .package(url: "https://github.com/binarybirds/swift-nanoid", from: "1.0.0"),
        .package(url: "https://github.com/feather-framework/feather-migration-kit", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/feather-framework/feather-component", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/feather-framework/feather-relational-database", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/feather-framework/feather-relational-database-driver-sqlite", .upToNextMinor(from: "0.2.0")),
    ],
    targets: [
        .target(
            name: "DatabaseQueryKit",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "FeatherComponent", package: "feather-component"),
                .product(name: "FeatherRelationalDatabase", package: "feather-relational-database"),
                .product(name: "NanoID", package: "swift-nanoid"),
            ]
        ),
        .target(
            name: "DatabaseMigrationKit",
            dependencies: [
                .product(name: "MigrationKit", package: "feather-migration-kit"),
                .product(name: "FeatherRelationalDatabase", package: "feather-relational-database"),
            ]
        ),
        .testTarget(
            name: "DatabaseKitTests",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .target(name: "DatabaseQueryKit"),
                .target(name: "DatabaseMigrationKit"),
                // drivers
                .product(name: "FeatherRelationalDatabaseDriverSQLite", package: "feather-relational-database-driver-sqlite"),
            ]
        ),
    ]
)
