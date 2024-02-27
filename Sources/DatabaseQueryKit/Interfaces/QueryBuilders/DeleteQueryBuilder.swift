//
//  File.swift
//
//
//  Created by Tibor Bodecs on 14/02/2024.
//

import FeatherRelationalDatabase
import SQLKit

public protocol DeleteQueryBuilder: IdentifiedQueryBuilder {

    func delete(_ key: String) async throws
    func delete(_ keys: [String]) async throws
}

extension DeleteQueryBuilder {

    public func delete(_ key: String) async throws {
        try await delete([key])
    }

    public func delete(_ keys: [String]) async throws {
        try await db
            .delete(from: Self.tableName)
            .where(.init(Self.idField.rawValue), .in, keys)
            .run()
    }
}
