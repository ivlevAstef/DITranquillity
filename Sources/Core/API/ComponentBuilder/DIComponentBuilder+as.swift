//
//  DIComponentBuilder+as.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//


// MARK: - Type Registration (`as` functions)
extension DIComponentBuilder {
    /// Registers an additional type by which the component can be resolved.
    ///
    /// Use this method to expose your concrete implementation through a protocol or parent class.
    /// A single component can be registered under multiple types.
    ///
    /// - Parameter type: The type by which the component will be available.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// container.register(MySQLDatabase.init)
    ///     .as(Database.self)           // Can resolve as Database
    ///     .as(Queryable.self)          // Can also resolve as Queryable
    /// ```
    @discardableResult
    public func `as`<Parent>(_ type: Parent.Type) -> Self {
        componentContainer.insert(TypeKey(by: unwrapType(type)), component, otherOperation: {
            self.component.alternativeTypes.append(.type(type))
        })
        return self
    }

    /// Registers a type with a tag by which the component can be resolved.
    ///
    /// Use tags to differentiate between multiple implementations of the same type.
    /// Tags are type-safe markers (typically empty enums or protocols or classes).
    ///
    /// - Parameters:
    ///   - type: The type by which the component will be available when paired with the tag.
    ///   - tag: The tag type that identifies this specific registration.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Define tags
    /// enum ProductionDB {}
    /// enum TestDB {}
    ///
    /// // Register with different tags
    /// container.register(MySQLDatabase.init)
    ///     .as(Database.self, tag: ProductionDB.self)
    ///
    /// container.register(SQLiteDatabase.init)
    ///     .as(Database.self, tag: TestDB.self)
    ///
    /// // Resolve by tag
    /// let db: Database = container.resolve(tag: ProductionDB.self) // It's MySQLDatabase
    /// ```
    @discardableResult
    public func `as`<Parent, Tag>(_ type: Parent.Type, tag: Tag.Type) -> Self {
        componentContainer.insert(TypeKey(by: unwrapType(type), tag: tag), component, otherOperation: {
            self.component.alternativeTypes.append(.tag(tag, type: type))
        })
        return self
    }

    /// Registers a type with a string name by which the component can be resolved.
    ///
    /// Use names as an alternative to tags when you need string-based identification.
    ///
    /// - Parameters:
    ///   - type: The type by which the component will be available when paired with the name.
    ///   - name: The string name that identifies this specific registration.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// - Important: Named components can only be resolved using:
    ///   - `container.resolve(name:)` method
    ///   - `injection(name:)` method
    ///
    ///   You cannot use names inside initializer closures. Use tags instead if needed.
    ///
    /// ## Example
    ///
    /// ```swift
    /// container.register(MySQLDatabase.init)
    ///     .as(Database.self, name: "primary")
    ///
    /// container.register(SQLiteDatabase.init)
    ///     .as(Database.self, name: "cache")
    ///
    /// // Resolve by name
    /// let primaryDB: Database = container.resolve(sync:, name: "primary") // It's MySQLDatabase
    /// ```
    @discardableResult
    public func `as`<Parent>(_ type: Parent.Type, name: String) -> Self {
        componentContainer.insert(TypeKey(by: unwrapType(type), name: name), component, otherOperation: {
            self.component.alternativeTypes.append(.name(name, type: type))
        })
        return self
    }

    /// Registers a type with compile-time type checking.
    ///
    /// This variant provides compile-time verification that the implementation
    /// actually conforms to the specified type. Use `{$0}` as the validator.
    ///
    /// - Parameters:
    ///   - type: The type by which the component will be available.
    ///   - validator: Type validation closure. Always use `{$0}`.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// container.register(YourClass.init)
    ///     .as(check: YourProtocol.self) { $0 }  // Compile error if YourClass doesn't implement YourProtocol
    /// ```
    @discardableResult
    public func `as`<Parent>(check type: Parent.Type, _ validator: (Impl) -> Parent) -> Self {
        return self.as(type)
    }

    /// Registers a type with a tag and compile-time type checking.
    ///
    /// Combines tagged registration with compile-time verification that the implementation
    /// conforms to the specified type.
    ///
    /// - Parameters:
    ///   - type: The type by which the component will be available.
    ///   - tag: The tag type that identifies this specific registration.
    ///   - validator: Type validation closure. Always use `{$0}`.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// container.register(YourClass.init)
    ///     .as(check: YourProtocol.self, tag: YourTag.self) { $0 }
    /// ```
    @discardableResult
    public func `as`<Parent, Tag>(check type: Parent.Type, tag: Tag.Type, _ validator: (Impl) -> Parent) -> Self {
        return self.as(type, tag: tag)
    }

    /// Registers a type with a name and compile-time type checking.
    ///
    /// Combines named registration with compile-time verification that the implementation
    /// conforms to the specified type.
    ///
    /// - Parameters:
    ///   - type: The type by which the component will be available.
    ///   - name: The string name that identifies this specific registration.
    ///   - validator: Type validation closure. Always use `{$0}`.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// - Important: Named components can only be resolved using `resolve(name:)` or `injection(name:)`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// container.register(YourClass.init)
    ///     .as(check: YourProtocol.self, name: "primary") { $0 }
    /// ```
    @discardableResult
    public func `as`<Parent>(check type: Parent.Type, name: String, _ validator: (Impl) -> Parent) -> Self {
        return self.as(type, name: name)
    }
}
