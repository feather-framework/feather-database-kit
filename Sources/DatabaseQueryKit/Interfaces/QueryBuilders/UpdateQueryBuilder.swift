//
//  File.swift
//
//
//  Created by Tibor Bodecs on 14/02/2024.
//

import FeatherRelationalDatabase
import SQLKit

public protocol UpdateQueryBuilder: IdentifiedQueryBuilder {

    func update(_ key: String, _ row: Row) async throws
}

extension UpdateQueryBuilder {

    public func update(_ key: String, _ row: Row) async throws {
        try await db
            .update(Self.tableName)
            .set(model: row)
            .where(Self.idField.rawValue, .equal, SQLBind(key))
            .run()
    }
}
