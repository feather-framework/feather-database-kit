//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/12/2023.
//

public protocol DatabaseQueryCodingKey:
    CodingKey,
    RawRepresentable
where
    RawValue == String
{

}
