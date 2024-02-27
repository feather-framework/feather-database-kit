import SQLKit

extension SQLCreateTableBuilder {

    @inlinable
    @discardableResult
    public func primaryId(_ column: String = "id") -> Self {
        self.column(column, type: .text, .primaryKey(autoIncrement: false))
    }

    @inlinable
    @discardableResult
    public func date(_ column: String, isMandatory: Bool = true) -> Self {
        if isMandatory {
            self.column(column, type: .real, .notNull)
        }
        else {
            self.column(column, type: .real)
        }
    }

    @inlinable
    @discardableResult
    public func uuid(_ column: String, isMandatory: Bool = true) -> Self {
        if isMandatory {
            self.column(column, type: .text, .notNull)
        }
        else {
            self.column(column, type: .text)
        }
    }

    @inlinable
    @discardableResult
    public func text(_ column: String, isMandatory: Bool = true) -> Self {
        if isMandatory {
            self.column(column, type: .text, .notNull)
        }
        else {
            self.column(column, type: .text)
        }
    }

    @inlinable
    @discardableResult
    public func int(_ column: String, isMandatory: Bool = true) -> Self {
        if isMandatory {
            self.column(column, type: .int, .notNull)
        }
        else {
            self.column(column, type: .int)
        }
    }

    @inlinable
    @discardableResult
    public func double(_ column: String, isMandatory: Bool = true) -> Self {
        if isMandatory {
            self.column(column, type: .real, .notNull)
        }
        else {
            self.column(column, type: .real)
        }
    }
}
