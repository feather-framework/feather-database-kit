//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 07/03/2024.
//

import FeatherRelationalDatabase
import DatabaseQueryKit
import DatabaseMigrationKit
import MigrationKit
import SQLKit

enum Todo {
    
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
        let id: Key<Todo>
        let title: String
        let notes: String?
    }
    
    // @DatabaseQueryBuilder("todo", Model.self)
    struct QueryBuilder: 
        QueryBuilderSchema,
        QueryBuilderAll,
        QueryBuilderCount,
        QueryBuilderDelete,
        QueryBuilderFirst,
        QueryBuilderInsert,
        QueryBuilderList,
        QueryBuilderPrimaryKey,
        QueryBuilderPrimaryKeyDelete,
        QueryBuilderPrimaryKeyGet,
        QueryBuilderPrimaryKeyUpdate
    {
        typealias Row = Model

        static let tableName = "todo"
        static let primaryKey = Model.FieldKeys.id

        let db: Database
    }

    // MARK: - migration

    struct Migration: RelationalDatabaseTableMigration {

        public let tableName: String

        public init() {
            self.tableName = "todo"
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
