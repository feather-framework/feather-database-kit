//
//  File.swift
//
//
//  Created by Tibor Bodecs on 11/03/2024.
//

import SQLKit

public enum QueryFilterRelation {
    case and
    case or
}

protocol QueryFilterGroupInterface {

    var relation: QueryFilterRelation { get }
    var filters: [any QueryFilterInterface] { get }
}

//// SELECT * FROM galaxies WHERE name != NULL AND (name == ? OR name == ?)
//_ = try await self.db.select()
//    .column("*")
//    .from("galaxies")
//    .where("name", .notEqual, SQLLiteral.null)
//    .where { $0
//        .orWhere("name", .equal, SQLBind("Milky Way"))
//        .orWhere("name", .equal, SQLBind("Andromeda"))
//    }
//    .all()

extension SQLSelectBuilder {

    func applyFilterGroup<T: QueryFilterGroupInterface>(
        _ group: T?
    ) -> Self {
        guard let group else {
            return self
        }
        var res = self
        for filter in group.filters {
            switch group.relation {
            case .and:
                res = res.where(
                    filter.field.sqlValue,
                    filter.operator,
                    filter.value
                )
            case .or:
                res = res.orWhere(
                    filter.field.sqlValue,
                    filter.operator,
                    filter.value
                )
            }
        }
        return res
    }
}
