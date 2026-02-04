//
//  DIEdge.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 06.07.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

/// Represents a dependency edge in the graph adjacency list.
///
/// `DIEdge` contains metadata about a dependency relationship between components,
/// including whether it's from an initializer, whether it's a cycle dependency,
/// and various type modifiers.
///
/// ## Edge Properties
///
/// - `initial`: Dependency from init vs injection
/// - `cycle`: Marked as cycle dependency
/// - `optional`: Can be nil
/// - `many`: Expects array of implementations
/// - `delayed`: Uses Lazy/Provider wrapper
/// - `async`: Uses AsyncLazy/AsyncProvider wrapper
/// - `tags`: Associated tags for resolution
/// - `name`: Named resolution identifier
public final class DIEdge: Hashable {
    let id: Int

    /// Whether this dependency is from the component's initializer.
    ///
    /// `true` for dependencies in the registration closure `.register(YourClass.init)`,
    /// `false` for dependencies added via `.injection()`.
    public let initial: Bool

    /// Whether this is a cycle-breaking dependency.
    ///
    /// `true` only for dependencies registered with `.injection(cycle: true, ...)`.
    /// Cycle dependencies are resolved after the initial object graph is created.
    public let cycle: Bool

    /// Whether this dependency is optional.
    ///
    /// `true` if the dependency type is `Optional<T>`. Optional dependencies
    /// don't cause resolution failures if not registered.
    public let optional: Bool

    /// Whether this is a multi-object dependency.
    ///
    /// `true` if the dependency uses the `many()` modificator to resolve
    /// all implementations of a type as an array.
    public let many: Bool

    /// Whether this dependency uses delayed resolution.
    ///
    /// `true` if the dependency type is `Lazy<T>`, `Provider<T>`, `AsyncLazy<T>`, or `AsyncProvider<T>`.
    public let delayed: Bool

    /// Whether this dependency uses async delayed resolution.
    ///
    /// `true` if the dependency type is `AsyncLazy<T>` or `AsyncProvider<T>`.
    /// Subset of `delayed` dependencies.
    public let async: Bool

    /// Tags applied to this dependency for resolution.
    ///
    /// Empty array if no tags are specified. Multiple tags require nested `DIByTag` types.
    public let tags: [DITag]

    /// Optional name for named resolution.
    ///
    /// `nil` for type-only resolution.
    public let name: String?

    /// The dependency type being resolved.
    ///
    /// This is the base type after unwrapping Optional, Lazy, Provider, etc.
    public let type: DIAType

    init(by parameter: MethodSignature.Parameter, id: Int, initial: Bool, cycle: Bool) {
        var tags: [DITag] = []
        var typeIterator: ParsedType? = parameter.parsedType
        repeat {
            if let sType = typeIterator?.sType, sType.tag {
                tags.append(sType.tagType)
            }
            typeIterator = typeIterator?.parent
        } while typeIterator != nil

        self.id = id
        self.initial = initial
        self.cycle = cycle
        self.optional = parameter.parsedType.optional
        self.many = parameter.parsedType.hasMany
        self.delayed = parameter.parsedType.hasDelayed
        self.async = parameter.parsedType.asyncDelayed
        self.tags = tags
        self.name = parameter.name
        self.type = parameter.parsedType.base.type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    public static func == (lhs: DIEdge, rhs: DIEdge) -> Bool {
        return lhs.id == rhs.id
    }
}
