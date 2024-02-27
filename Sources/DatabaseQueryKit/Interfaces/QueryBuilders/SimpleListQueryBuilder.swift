//
//  File.swift
//
//
//  Created by Tibor Bodecs on 10/02/2024.
//

import FeatherRelationalDatabase
import SQLKit

public protocol SimpleListQueryBuilder: QueryBuilder {

    func simpleList() async throws -> [Row]
}

public struct SimpleListQuery {

    let idKey: String  //TODO: use identifier qb
    let searchBlock: ((SQLSelectBuilder) -> SQLSelectBuilder)?
    let sort: String?
    let order: SQLDirection = .ascending
    let limit: Int
    let offset: Int
}

extension SimpleListQueryBuilder {

    public func simpleList(
        _ query: SimpleListQuery
    ) async throws -> (Int, [Row]) {

        var listQuery =
            db
            .select()
            .column("*")
            .from(Self.tableName)

        if let block = query.searchBlock {
            listQuery = block(listQuery)
        }

        if let sort = query.sort {
            listQuery = listQuery.orderBy(sort, query.order)
        }

        listQuery =
            listQuery
            .limit(query.limit)
            .offset(query.offset)

        var countQuery =
            db
            .select()
            .from(Self.tableName)
            .column(
                SQLFunction("COUNT", args: SQLDistinct(query.idKey)),
                as: "count"
            )

        if let block = query.searchBlock {
            countQuery = block(countQuery)
        }

        let elements = try await listQuery.all(
            decoding: Row.self
        )
        let count =
            try await countQuery.first(
                decoding: QueryRowCount.self
            )?
            .count ?? 0

        return (count, elements)
    }
}
