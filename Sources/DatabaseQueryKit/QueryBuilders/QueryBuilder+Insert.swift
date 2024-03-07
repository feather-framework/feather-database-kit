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

public protocol QueryBuilderInsert: QueryBuilderSchema {

    func insert(_ row: Row) async throws
    func insert(_ rows: [Row], chunkSize: Int) async throws
}

extension QueryBuilderInsert {

    public func insert(_ row: Row) async throws {
        try await insert([row])
    }

    public func insert(_ rows: [Row], chunkSize: Int = 100) async throws {
        try await run { db in
            for items in rows.chunked(into: chunkSize) {
                try await db
                    .insert(into: Self.tableName)
                    .models(items, nilEncodingStrategy: .asNil)
                    .run()
            }
        }
    }
}
