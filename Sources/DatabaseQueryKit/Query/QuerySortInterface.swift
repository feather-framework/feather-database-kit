//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 07/03/2024.
//

public protocol QuerySortInterface {
    associatedtype Field: QueryFieldKey

    var field: Field { get }
    var direction: QueryDirection { get }
}
