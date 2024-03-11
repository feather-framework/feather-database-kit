//
//  File.swift
//
//
//  Created by Tibor Bodecs on 11/03/2024.
//

import SQLKit

public struct QueryList<F: QueryFieldKey>: QueryListInterface {
    //public let column: QueryColumn<F>
    public let page: QueryPage
    public let orders: [QueryOrder<F>]
    public let filterGroup: QueryFilterGroup<F>?

    public init(
        page: QueryPage,
        orders: [QueryOrder<F>] = [],
        filterGroup: QueryFilterGroup<F>? = nil
    ) {
        self.page = page
        self.orders = orders
        self.filterGroup = filterGroup
    }

    public struct Result<T: Codable> {
        public let items: [T]
        public let total: UInt

        public init(items: [T], total: UInt) {
            self.items = items
            self.total = total
        }
    }
}
