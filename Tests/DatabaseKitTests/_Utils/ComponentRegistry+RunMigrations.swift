//
//  File.swift
//
//
//  Created by Tibor Bodecs on 16/02/2024.
//

import DatabaseMigrationKit
import FeatherComponent
import MigrationKit

extension ComponentRegistry {

    func runMigrationGroups(_ groups: [MigrationGroup]) async throws {

        let migrator = Migrator(
            components: self,
            storage: MigrationEntryStorageEphemeral()
        )

        try await migrator.perform(groups: groups)
    }
}
