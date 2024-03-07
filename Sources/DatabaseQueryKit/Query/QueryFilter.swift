//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 07/03/2024.
//

import SQLKit

public struct QueryFilter<F: QueryFieldKey>: QueryFilterInterface {
    public let field: F
    public let method: SQLBinaryOperator
    public let value: Encodable

    public init(
        field: F,
        method: SQLBinaryOperator,
        value: Encodable
    ) {
        self.field = field
        self.method = method
        self.value = value
    }
}
