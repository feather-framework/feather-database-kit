//
//  File.swift
//
//
//  Created by Tibor Bodecs on 11/03/2024.
//

import Foundation

public protocol StandardQueryBuilder:
    QueryBuilderSchema,
    QueryBuilderAll,
    QueryBuilderCount,
    QueryBuilderDelete,
    QueryBuilderFirst,
    QueryBuilderInsert,
    QueryBuilderList
{

}

public protocol StandardQueryBuilderPrimaryKey:
    StandardQueryBuilder,
    QueryBuilderPrimaryKey,
    QueryBuilderPrimaryKeyDelete,
    QueryBuilderPrimaryKeyGet,
    QueryBuilderPrimaryKeyUpdate
{

}
