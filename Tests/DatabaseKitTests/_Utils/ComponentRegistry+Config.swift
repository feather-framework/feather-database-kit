//
//  File.swift
//
//
//  Created by Tibor Bodecs on 16/02/2024.
//

import FeatherComponent
import FeatherRelationalDatabase
import FeatherRelationalDatabaseDriverSQLite
import Logging
import NIO

extension ComponentRegistry {

    public func configure(
        _ threadPool: NIOThreadPool,
        _ eventLoopGroup: EventLoopGroup
    ) async throws {

        try await addRelationalDatabase(
            SQLiteRelationalDatabaseComponentContext(
                eventLoopGroup: eventLoopGroup,
                connectionSource: .init(
                    configuration: .init(
                        storage: .memory,
                        enableForeignKeys: true
                    ),
                    threadPool: threadPool
                )
            )
        )
    }
}
