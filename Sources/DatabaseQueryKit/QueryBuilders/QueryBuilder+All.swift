//
//  File.swift
//
//
//  Created by Tibor Bodecs on 07/03/2024.
//

import FeatherRelationalDatabase
import SQLKit

public protocol QueryBuilderAll: QueryBuilderSchema {

    func all(
        orders: [QueryOrder<Row.FieldKeys>],
        filter: QueryFieldFilter<Row.FieldKeys>?
    ) async throws -> [Row]
}

extension QueryBuilderAll {

    public func all(
        orders: [QueryOrder<Row.FieldKeys>] = [],
        filter: QueryFieldFilter<Row.FieldKeys>? = nil
    ) async throws -> [Row] {
        try await run { db in
            try await db
                .select()
                .from(Self.tableName)
                .column("*")
                .applyFilter(filter)
                .applyOrders(orders)
                .all(decoding: Row.self)
        }
    }
}
