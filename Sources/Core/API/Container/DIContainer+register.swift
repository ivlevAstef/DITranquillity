//
//  DIContainer+register.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.

//

// MARK: - register
extension DIContainer {
    /// Registers a new component without an initializer.
    ///
    /// Use this method when the component will be initialized through injections or when you need
    /// to register a type that will be resolved from cache (e.g., with `perContainer` lifetime).
    ///
    /// - Parameters:
    ///   - type: The type of the new component.
    ///
    /// - Returns: A component builder to configure the component (lifetime, injections, etc.).
    ///
    /// ## Example
    ///
    /// ```swift
    /// container.register(YourClass.self)
    ///     .lifetime(.custom(scope))
    ///     .injection(\.dependency)
    /// ```
    @discardableResult
    public func register<Impl>(_ type: Impl.Type, file: String = #file, line: Int = #line) -> DIComponentBuilder<Impl> {
        return DIComponentBuilder(container: self, componentInfo: DIComponentInfo(type: Impl.self, file: file, line: line))
    }

    /// Registers a new component with a synchronous initializer closure.
    ///
    /// This is the primary registration method. The closure parameters are automatically resolved
    /// from the container when the component is created.
    ///
    /// - Parameters:
    ///   - closure: Initializer method. Parameters are resolved from the container.
    ///     Must return the type being registered.
    ///
    /// - Returns: A component builder to configure the component.
    ///
    /// ## Examples
    ///
    /// ```swift
    /// // Using closure syntax
    /// container.register { YourClass(dependency: $0) }
    ///
    /// // Using init reference (shorter form)
    /// container.register(YourClass.init)
    ///
    /// // Multiple dependencies
    /// container.register { YourClass(service: $0, logger: $1, config: $2) }
    /// ```
    @discardableResult
    public func register<Impl,each P>(
        file: String = #file,
        line: Int = #line,
        _ closure: @escaping @isolated(any) (repeat each P) -> Impl
    ) -> DIComponentBuilder<Impl> {
        return register(file, line, MethodMaker.comboEachMake(fn: closure))
    }

    /// Registers a new component with an asynchronous initializer closure.
    ///
    /// Use this method when the component's initialization requires async operations.
    /// The component can only be resolved using async `resolve()` methods.
    ///
    /// - Parameters:
    ///   - closure: Async initializer method. Parameters are resolved from the container.
    ///     Must return the type being registered.
    ///
    /// - Returns: A component builder to configure the component.
    ///
    /// ## Examples
    ///
    /// ```swift
    /// // Async initialization
    /// container.register { await YourClass(dependency: $0) }
    ///
    /// // Using async init reference
    /// container.register(YourClass.init)  // if init is async
    /// ```
    @discardableResult
    public func register<Impl,each P>(
        file: String = #file,
        line: Int = #line,
        _ closure: @escaping @isolated(any) (repeat each P) async -> Impl
    ) -> DIComponentBuilder<Impl> {
        return register(file, line, MethodMaker.asyncEachMake(fn: closure))
    }


    /// Registers a component with an initializer and a modificator for the first argument.
    ///
    /// Use modificators when you need to apply special resolution behavior to arguments,
    /// such as `arg()` for runtime arguments, `many()` for arrays, or `by(tag:on:)` for tagged resolution.
    ///
    /// - Parameters:
    ///   - closure: Initializer method. Must return the type being registered.
    ///   - modificator: Transformation function for the first argument supporting `arg`, `many`, or `tag`.
    ///
    /// - Returns: A component builder to configure the component.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Using runtime argument for first parameter
    /// container.register(YourClass.init) { arg($0) }
    ///
    /// // Using tagged resolution for first parameter
    /// container.register(YourClass.init) { by(tag: ProductionDB.self, on: $0) }
    /// ```
    @discardableResult
    public func register<Impl,P0,each P,M0>(file: String = #file, line: Int = #line,
                                            _ closure: @escaping @isolated(any) (P0, repeat each P) -> Impl,
                                            modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
        return register(file, line, MethodMaker.comboEachMake(fn: closure, modificator: modificator))
    }

    /// Registers a component with an initializer and modificators for the first two arguments.
    ///
    /// Use this when you need to apply special resolution behavior to multiple arguments.
    ///
    /// - Parameters:
    ///   - closure: Initializer method. Must return the type being registered.
    ///   - modificator: Transformation function for the first and second arguments.
    ///
    /// - Returns: A component builder to configure the component.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Using runtime argument and many resolution
    /// container.register(YourClass.init) { (arg($0), many($1)) }
    ///
    /// // Using two different tags
    /// container.register(YourClass.init) {
    ///     (by(tag: Primary.self, on: $0), by(tag: Secondary.self, on: $1))
    /// }
    /// ```
    @discardableResult
    public func register<Impl,P0,P1,each P,M0,M1>(file: String = #file, line: Int = #line,
                                                  _ closure: @escaping @isolated(any) (P0, P1, repeat each P) -> Impl,
                                                  modificator: @escaping (M0, M1) -> (P0, P1)) -> DIComponentBuilder<Impl> {
        return register(file, line, MethodMaker.comboEachMake(fn: closure, modificator: modificator))
    }

    internal func register<Impl>(_ file: String, _ line: Int, _ signature: MethodSignature) -> DIComponentBuilder<Impl> {
        let builder = register(Impl.self, file: file, line: line)
        builder.component.set(initial: signature)
        return builder
    }
}
