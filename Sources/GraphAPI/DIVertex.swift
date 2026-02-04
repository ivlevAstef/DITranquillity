//
//  DIVertex.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 06.07.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

/// Represents a vertex in the dependency graph.
///
/// Each vertex can be one of three types:
/// - **Component**: A registered DI component
/// - **Argument**: A runtime argument (used with `arg()` modificator)
/// - **Unknown**: A dependency that couldn't be resolved (indicates configuration error)
public enum DIVertex: Hashable {
    /// A registered component vertex.
    ///
    /// Represents a component that was registered in the DI container.
    case component(DIComponentVertex)

    /// A runtime argument vertex.
    ///
    /// Created when a component dependency uses the `arg()` modificator instead of
    /// resolving from the container.
    case argument(DIArgumentVertex)

    /// An unknown dependency vertex.
    ///
    /// Created when a component has a dependency on a type that has no matching
    /// registration. This indicates a configuration error.
    case unknown(DIUnknownVertex)
}

/// Detailed information about a registered component.
///
/// `DIComponentVertex` contains all metadata about a component registration,
/// including its type, lifetime, priority, isolation context, and registration location.
public final class DIComponentVertex: Hashable {
    /// Swift concurrency isolation context for the component.
    public enum Isolated {
        /// Component is isolated to the main actor.
        case main
        /// Component is isolated to a custom global actor.
        case global(any Actor)
    }

    /// Registration metadata including type, file, and line number.
    public let componentInfo: DIComponentInfo

    /// The component's lifetime policy.
    public let lifeTime: DILifeTime

    /// The component's resolution priority (normal, default, or test).
    public let priority: DIComponentPriority

    /// Whether the component has an initializer method.
    ///
    /// `false` if the component was registered without an init closure
    /// (e.g., `container.register(Type.self)` without a factory).
    public let canInitialize: Bool

    /// Alternative types registered with `as(_:)`, `as(_:tag:)`, or `as(_:name:)`.
    public let alternativeTypes: [ComponentAlternativeType]

    /// Swift concurrency isolation information.
    ///
    /// `nil` if the component has no actor isolation,
    /// `.main` for MainActor isolation,
    /// `.global(actor)` for custom global actor isolation.
    public let isolation: Isolated?

    /// Whether the component is marked as a root entry point.
    public let isRoot: Bool

    /// Whether the component is marked as potentially unused.
    public let unused: Bool

    /// The framework where this component was registered, if any.
    public let framework: DIFramework.Type?

    /// The part where this component was registered, if any.
    public let part: DIPart.Type?

    init(component: Component) {
        self.componentInfo = component.info
        self.lifeTime = component.lifeTime
        self.priority = component.priority
        self.canInitialize = component.initial != nil
        self.alternativeTypes = component.alternativeTypes

        if let isolationActor = component.initial?.isolation {
            self.isolation = isolationActor === MainActor.shared ? .main : .global(isolationActor)
        } else {
            self.isolation = nil
        }
        self.isRoot = component.isRoot
        self.unused = component.unused
        self.framework = component.framework
        self.part = component.part
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(componentInfo)
    }
    public static func ==(lhs: DIComponentVertex, rhs: DIComponentVertex) -> Bool {
        return lhs.componentInfo == rhs.componentInfo
    }
}

/// Vertex representing a runtime argument dependency.
///
/// Created when a component uses the `arg()` modificator to receive
/// a value at resolution time instead of resolving from the container.
///
/// ## Example Registration
///
/// ```swift
/// container.register { MyService(config: $0, userId: arg($1)) }
/// // The userId parameter creates a DIArgumentVertex in the graph
/// ```
public final class DIArgumentVertex: Hashable {
    let id: Int

    /// The expected type of the runtime argument.
    public let type: DIAType

    init(id: Int, type: DIAType) {
        self.id = id
        self.type = type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func ==(lhs: DIArgumentVertex, rhs: DIArgumentVertex) -> Bool {
        return lhs.id == rhs.id
    }
}

/// Vertex representing an unresolved dependency.
///
/// Created when a component has a dependency on a type that has no matching
/// registration in the container. This typically indicates a configuration error.
///
/// - Important: The presence of `DIUnknownVertex` in a graph usually means
///   the DI configuration is incomplete. Use `graph.checkIsValid()` to detect these issues.
public final class DIUnknownVertex: Hashable {
    let id: Int

    /// The type that could not be resolved.
    public let type: DIAType

    init(id: Int, type: DIAType) {
        self.id = id
        self.type = type
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    public static func ==(lhs: DIUnknownVertex, rhs: DIUnknownVertex) -> Bool {
        return lhs.id == rhs.id
    }
}

extension DIVertex: CustomStringConvertible {
    /// A textual representation of the vertex.
    public var description: String {
        switch self {
        case .component(let componentVertex):
            return componentVertex.componentInfo.description
        case .argument(let argumentVertex):
            return "<Argument. type: \(argumentVertex.type)>"
        case .unknown(let unknownVertex):
            return "<Unknown. type: \(unknownVertex.type)>"
        }
    }
}
