//
//  File.swift
//
//
//  Created by Tibor Bodecs on 14/02/2024.
//

import Foundation

public protocol IdentifiedQueryBuilder: QueryBuilder {

    static var idField: FieldKeys { get }
}

extension IdentifiedQueryBuilder {

    public static var idField: FieldKeys { .init(rawValue: "id")! }
}
