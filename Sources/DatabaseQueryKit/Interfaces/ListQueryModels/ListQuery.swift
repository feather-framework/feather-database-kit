//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/12/2023.
//

public struct ListQuery: Codable, Sendable {

    public struct RDBResult<T: Decodable> {
        public let data: [T]
        public let count: Int

        public init(data: [T], count: Int) {
            self.data = data
            self.count = count
        }
    }

    public let page: QueryPage
    public let filter: QueryFilter
    public let sort: [QuerySort]

    public init(
        page: QueryPage,
        filter: QueryFilter,
        sort: [QuerySort]
    ) {
        self.page = page
        self.filter = filter
        self.sort = sort
    }
}
