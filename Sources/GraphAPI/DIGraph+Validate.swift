//
//  DIGraph+Validate.swift
//  DITranquillity
//
//  Created by Ивлев А.Е. on 02.07.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

extension DIGraph {

  public func checkIsValid(checkGraphCycles: Bool = false) -> Bool {
    let canInitialize = checkGraphOnCanInitialize()
    let unambiguity = checkGraphForUnambiguity()
    let reachibility = checkGraphForReachability()
    let notCycles = !checkGraphCycles || checkGraphForCycles()
    return canInitialize && unambiguity && reachibility && notCycles
  }
}

// MARK: - can initialize
extension DIGraph {
  /// a graph contains object which create - have initialized or can maked and safed in cache
  private func checkGraphOnCanInitialize() -> Bool {
    var successful: Bool = true

    var visitedVertices: Set<DIVertex> = []

    for fromIndex in matrix.indices {
      for (edge, toIndices) in matrix[fromIndex] {
        for toIndex in toIndices {
          guard case .component(let componentVertex) = vertices[toIndex] else {
            continue
          }
          if componentVertex.canInitialize {
            continue
          }
          visitedVertices.insert(vertices[toIndex])

          if componentVertex.lifeTime == .prototype {
            successful = successful && edge.optional
            log_canNotInitializePrototype(vertices[toIndex], from: vertices[fromIndex], optional: edge.optional)
          } else if componentVertex.lifeTime == .objectGraph {
            // fromIndex have edge into toIndex. If toIndex have path to fromIndex then it's cycle
            let hasCycle = hasPath(from: toIndex, to: fromIndex)
            if !hasCycle {
              successful = successful && edge.optional
              log_canNotInitializeObjectGraphWithoutCycle(vertices[toIndex], from: vertices[fromIndex], optional: edge.optional)
            } else {
              log_canNotInitializeObjectGraphWithCycle(vertices[toIndex], from: vertices[fromIndex], optional: edge.optional)
            }
          } else {
            log_canNotInitializeCached(vertices[toIndex], from: vertices[fromIndex])
          }
        }
      }
    }

    // Also add logs from components if not found reference on this.
    for vertex in vertices {
      guard case .component(let componentVertex) = vertex else {
        continue
      }
      if componentVertex.canInitialize || visitedVertices.contains(vertex) {
        continue
      }

      if componentVertex.lifeTime == .prototype || componentVertex.lifeTime == .objectGraph {
        log_canNotInitialize(vertex)
      } else {
        log_canNotInitializeCached(vertex)
      }
    }

    return successful
  }

  private func hasPath(from startFromIndex: Int, to requiredIndex: Int) -> Bool {
    var visited: Set<Int> = []
    var stack: [Int] = [startFromIndex]
    while let fromIndex = stack.first {
      stack.removeFirst()

      if fromIndex == requiredIndex {
        return true
      }

      for toIndex in matrix[fromIndex].flatMap({ $0.toIndices }) {
        if !visited.contains(toIndex) {
          stack.append(toIndex)
        }
      }
      visited.insert(fromIndex)
    }

    return false
  }
}

// MARK: - unambiguity
extension DIGraph {
  /// a graph is unambiguous if any dependency can always be passed unambiguously to another one
  private func checkGraphForUnambiguity() -> Bool {
    var successful: Bool = true

    for fromIndex in matrix.indices {
      for (edge, toIndices) in matrix[fromIndex] {
        if edge.many { // ignore many
          continue
        }
        if toIndices.count <= 1 {
          continue
        }
        successful = successful && edge.optional

        let candidates = toIndices.map { vertices[$0] }
        log_ambiguityReference(from: vertices[fromIndex], for: edge.type, candidates: candidates, optional: edge.optional)
      }
    }

    return successful
  }
}

// MARK: - reachibility
extension DIGraph {
  /// a graph is reachability if any dependency have edge on component, or optional.
  private func checkGraphForReachability() -> Bool {
    var successful: Bool = true

    /// Yes it's N^3 but unknown vertices it shouldn't be too much
    for (toIndex, vertex) in vertices.enumerated() {
      guard case .unknown(let unknownVertex) = vertex else {
        continue
      }

      // By make algorith for unknown vertex can only one from vertex.
      guard let fromIndex = matrix.firstIndex(where: { $0.contains { $0.toIndices.contains(toIndex) }}) else {
        assertionFailure("Can't found from vertices for unknown vertex? it's bug in code")
        continue
      }

      guard let (edge, _) = matrix[fromIndex].first(where: { $0.toIndices.contains(toIndex) }) else {
        assertionFailure("But in top code checked on contains")
        continue
      }

      if edge.optional {
        log_invalidReferenceOptional(from: vertices[fromIndex], on: unknownVertex.type)
        continue
      }

      if edge.many {
        log_invalidReferenceMany(from: vertices[fromIndex], on: unknownVertex.type)
        continue
      }

      successful = false

      log_invalidReference(from: vertices[fromIndex], on: unknownVertex.type)
    }

    return successful
  }
}

// MARK: - cycle
extension DIGraph {
  private func checkGraphForCycles() -> Bool {
    return true
  }
}

//fileprivate func checkGraphCycles(_ components: [Component]) -> Bool {
//  var success: Bool = true
//
//  typealias Stack = (component: Component, initial: Bool, cycle: Bool, many: Bool)
//  func dfs(for component: Component, visited: Set<Component>, stack: [Stack]) {
//    // it's cycle
//    if visited.contains(component) {
//      func isValidCycle() -> Bool {
//        if stack.first!.component != component {
//          // but inside -> will find in a another dfs call.
//          return true
//        }
//
//        let infos = stack.dropLast().map{ $0.component.info }
//        let short = infos.map{ "\($0.type)" }.joined(separator: " - ")
//
//        let allInitials = !stack.contains{ !($0.initial && !$0.many) }
//        if allInitials {
//          log(.error, msg: "You have a cycle: \(short) consisting entirely of initialization methods. Full: \(infos)")
//          return false
//        }
//
//        let hasGap = stack.contains{ $0.cycle || ($0.initial && $0.many) }
//        if !hasGap {
//          log(.error, msg: "Cycle has no discontinuities. Please install at least one explosion in the cycle: \(short) using `injection(cycle: true) { ... }`. Full: \(infos)")
//          return false
//        }
//
//        let allPrototypes = !stack.contains{ $0.component.lifeTime != .prototype }
//        if allPrototypes {
//          log(.error, msg: "You cycle: \(short) consists only of object with lifetime - prototype. Please change at least one object lifetime to another. Full: \(infos)")
//          return false
//        }
//
//        let containsPrototype = stack.contains{ $0.component.lifeTime == .prototype }
//        if containsPrototype {
//          log(.info, msg: "You cycle: \(short) contains an object with lifetime - prototype. In some cases this can lead to an udesirable effect.  Full: \(infos)")
//        }
//
//        return true
//      }
//
//      success = isValidCycle() && success
//      return
//    }
//
//    let framework = component.framework
//
//    var visited = visited
//    visited.insert(component)
//
//
//    func callDfs(by parameters: [MethodSignature.Parameter], initial: Bool, cycle: Bool) {
//      for parameter in parameters {
//        let candidates = resolver.findComponents(by: parameter.parsedType, with: parameter.name, from: framework)
//        if candidates.isEmpty {
//          continue
//        }
//
//        let filtered = candidates.filter {
//         (nil != $0.initial || ($0.lifeTime != .prototype && visited.contains($0)))
//        }
//        let many = parameter.parsedType.hasMany
//        for subcomponent in filtered {
//          var stack = stack
//          stack.append((subcomponent, initial, cycle || parameter.parsedType.hasDelayed, many))
//          dfs(for: subcomponent, visited: visited, stack: stack)
//        }
//      }
//    }
//
//    if let initial = component.initial {
//      callDfs(by: initial.parameters, initial: true, cycle: false)
//    }
//
//    for injection in component.injections {
//      callDfs(by: injection.signature.parameters, initial: false, cycle: injection.cycle)
//    }
//  }
//
//
//  for component in components {
//    let stack = [(component, false, false, false)]
//    dfs(for: component, visited: [], stack: stack)
//  }
//
//  return success
//}
