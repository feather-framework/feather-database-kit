//
//  File.swift
//
//
//  Created by Tibor Bodecs on 07/03/2024.
//

import FeatherRelationalDatabase
import SQLKit

public protocol QueryBuilderFirst: QueryBuilderSchema {

    func first(
        filter: QueryFieldFilter<Row.FieldKeys>,
        order: QueryOrder<Row.FieldKeys>?
    ) async throws -> Row?
}

extension QueryBuilderFirst {

    public func first(
        filter: QueryFieldFilter<Row.FieldKeys>,
        order: QueryOrder<Row.FieldKeys>? = nil
    ) async throws -> Row? {
        try await run { db in
            try await db
                .select()
                .from(Self.tableName)
                .column("*")
                .applyFilter(filter)
                .applyOrder(order)
                .limit(1)
                .offset(0)
                .first(decoding: Row.self)
        }
    }
}
