//
//  DIPart.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 16/06/16.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

/// Protocol for organizing components into reusable parts.
///
/// `DIPart` provides a way to group related component registrations together.
/// Unlike `DIFramework`, parts don't manage dependencies between modules -
/// they're simply a way to organize code.
///
/// ## Overview
///
/// Use parts to:
/// - Group related components together
/// - Create reusable registration modules
/// - Keep registration code organized and maintainable
/// - Compose larger frameworks from smaller parts
///
/// ## Creating a Part
///
/// ```swift
/// final class RepositoryPart: DIPart {
///     static func load(container: DIContainer) {
///         container.register(UserRepository.init)
///             .as(UserRepositoryProtocol.self)
///
///         container.register(ProductRepository.init)
///             .as(ProductRepositoryProtocol.self)
///     }
/// }
/// ```
///
/// ## Using Parts
///
/// ```swift
/// // Standalone usage
/// let container = DIContainer()
/// container.append(part: RepositoryPart.self)
/// container.append(part: ServicePart.self)
///
/// // Inside a framework
/// final class DataFramework: DIFramework {
///     static func load(container: DIContainer) {
///         container.append(part: RepositoryPart.self)
///         container.append(part: CachePart.self)
///     }
/// }
/// ```
///
/// - Note: Each part is loaded only once, even if appended multiple times.
public protocol DIPart: Sendable, AnyObject {
    /// Registers components belonging to this part.
    ///
    /// Implement this method to register all components that belong to this part.
    ///
    /// - Parameter container: The DI container for registration.
    ///
    /// - Important: Do not call this method directly. Use `container.append(part:)` instead.
    static func load(container: DIContainer)
}

extension DIContainer {
    /// Registers a part in the container.
    ///
    /// This method loads all components defined in the part. Each part
    /// is loaded only once, even if `append(part:)` is called multiple times.
    ///
    /// - Parameter part: The part type to register.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let container = DIContainer()
    /// container.append(part: RepositoryPart.self)
    /// container.append(part: ServicePart.self)
    /// container.append(part: ViewModelPart.self)
    /// ```
    @discardableResult
    public func append(part: DIPart.Type) -> DIContainer {
        if includedParts.checkAndInsert(ObjectIdentifier(part)) {
            partStack.push(part)
            defer { partStack.pop() }

            part.load(container: self)
        }

        return self
    }
}
