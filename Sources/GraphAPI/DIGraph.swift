//
//  DIGraph.swift
//  DITranquillity
//
//  Created by Ивлев А.Е. on 30.06.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

/// Component vertex. For all components maked one to one component vertex
public struct DIComponentVertex: Hashable {
  /// Information about registration component - type, file, line
  public let componentInfo: DIComponentInfo
  /// Component lifetime
  public let lifeTime: DILifeTime
  /// Component have `default` flag or not
  public let isDefault: Bool
  /// Component have `init` method or not
  public let canInitialize: Bool

  /// Framework where this component was register
  public let framework: DIFramework.Type?
  /// Part where this component was register
  public let part: DIPart.Type?

  public func hash(into hasher: inout Hasher) {
    hasher.combine(componentInfo)
  }
  public static func ==(lhs: DIComponentVertex, rhs: DIComponentVertex) -> Bool {
    return lhs.componentInfo == rhs.componentInfo
  }
}

/// This vertex maked if component have dependency using `arg`.
public struct DIArgumentVertex: Hashable {
  let id: Int

  /// Argument type in component dependency
  public let type: DIAType

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  public static func ==(lhs: DIArgumentVertex, rhs: DIArgumentVertex) -> Bool {
    return lhs.id == rhs.id
  }
}

/// This vertex maked if component have dependency on unknown type
public struct DIUnknownVertex: Hashable {
  let id: Int

  /// Unknown type - for this type DI didn't find component in graph
  public let type: DIAType

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  public static func ==(lhs: DIUnknownVertex, rhs: DIUnknownVertex) -> Bool {
    return lhs.id == rhs.id
  }
}

/// Information about vertex in graph. Vertex is it component/argument or unknown type.
public enum DIVertex: Hashable {
  /// Component. Is it description about registration in di container.
  case component(DIComponentVertex)
  /// Argument. Is it injection information but injection not component - injection runtime argument. For more information see modificators.
  case argument(DIArgumentVertex)
  /// Unknown. Is it invalid injection because not found component for dependency.
  case unknown(DIUnknownVertex)
}

/// Information about transition in dependency graph adjacency list. This transition is a dependency.
public final class DIEdge: Hashable {
  let id: Int
  /// Is it dependency from init method.
  public let initial: Bool
  /// Is it dependency cycle. It could be only dependency written as `.injection(cycle: true,...`
  public let cycle: Bool
  /// Is it dependency optional. Optional dependency contains `Optional` type.
  public let optional: Bool
  /// Is it dependency many. See more information about `many` in modificators.
  public let many: Bool
  /// Is it dependency delayed. Is it or `Lazy` or `Provider` from SwiftLazy library
  public let delayed: Bool
  /// Dependency all tags. Can be empty.
  public let tags: [DITag]
  /// Dependency name. Can be nil.
  public let name: String?
  /// The type that transition 
  public let type: DIAType

  init(id: Int, initial: Bool, cycle: Bool, optional: Bool, many: Bool, delayed: Bool, tags: [DITag], name: String?, type: DIAType) {
    self.id = id
    self.initial = initial
    self.cycle = cycle
    self.optional = optional
    self.many = many
    self.delayed = delayed
    self.tags = tags
    self.name = name
    self.type = type
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  public static func == (lhs: DIEdge, rhs: DIEdge) -> Bool {
    return lhs.id == rhs.id
  }
}

/// Dependency graph. Contains vertices array: components or argument or type. and transition adjacency list.
public struct DIGraph {
  public typealias AdjacencyList = [[(edge: DIEdge, toIndices: [Int])]]
  /// vertices array. It's All dependencies. Contains All components, all arguments and all unknown type dependencies.
  public let vertices: [DIVertex]

  /// Directed, Transition фdjacency list. Contains information about transition from vertex to vertices. Containts edges.
  /// For get transition information your can write: `for (edge, toIndices) in adjacencyList[fromIndexVertices]`
  /// This write means that component by fromIndexVertices can dependency on toIndices.
  /// array of to indices need only for many, or if not valid graph.
  public let adjacencyList: AdjacencyList

  init(vertices: [DIVertex], adjacencyList: AdjacencyList) {
    self.vertices = vertices
    self.adjacencyList = adjacencyList
  }
}


extension DIVertex: CustomStringConvertible {
  /// Vertex description
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
