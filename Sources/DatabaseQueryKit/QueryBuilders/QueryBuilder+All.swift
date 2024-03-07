//
//  File.swift
//
//
//  Created by Tibor Bodecs on 07/03/2024.
//

import FeatherRelationalDatabase
import SQLKit

public protocol QueryBuilderAll: QueryBuilderSchema {

    func all() async throws -> [Row]

    func all<E: Encodable>(
        _ fieldKey: Row.FieldKeys,
        _ op: SQLBinaryOperator,
        _ value: E
    ) async throws -> [Row]

    func all<E: Encodable>(
        _ fieldKey: Row.FieldKeys,
        _ op: SQLBinaryOperator,
        _ value: [E]
    ) async throws -> [Row]
}

extension QueryBuilderAll {

    public func all() async throws -> [Row] {
        try await run { db in
            try await db
                .select()
                .from(Self.tableName)
                .column("*")
                .all(decoding: Row.self)
        }
    }

    public func all<E: Encodable>(
        _ fieldKey: Row.FieldKeys,
        _ op: SQLBinaryOperator,
        _ value: E
    ) async throws -> [Row] {
        try await run { db in
            try await db
                .select()
                .from(Self.tableName)
                .column("*")
                .where(fieldKey.sqlValue, op, value)
                .all(decoding: Row.self)
        }
    }

    public func all<E: Encodable>(
        _ fieldKey: Row.FieldKeys,
        _ op: SQLBinaryOperator,
        _ value: [E]
    ) async throws -> [Row] {
        try await run { db in
            try await db
                .select()
                .from(Self.tableName)
                .column("*")
                .where(fieldKey.sqlValue, op, value)
                .all(decoding: Row.self)
        }
    }
}
