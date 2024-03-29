//
//  File.swift
//
//
//  Created by Tibor Bodecs on 14/02/2024.
//

//import FeatherRelationalDatabase
//import SQLKit
//
//public protocol JointListQueryBuilder: ListQueryBuilder {
//
//    associatedtype ConnectorID: Encodable
//    associatedtype ConnectorBuilder: ListQueryBuilder
//    associatedtype ValueBuilder: ListQueryBuilder
//    associatedtype Row = ValueBuilder.Row
//    associatedtype FieldKeys = ValueBuilder.FieldKeys
//
//    static var referenceField: ConnectorBuilder.FieldKeys { get }
//    static var connectorField: ConnectorBuilder.FieldKeys { get }
//    static var valueField: FieldKeys { get }
//
//    var connectorId: ConnectorID { get }
//}
//
//extension JointListQueryBuilder {
//
//    public static var tableName: String { ValueBuilder.tableName }
//
//    public func selectBuilder() async throws -> SQLSelectBuilder {
//        db
//            .select()
//            .column(table: Self.tableName, column: "*")
//            .from(ConnectorBuilder.tableName)
//            .join(
//                Self.tableName,
//                method: SQLJoinMethod.inner,
//                on: SQLColumn(Self.valueField.rawValue),
//                .equal,
//                SQLColumn(Self.connectorField.rawValue)
//            )
//            .where(Self.referenceField.rawValue, .equal, SQLBind(connectorId))
//    }
//}
