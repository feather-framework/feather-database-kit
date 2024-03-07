//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 07/03/2024.
//

@preconcurrency import SQLKit
import FeatherRelationalDatabase

public struct Database: Sendable {
    
    let sqlDatabase: SQLDatabase

    public init(_ sqlDatabase: SQLDatabase) {
        self.sqlDatabase = sqlDatabase
    }
}

extension RelationalDatabaseComponent {

    public func database() async throws -> Database {
        let sqlDatabase = try await connection()
        return .init(sqlDatabase)
    }
}

