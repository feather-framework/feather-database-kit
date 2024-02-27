//
//  File.swift
//
//
//  Created by Tibor Bodecs on 06/01/2024.
//

import FeatherRelationalDatabase
import SQLKit

extension Array {

    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size)
            .map {
                Array(self[$0..<Swift.min($0 + size, count)])
            }
    }
}

public protocol InsertQueryBuilder: QueryBuilder {

    func insert(_ row: Row) async throws
    func insert(_ rows: [Row], chunkSize: Int) async throws
}

extension InsertQueryBuilder {

    public func insert(_ row: Row) async throws {
        try await insert([row])
    }

    public func insert(_ rows: [Row], chunkSize: Int = 100) async throws {
        for items in rows.chunked(into: chunkSize) {
            try await db
                .insert(into: Self.tableName)
                // TODO: double check this
                //                .models(items, prefix: nil, keyEncodingStrategy: .convertToSnakeCase, nilEncodingStrategy: .asNil)
                .models(items, nilEncodingStrategy: .asNil)
                .run()
        }
    }
}
