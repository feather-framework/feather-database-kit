//
//  File.swift
//
//
//  Created by Tibor Bodecs on 07/03/2024.
//

import SQLKit

public protocol QueryBuilderPrimaryKeyDelete: QueryBuilderPrimaryKey {

    func delete<E: Encodable>(
        _ value: E
    ) async throws

    func delete<E: Encodable>(
        _ value: [E]
    ) async throws
}

extension QueryBuilderPrimaryKeyDelete {

    public func delete<E: Encodable>(
        _ value: E
    ) async throws {
        try await run { db in
            try await db
                .delete(from: Self.tableName)
                .where(Self.primaryKey.sqlValue, .equal, value)
                .run()
        }
    }

    public func delete<E: Encodable>(
        _ value: [E]
    ) async throws {
        try await run { db in
            try await db
                .delete(from: Self.tableName)
                .where(Self.primaryKey.sqlValue, .in, value)
                .run()
        }
    }
}
