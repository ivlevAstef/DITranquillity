//
//  DIGraph.swift
//  DITranquillity
//
//  Created by Ивлев А.Е. on 30.06.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

public struct DIComponentVertex {
  public let componentInfo: DIComponentInfo
  public let lifeTime: DILifeTime
  public let isDefault: Bool
  public let canInitialize: Bool

  public let framework: DIFramework.Type?
  public let part: DIPart.Type?
}

public struct DIArgumentVertex {
  public let type: DIAType
}

public struct DIUnknownVertex {
  public let type: DIAType
}

/// Information about vertex in graph. Vertex is it component/argument or unknown type.
public enum DIVertex {
  /// Component. Is it description about registration in di container.
  case component(DIComponentVertex)
  /// Argument. Is it injection information but injection not component - injection runtime argument. For more information see modificators.
  case argument(DIArgumentVertex)
  /// Unknown. Is it invalid injection because not found component for dependency.
  case unknown(DIUnknownVertex)
}

/// Information about transition in dependency graph matrix. This transition is a dependency.
public struct DIEdge {
  /// Is it dependency cycle. It could be only dependency written as `.injection(cycle: true,...`
  public let cycle: Bool
  /// Is it dependency optional. Optional dependency contains `Optional` type.
  public let optional: Bool
  /// Is it dependency many. See more information about `many` in modificators.
  public let many: Bool
  /// Is it dependency delayed. Is it or `Lazy` or `Provider` from SwiftLazy library
  public let delayed: Bool
  /// dependency all tags. Can be empty.
  public let tags: [DITag]
  /// dependency name. Can be nil.
  public let name: String?
  /// Parameter number. Supported information about edge injection number. In simple case one dependency have one edge, but not for many.
  /// For many or not valid dependency one injection can have more edges. For an unambiguous comparison was invented `groupNumber`
  /// DIfference injection have different numbers.
  public let parameterNumber: Int
}

/// Dependency graph. Contains vertices array: components or argument or type. and transition matrix.
public struct DIGraph {
  public typealias Matrix = [[(edge: DIEdge, toIndex: Int)]]
  /// vertices array. It's All dependencies. Contains All components, all arguments and all unknown type dependencies.
  public let vertices: [DIVertex]

  /// Directed, Transition matrix. Contains information about transition from vertex to vertex. Containts edges.
  /// For get transition information your can write: `for (edge, toIndex) in matrix[fromIndexVertices]`
  /// This write means that component by fromIndexVertices can dependency on toIndex.
  public let matrix: Matrix

  init(vertices: [DIVertex], matrix: Matrix) {
    self.vertices = vertices
    self.matrix = matrix
  }
}
