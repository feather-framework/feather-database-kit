//
//  File.swift
//
//
//  Created by Tibor Bodecs on 07/03/2024.
//

import FeatherRelationalDatabase
import SQLKit

protocol ListQueryInterface {
    associatedtype Field: QueryFieldKey

    var page: QueryPage { get }
    var sort: QuerySort<Field> { get }
    var search: QueryFilter<Field>? { get }
}

public struct SimpleListQuery<F: QueryFieldKey>: ListQueryInterface {
    //public let column: QueryColumn<F>
    public let page: QueryPage
    public let sort: QuerySort<F>
    public let search: QueryFilter<F>?

    public init(
        page: QueryPage,
        sort: QuerySort<F>,
        search: QueryFilter<F>? = nil
    ) {
        self.page = page
        self.sort = sort
        self.search = search
    }
}

public struct SimpleListResult<T: Codable> {
    public let items: [T]
    public let total: UInt

    public init(items: [T], total: UInt) {
        self.items = items
        self.total = total
    }
}

public protocol QueryBuilderList: QueryBuilderSchema {

    func list(
        _ query: SimpleListQuery<Row.FieldKeys>
    ) async throws -> SimpleListResult<Row>
}

extension SQLSelectBuilder {

    func applySortAndFilter<T: QueryFieldKey>(
        _ query: SimpleListQuery<T>
    ) -> SQLSelectBuilder {
        // sort
        var qb = self.orderBy(
            query.sort.field.sqlValue,
            query.sort.direction.sqlValue
        )

        // filter
        if let search = query.search {
            qb = qb.where(
                search.field.sqlValue,
                search.method,
                search.sqlValue
            )
        }
        return qb
    }
}

extension QueryBuilderList {

    public func list(
        _ query: SimpleListQuery<Row.FieldKeys>
    ) async throws -> SimpleListResult<Row> {
        try await run { db in

            let total =
                try await db
                .select()
                .from(Self.tableName)
                .column(SQLFunction("COUNT"), as: "count")
                .applySortAndFilter(query)
                .first(decoding: RowCount.self)?
                .count ?? 0

            let items =
                try await db
                .select()
                .from(Self.tableName)
                .column("*")
                .applySortAndFilter(query)
                .limit(query.page.limit.sqlValue)
                .offset(query.page.offset.sqlValue)
                .all(decoding: Row.self)

            return .init(items: items, total: total)
        }
    }
}
