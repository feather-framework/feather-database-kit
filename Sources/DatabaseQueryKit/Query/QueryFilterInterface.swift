//
//  File.swift
//
//
//  Created by Tibor Bodecs on 07/03/2024.
//

import SQLKit

public protocol QueryFilterInterface {
    associatedtype Field: QueryFieldKey

    var field: Field { get }
    var method: SQLBinaryOperator { get }
    var value: Encodable { get }
}

extension QueryFilterInterface {

    var sqlValue: SQLBind {
        SQLBind(value)
    }
}
