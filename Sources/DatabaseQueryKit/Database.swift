//
//  File.swift
//
//
//  Created by Tibor Bodecs on 07/03/2024.
//

import FeatherRelationalDatabase
@preconcurrency import SQLKit

public struct Database: Sendable {

    public let sqlDatabase: SQLDatabase

    public init(_ sqlDatabase: SQLDatabase) {
        self.sqlDatabase = sqlDatabase
    }
}

extension RelationalDatabaseComponent {

    public func database() async throws -> Database {
        do {
            let sqlDatabase = try await connection()
            return .init(sqlDatabase)
        }
        catch {
            throw Database.Error.connection(error)
        }
    }
}
