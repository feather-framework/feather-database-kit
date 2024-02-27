//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/12/2023.
//

public struct QueryWhere<T: Encodable> {

    public let key: String
    public let value: T

    public init(key: String, value: T) {
        self.key = key
        self.value = value
    }
}
