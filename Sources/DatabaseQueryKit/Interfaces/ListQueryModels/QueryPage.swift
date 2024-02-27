//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/12/2023.
//

public struct QueryPage: Codable, Sendable {

    /// Default pagination values.
    public enum Default {

        /// Default page size value.
        ///
        /// Default value: 50
        public static var size: Int = 50

        /// Default page index value.
        ///
        /// Default value: 0
        public static var index: Int = 0
    }

    /// Page size value.
    ///
    /// Defaults ot the `Page.Default.size` value if not present
    public let size: Int

    /// Page Index value.
    ///
    /// Defaults ot the `Page.Default.index` value if not present
    public let index: Int

    public init(
        size: Int? = nil,
        index: Int? = nil
    ) {
        self.size = size ?? Default.size
        self.index = index ?? Default.index
    }
}
