//
//  File.swift
//
//
//  Created by Tibor Bodecs on 07/03/2024.
//

import FeatherRelationalDatabase
import SQLKit

public protocol QueryBuilderFirst: QueryBuilderSchema {

    func first<E: Encodable>(
        _ fieldKey: Row.FieldKeys,
        _ op: SQLBinaryOperator,
        _ value: E,
        _ direction: QueryDirection
    ) async throws -> Row?

    func first<E: Encodable>(
        _ fieldKey: Row.FieldKeys,
        _ op: SQLBinaryOperator,
        _ value: [E],
        _ direction: QueryDirection
    ) async throws -> Row?
}

extension QueryBuilderFirst {

    public func first<E: Encodable>(
        _ fieldKey: Row.FieldKeys,
        _ op: SQLBinaryOperator,
        _ value: E,
        _ direction: QueryDirection = .asc
    ) async throws -> Row? {
        try await run { db in
            try await db
                .select()
                .from(Self.tableName)
                .column("*")
                .where(fieldKey.sqlValue, op, value)
                .orderBy(fieldKey.sqlValue, direction.sqlValue)
                .limit(1)
                .offset(0)
                .first(decoding: Row.self)
        }
    }

    public func first<E: Encodable>(
        _ fieldKey: Row.FieldKeys,
        _ op: SQLBinaryOperator,
        _ value: [E],
        _ direction: QueryDirection = .asc
    ) async throws -> Row? {
        try await run { db in
            try await db
                .select()
                .from(Self.tableName)
                .column("*")
                .where(fieldKey.sqlValue, op, value)
                .orderBy(fieldKey.sqlValue, direction.sqlValue)
                .limit(1)
                .offset(0)
                .first(decoding: Row.self)
        }
    }
}
