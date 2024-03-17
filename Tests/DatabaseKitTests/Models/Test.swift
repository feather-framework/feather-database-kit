//
//  File.swift
//
//
//  Created by Tibor Bodecs on 07/03/2024.
//

import DatabaseMigrationKit
import DatabaseQueryKit
import FeatherRelationalDatabase
import MigrationKit
import SQLKit

enum Test {

    // @DatabaseQueryModel
    struct Model: QueryModel {

        // TODO: macro
        enum CodingKeys: String, QueryFieldKey {
            case id
            case title
            case notes
        }
        static let fieldKeys = CodingKeys.self

        // MARK: - fields
        let id: Key<Test>
        let title: String
        let notes: String?
    }

    // @DatabaseQueryBuilder("test", Model.self)
    struct QueryBuilder: StandardQueryBuilderPrimaryKey {
        typealias Row = Model

        static let tableName = "test"
        static let primaryKey = Model.FieldKeys.id

        let db: Database
    }

    // MARK: - migration

    struct Migration: RelationalDatabaseTableMigration {

        public let tableName: String

        public init() {
            self.tableName = "test"
        }

        public func statements(
            _ builder: SQLCreateTableBuilder
        ) -> SQLCreateTableBuilder {
            builder
                .primaryId()
                .text("title")
                .text("notes", isMandatory: false)
        }
    }

    struct MigrationGroup: MigrationKit.MigrationGroup {

        func migrations() -> [MigrationKit.Migration] {
            [
                Migration()
            ]
        }
    }
}
