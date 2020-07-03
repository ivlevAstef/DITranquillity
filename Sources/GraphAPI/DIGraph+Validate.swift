//
//  DIGraph+Validate.swift
//  DITranquillity
//
//  Created by Ивлев А.Е. on 02.07.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

extension DIGraph {

  public func checkIsValid() -> Bool {
    let canInitialize = checkGraphOnCanInitialize()
    let unambiguity = checkGraphForUnambiguity()
    let reachibility = checkGraphForReachability()
    return canInitialize && unambiguity && reachibility// TODO: && cycles
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
            successful = false
            log_canNotInitializePrototype(vertices[toIndex], from: vertices[fromIndex], optional: edge.optional)
          } else if componentVertex.lifeTime == .objectGraph {
            // fromIndex have edge into toIndex. If toIndex have path to fromIndex then it's cycle
            let hasCycle = hasPath(from: toIndex, to: fromIndex)
            if !hasCycle {
              successful = false
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
        successful = false

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

      var success: Bool = true
      var edgesCount: Int = 0
      var optionalCount: Int = 0
      var manyCount: Int = 0
      for fromIndex in matrix.indices {
        for (edge, _) in matrix[fromIndex].filter({ $0.toIndices.contains(toIndex) }) {
          edgesCount += 1
          optionalCount += edge.optional ? 1 : 0
          manyCount += edge.many ? 1 : 0

          let isOptionalEdge = edge.optional || edge.many
          success = success && isOptionalEdge
        }
      }

      // TODO: need add:
      // error if not success.
      // warning if only many edge.
      // info if only optional edge.
      successful = successful && success
    }

    //plog(parameter, msg: "Not found component for \(description(type: parameter.parsedType)) from \(component.info)")

    return successful
  }
}
