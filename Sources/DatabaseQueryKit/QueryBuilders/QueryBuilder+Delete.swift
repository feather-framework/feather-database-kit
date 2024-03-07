//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 07/03/2024.
//

import FeatherRelationalDatabase
import SQLKit

public protocol QueryBuilderDelete: QueryBuilderSchema {

    func delete<E: Encodable>(
        _ fieldKey: Row.FieldKeys,
        _ op: SQLBinaryOperator,
        _ value: E
    ) async throws
    
    func delete<E: Encodable>(
        _ fieldKey: Row.FieldKeys,
        _ op: SQLBinaryOperator,
        _ value: [E]
    ) async throws
}

extension QueryBuilderDelete {

    public func delete<E: Encodable>(
        _ fieldKey: Row.FieldKeys,
        _ op: SQLBinaryOperator,
        _ value: E
    ) async throws  {
        try await run { db in
            try await db
                .delete(from: Self.tableName)
                .where(fieldKey.sqlValue, op, value)
                .run()
        }
    }
    
    public func delete<E: Encodable>(
        _ fieldKey: Row.FieldKeys,
        _ op: SQLBinaryOperator,
        _ value: [E]
    ) async throws  {
        try await run { db in
            try await db
                .delete(from: Self.tableName)
                .where(fieldKey.sqlValue, op, value)
                .run()
        }
    }
}
