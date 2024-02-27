//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/12/2023.
//

public struct QueryFilter: Codable, Sendable {

    /// The relationship between the filter query elements.
    public enum QueryRelation: String, Codable, Sendable {
        /// And relation
        case and
        /// Or relation
        case or
    }

    public struct QueryFilterCondition: Codable, Sendable {

        public enum QueryMethod: String, Codable, Sendable {
            case equals
            case like
        }

        public let method: QueryMethod
        public let key: String
        public let value: String

        public init(method: QueryMethod, key: String, value: String) {
            self.method = method
            self.key = key
            self.value = value
        }
    }

    public let relation: QueryRelation
    public let conditions: [QueryFilterCondition]  // NOTE: item vs condition?

    public init(
        relation: QueryRelation = .and,
        conditions: [QueryFilterCondition] = []
    ) {
        self.relation = relation
        self.conditions = conditions
    }
}
