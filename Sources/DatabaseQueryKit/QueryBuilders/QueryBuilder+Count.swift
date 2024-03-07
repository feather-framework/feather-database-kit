//
//  File.swift
//
//
//  Created by Tibor Bodecs on 07/03/2024.
//

import FeatherRelationalDatabase
import SQLKit

struct RowCount: Decodable {
    let count: UInt
}

public protocol QueryBuilderCount: QueryBuilderSchema {

    func count() async throws -> UInt

    func count(
        _ fieldKey: Row.FieldKeys,
        _ op: SQLBinaryOperator,
        _ value: any Encodable
    ) async throws -> UInt
}

extension QueryBuilderCount {

    public func count() async throws -> UInt {
        try await run { db in
            try await db
                .select()
                .from(Self.tableName)
                .column(SQLFunction("COUNT"), as: "count")
                .first(decoding: RowCount.self)?
                .count ?? 0
        }
    }

    public func count(
        _ fieldKey: Row.FieldKeys,
        _ op: SQLBinaryOperator,
        _ value: any Encodable
    ) async throws -> UInt {
        try await run { db in
            try await db
                .select()
                .from(Self.tableName)
                .column(
                    SQLFunction(
                        "COUNT",
                        args: SQLDistinct(
                            fieldKey.sqlValue
                        )
                    ),
                    as: "count"
                )
                .where(fieldKey.sqlValue, op, SQLBind(value))
                .first(decoding: RowCount.self)?
                .count ?? 0
        }
    }
}
