//
//  File.swift
//
//
//  Created by Tibor Bodecs on 11/03/2024.
//

import SQLKit

public struct QueryFilterGroup<F: QueryFieldKey>: QueryFilterGroupInterface {

    public let relation: QueryFilterRelation
    public let filters: [any QueryFilterInterface]

    public init(
        relation: QueryFilterRelation = .and,
        filters: [QueryFilter<F>]
    ) {
        self.relation = relation
        self.filters = filters
    }
}
