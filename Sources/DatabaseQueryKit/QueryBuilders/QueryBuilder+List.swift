//
//  File.swift
//
//
//  Created by Tibor Bodecs on 07/03/2024.
//

import SQLKit

public protocol QueryBuilderList: QueryBuilderSchema {

    func list(
        _ query: QueryList<Row.FieldKeys>
    ) async throws -> QueryList<Row.FieldKeys>.Result<Row>
}

extension QueryBuilderList {

    public func list(
        _ query: QueryList<Row.FieldKeys>
    ) async throws -> QueryList<Row.FieldKeys>.Result<Row> {
        try await run { db in

            let total =
                try await db
                .select()
                .from(Self.tableName)
                .column(SQLFunction("COUNT"), as: "count")
                .applyFilterGroup(query.filterGroup)
                .applyOrders(query.orders)
                .first(decoding: RowCount.self)?
                .count ?? 0

            let items =
                try await db
                .select()
                .from(Self.tableName)
                .column("*")
                .applyFilterGroup(query.filterGroup)
                .applyOrders(query.orders)
                .applyPage(query.page)
                .all(decoding: Row.self)

            return .init(items: items, total: total)
        }
    }
}
