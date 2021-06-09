//
//  DIEdge.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 06.07.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

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

