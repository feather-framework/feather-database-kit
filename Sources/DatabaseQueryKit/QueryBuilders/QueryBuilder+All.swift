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
        filter: QueryFilter<Row.FieldKeys>?
    ) async throws -> [Row]
}

extension QueryBuilderAll {

    public func all(
        filter: QueryFilter<Row.FieldKeys>? = nil
    ) async throws -> [Row] {
        try await run { db in
            try await db
                .select()
                .from(Self.tableName)
                .column("*")
                .applyFilter(filter)
                .all(decoding: Row.self)
        }
    }
}
