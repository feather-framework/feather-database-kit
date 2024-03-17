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

    func count(
        filter: QueryFieldFilter<Row.FieldKeys>?
    ) async throws -> UInt
}

extension QueryBuilderCount {

    public func count(
        filter: QueryFieldFilter<Row.FieldKeys>? = nil
    ) async throws -> UInt {
        try await run { db in
            try await db
                .select()
                .from(Self.tableName)
                .column(SQLFunction("COUNT"), as: "count")
                .applyFilter(filter)
                .first(decoding: RowCount.self)?
                .count ?? 0
        }
    }
}
