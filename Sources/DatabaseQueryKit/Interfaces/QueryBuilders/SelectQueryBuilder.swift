//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/01/2024.
//

import FeatherRelationalDatabase
import SQLKit

public protocol SelectQueryBuilder: QueryBuilder {

    func select() async throws -> [Row]
}

extension SelectQueryBuilder {

    public func select() async throws -> [Row] {
        try await db
            .select()
            .column("*")
            .from(Self.tableName)
            .all(decoding: Row.self)
    }
}
