//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/12/2023.
//

import FeatherRelationalDatabase
import SQLKit

public protocol ListQueryBuilder: IdentifiedQueryBuilder {

    func all(
        query: ListQuery
    ) async throws -> ListQuery.RDBResult<Row>

    func all<V: Encodable>(
        where: QueryWhere<V>?,
        query: ListQuery
    ) async throws -> ListQuery.RDBResult<Row>

    func all(
        limit: Int,
        offset: Int
    ) async throws -> [Row]

    func allBy<V: Encodable>(
        key: FieldKeys,
        value: V,
        limit: Int,
        offset: Int
    ) async throws -> [Row]

    func firstBy<V: Encodable>(
        key: FieldKeys,
        value: V
    ) async throws -> Row?

    func firstById(
        value: String
    ) async throws -> Row?

    func countBy<V: Encodable>(
        key: FieldKeys,
        value: V
    ) async throws -> Int

    func countAll() async throws -> Int
}

extension ListQueryBuilder {

    public func selectBuilder() async throws -> SQLSelectBuilder {
        db
            .select()
            .column("*")
            .from(Self.tableName)
    }

    public func all(
        query: ListQuery
    ) async throws -> ListQuery.RDBResult<Row> {
        var listQuery = try await selectBuilder()

        for sort in query.sort {
            listQuery = listQuery.orderBy(
                sort.by,
                sort.order == .asc ? .ascending : .descending
            )
        }

        listQuery = listQuery.where { group in
            var queryGroup = group
            switch query.filter.relation {
            case .and:
                for q in query.filter.conditions {
                    queryGroup = queryGroup.where(
                        q.key,
                        .equal,
                        SQLBind(q.value)
                    )
                }
            case .or:
                for q in query.filter.conditions {
                    queryGroup = queryGroup.orWhere(
                        q.key,
                        .like,
                        SQLBind(q.value)
                    )
                }
            }
            return queryGroup
        }

        listQuery =
            listQuery
            .limit(query.page.size)
            .offset(query.page.index * query.page.size)

        var countQuery = try await selectBuilder()
            .column(
                SQLFunction("COUNT", args: SQLDistinct(Self.idField.rawValue)),
                as: "count"
            )

        countQuery = countQuery.where { group in
            var queryGroup = group
            switch query.filter.relation {
            case .and:
                for q in query.filter.conditions {
                    queryGroup = queryGroup.where(
                        q.key,
                        .equal,
                        SQLBind(q.value)
                    )
                }
            case .or:
                for q in query.filter.conditions {
                    queryGroup = queryGroup.orWhere(
                        q.key,
                        .like,
                        SQLBind(q.value)
                    )
                }
            }
            return queryGroup
        }

        let elements = try await listQuery.all(decoding: Row.self)
        let count =
            try await countQuery.first(decoding: QueryRowCount.self)?.count ?? 0

        return .init(
            data: elements,
            count: count
        )
    }

    public func all<V: Encodable>(
        where filter: QueryWhere<V>?,
        query: ListQuery
    ) async throws -> ListQuery.RDBResult<Row> {
        var listQuery = try await selectBuilder()

        if let filter {
            listQuery =
                listQuery
                .where(filter.key, .equal, SQLBind(filter.value))
        }

        for sort in query.sort {
            listQuery = listQuery.orderBy(
                sort.by,
                sort.order == .asc ? .ascending : .descending
            )
        }

        listQuery = listQuery.where { group in
            var queryGroup = group
            switch query.filter.relation {
            case .and:
                for q in query.filter.conditions {
                    queryGroup = queryGroup.where(
                        q.key,
                        .equal,
                        SQLBind(q.value)
                    )
                }
            case .or:
                for q in query.filter.conditions {
                    queryGroup = queryGroup.orWhere(
                        q.key,
                        .like,
                        SQLBind(q.value)
                    )
                }
            }
            return queryGroup
        }

        listQuery =
            listQuery
            .limit(query.page.size)
            .offset(query.page.index * query.page.size)

        var countQuery = try await selectBuilder()
            .column(
                SQLFunction("COUNT", args: SQLDistinct(Self.idField.rawValue)),
                as: "count"
            )

        countQuery = countQuery.where { group in
            var queryGroup = group
            switch query.filter.relation {
            case .and:
                for q in query.filter.conditions {
                    queryGroup = queryGroup.where(
                        q.key,
                        .equal,
                        SQLBind(q.value)
                    )
                }
            case .or:
                for q in query.filter.conditions {
                    queryGroup = queryGroup.orWhere(
                        q.key,
                        .like,
                        SQLBind(q.value)
                    )
                }
            }
            return queryGroup
        }

        let elements = try await listQuery.all(decoding: Row.self)
        let count =
            try await countQuery.first(decoding: QueryRowCount.self)?.count ?? 0

        return .init(
            data: elements,
            count: count
        )
    }

    public func all(
        limit: Int,
        offset: Int
    ) async throws -> [Row] {
        try await selectBuilder()
            .limit(limit)
            .offset(offset)
            .all(decoding: Row.self)
    }

    public func allBy<V: Encodable>(
        key: FieldKeys,
        value: V,
        limit: Int,
        offset: Int
    ) async throws -> [Row] {
        try await selectBuilder()
            .where(key.rawValue, .equal, SQLBind(value))
            .limit(limit)
            .offset(offset)
            .all(decoding: Row.self)
    }

    public func query<V: Encodable>(
        key: FieldKeys,
        value: V,
        limit: Int,
        offset: Int
    ) async throws -> [Row] {
        try await selectBuilder()
            .where(key.rawValue, .equal, SQLBind(value))
            .limit(limit)
            .offset(offset)
            .all(decoding: Row.self)
    }

    public func firstBy<V: Encodable>(
        key: FieldKeys,
        value: V
    ) async throws -> Row? {
        try await selectBuilder()
            .where(key.rawValue, .equal, SQLBind(value))
            .limit(1)
            .offset(0)
            .first(decoding: Row.self)
    }

    public func firstById(
        value: String
    ) async throws -> Row? {
        try await firstBy(
            key: .init(rawValue: Self.idField.rawValue)!,
            value: value
        )
    }

    public func countBy<V: Encodable>(
        key: FieldKeys,
        value: V
    ) async throws -> Int {
        let res =
            try await selectBuilder()
            .column(
                SQLFunction("COUNT", args: SQLDistinct(Self.idField.rawValue)),
                as: "count"
            )
            .where(key.rawValue, .equal, SQLBind(value))
            .first(decoding: QueryRowCount.self)
        return res?.count ?? 0
    }

    public func countAll() async throws -> Int {
        let res =
            try await selectBuilder()
            .column(
                SQLFunction("COUNT", args: SQLDistinct(Self.idField.rawValue)),
                as: "count"
            )
            .first(decoding: QueryRowCount.self)
        return res?.count ?? 0
    }
}
