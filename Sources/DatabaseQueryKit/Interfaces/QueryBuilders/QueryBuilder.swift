//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/12/2023.
//

import FeatherRelationalDatabase
import SQLKit

public protocol QueryBuilder {

    var db: SQLDatabase { get }
    static var tableName: String { get }

    associatedtype Row: Codable
    associatedtype FieldKeys: DatabaseQueryCodingKey
}
