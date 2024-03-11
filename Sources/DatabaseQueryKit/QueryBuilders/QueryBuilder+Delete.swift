//
//  File.swift
//
//
//  Created by Tibor Bodecs on 07/03/2024.
//

import FeatherRelationalDatabase
import SQLKit

public protocol QueryBuilderDelete: QueryBuilderSchema {

    func delete(
        filter: QueryFilter<Row.FieldKeys>
    ) async throws
}

extension QueryBuilderDelete {

    public func delete(
        filter: QueryFilter<Row.FieldKeys>
    ) async throws {
        try await run { db in
            try await db
                .delete(from: Self.tableName)
                .applyFilter(filter)
                .run()
        }
    }
}
