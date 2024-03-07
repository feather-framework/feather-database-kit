//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/12/2023.
//

import FeatherRelationalDatabase
import SQLKit

public protocol QueryBuilderSchema {

    static var tableName: String { get }

    associatedtype Row: QueryModel

    var db: Database { get }

    func run<T>(
        _ block: ((SQLDatabase) async throws -> T)
    ) async throws -> T
}

extension QueryBuilderSchema {

    public func run<T>(
        _ block: ((SQLDatabase) async throws -> T)
    ) async throws -> T {
        try await block(db.sqlDatabase)
    }
}
