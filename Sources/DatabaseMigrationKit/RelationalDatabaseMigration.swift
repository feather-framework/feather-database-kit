//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/01/2024.
//

import DatabaseQueryKit
import FeatherComponent
import FeatherRelationalDatabase
import MigrationKit
import SQLKit

public protocol RelationalDatabaseMigration: Migration {
    func perform(_ db: Database) async throws
    func revert(_ db: Database) async throws
}

extension RelationalDatabaseMigration {

    public func perform(
        _ components: ComponentRegistry
    ) async throws {
        let connection = try await components.relationalDatabase().connection()
        try await perform(
            .init(connection)
        )
    }

    public func revert(
        _ components: ComponentRegistry
    ) async throws {
        let connection = try await components.relationalDatabase().connection()
        try await revert(.init(connection))
    }
}
