//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 07/03/2024.
//


public struct QueryLimit {

    public let value: UInt

    public init(_ value: UInt) {
        self.value = value
    }

    var sqlValue: Int {
        Int(value)
    }
}
