//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 07/03/2024.
//

public struct QueryPage {

    public let limit: QueryLimit
    public let offset: QueryOffset

    public init(
        size: UInt,
        index: UInt
    ) {
        self.limit = .init(size)
        self.offset = .init(size * index)
    }
}
