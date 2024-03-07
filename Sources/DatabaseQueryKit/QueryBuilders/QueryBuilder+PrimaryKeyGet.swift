//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 07/03/2024.
//

import FeatherRelationalDatabase
import SQLKit

public protocol QueryBuilderPrimaryKeyGet: QueryBuilderPrimaryKey {

    func get(_ value: Encodable) async throws -> Row?
}

extension QueryBuilderPrimaryKeyGet {

    public func get(_ value: Encodable) async throws -> Row? {
        try await run { db in
            try await db
                .select()
                .from(Self.tableName)
                .column("*")
                .where(Self.primaryKey.sqlValue, .equal, SQLBind(value))
                .limit(1)
                .offset(0)
                .first(decoding: Row.self)
        }
    }
}
