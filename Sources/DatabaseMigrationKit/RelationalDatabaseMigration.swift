//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/01/2024.
//

import FeatherComponent
import FeatherRelationalDatabase
import MigrationKit
import SQLKit

public protocol RelationalDatabaseMigration: Migration {
    func perform(_ db: SQLDatabase) async throws
    func revert(_ db: SQLDatabase) async throws
}

extension RelationalDatabaseMigration {

    public func perform(_ components: ComponentRegistry) async throws {
        try await perform(
            try await components.relationalDatabase().connection()
        )
    }

    public func revert(_ components: ComponentRegistry) async throws {
        try await revert(try await components.relationalDatabase().connection())
    }
}
