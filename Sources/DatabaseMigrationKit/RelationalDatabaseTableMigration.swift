//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/01/2024.
//

import FeatherComponent
import FeatherRelationalDatabase
import MigrationKit
import SQLKit

public protocol RelationalDatabaseTableMigration: RelationalDatabaseMigration {
    var tableName: String { get }
    func statements(_ builder: SQLCreateTableBuilder) -> SQLCreateTableBuilder
}

extension RelationalDatabaseTableMigration {

    public func perform(_ db: SQLDatabase) async throws {
        let builder = db.create(table: tableName).ifNotExists()
        try await statements(builder).run()
    }

    public func revert(_ db: SQLDatabase) async throws {
        try await db.drop(table: tableName).run()
    }
}
