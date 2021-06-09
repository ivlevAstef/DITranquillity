//
//  DIVertex.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 06.07.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

/// Information about vertex in graph. Vertex is it component/argument or unknown type.
public enum DIVertex: Hashable {
  /// Component. Is it description about registration in di container.
  case component(DIComponentVertex)
  /// Argument. Is it injection information but injection not component - injection runtime argument. For more information see modificators.
  case argument(DIArgumentVertex)
  /// Unknown. Is it invalid injection because not found component for dependency.
  case unknown(DIUnknownVertex)
}

/// Component vertex. For all components maked one to one component vertex
public final class DIComponentVertex: Hashable {
  /// Information about registration component - type, file, line
  public let componentInfo: DIComponentInfo
  /// Component lifetime
  public let lifeTime: DILifeTime
  /// Component set to `default` or `test`
  public let priority: DIComponentPriority
  /// Component have `init` method or not
  public let canInitialize: Bool
  /// Alternative types. It's types setup in component used function `as(...`
  public let alternativeTypes: [ComponentAlternativeType]

  /// Framework where this component was register
  public let framework: DIFramework.Type?
  /// Part where this component was register
  public let part: DIPart.Type?

  init(component: Component) {
    self.componentInfo = component.info
    self.lifeTime = component.lifeTime
    self.priority = component.priority
    self.canInitialize = component.initial != nil
    self.alternativeTypes = component.alternativeTypes
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

/// This vertex maked if component have dependency using `arg`.
public final class DIArgumentVertex: Hashable {
  let id: Int

  /// Argument type in component dependency
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

/// This vertex maked if component have dependency on unknown type
public final class DIUnknownVertex: Hashable {
  let id: Int

  /// Unknown type - for this type DI didn't find component in graph
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
