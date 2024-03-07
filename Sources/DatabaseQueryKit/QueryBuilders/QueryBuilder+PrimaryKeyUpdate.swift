//
//  File.swift
//
//
//  Created by Tibor Bodecs on 14/02/2024.
//

import FeatherRelationalDatabase
import SQLKit

public protocol QueryBuilderPrimaryKeyUpdate: QueryBuilderPrimaryKey {

    func update(_ value: Encodable, _ row: Row) async throws
}

extension QueryBuilderPrimaryKeyUpdate {

    public func update(_ value: Encodable, _ row: Row) async throws {
        try await run { db in
            try await db
                .update(Self.tableName)
                .set(model: row)
                .where(Self.primaryKey.sqlValue, .equal, SQLBind(value))
                .run()
        }
    }
}
