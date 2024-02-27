//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/12/2023.
//

public struct QuerySort: Codable, Sendable {
    public let by: String
    public let order: QueryOrder

    public enum QueryOrder: String, Codable, Sendable {
        /// Ascending order
        case asc
        /// Descending order
        case desc
    }

    public init(by: String, order: QueryOrder) {
        self.by = by
        self.order = order
    }
}
