//
//  File.swift
//
//
//  Created by Tibor Bodecs on 14/02/2024.
//

import Foundation

public protocol QueryBuilderPrimaryKey: QueryBuilderSchema {

    associatedtype PrimaryField: QueryFieldKey

    static var primaryKey: PrimaryField { get }
}
