//
//  DIGraph+Validate.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 02.07.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

extension DIGraph {
  /// Validate the graph by checking various conditions.
  ///
  /// - Parameter checkGraphCycles: check cycles in the graph of heavy operation. So it can be disabled.
  /// - Returns: true if validation success.
  public func checkIsValid(checkGraphCycles: Bool = true) -> Bool {
    let canInitialize = checkGraphOnCanInitialize()
    let unambiguity = checkGraphForUnambiguity()
    let reachibility = checkGraphForReachability()
    let notCycles = checkGraphCycles ? checkGraphForCycles() : true
    return canInitialize && unambiguity && reachibility && notCycles
  }
}

// MARK: - can initialize
extension DIGraph {
  /// a graph contains object which create - have initialized or can maked and safed in cache
  private func checkGraphOnCanInitialize() -> Bool {
    var successful: Bool = true

    var visitedVertices: Set<DIVertex> = []

    for fromIndex in adjacencyList.indices {
      for (edge, toIndices) in adjacencyList[fromIndex] {
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
              _ = hasPath(from: toIndex, to: fromIndex)
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

      visited.insert(fromIndex)
      for toIndex in adjacencyList[fromIndex].flatMap({ $0.toIndices }) {
        if !visited.contains(toIndex) {
          stack.append(toIndex)
        }
      }
    }

    return false
  }
}

// MARK: - unambiguity
extension DIGraph {
  /// a graph is unambiguous if any dependency can always be passed unambiguously to another one
  private func checkGraphForUnambiguity() -> Bool {
    var successful: Bool = true

    for fromIndex in adjacencyList.indices {
      for (edge, toIndices) in adjacencyList[fromIndex] {
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
      guard let fromIndex = adjacencyList.firstIndex(where: { $0.contains { $0.toIndices.contains(toIndex) }}) else {
        assertionFailure("Can't found from vertices for unknown vertex? it's bug in code")
        continue
      }

      guard let (edge, _) = adjacencyList[fromIndex].first(where: { $0.toIndices.contains(toIndex) }) else {
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
    let cycles = findCycles()

    func calculateAverageLength() -> Double {
      let summaryVerticesCount = cycles.map { $0.vertexIndices.count }.reduce(0, +)
      return Double(summaryVerticesCount) / Double(cycles.count)
    }
    log(.verbose, msg: "Found \(cycles.count) cycles with average length: \(calculateAverageLength())")

    let isValidVerticesCycles = checkGraphCyclesVertices(cycles: cycles)
    let isValidEdgesCycles = checkGraphCyclesEdges(cycles: cycles)

    return isValidVerticesCycles && isValidEdgesCycles
  }


  private func checkGraphCyclesVertices(cycles: [DICycle]) -> Bool {
    var successful: Bool = true
    for cycle in cycles {
      assert(cycle.vertexIndices.count >= 1)
      let cycleVertices = cycle.vertexIndices.map { vertices[$0] }

      var anyVerticesPrototype: Bool = true
      var countPrototypeLifetime: Int = 0
      var countObjectGraphLifetime: Int = 0
      var countCachedLifetime: Int = 0
      var countCustomLifetime: Int = 0
      for vertex in cycleVertices {
        guard case .component(let componentVertex) = vertex else {
          continue
        }
        anyVerticesPrototype = anyVerticesPrototype && (componentVertex.lifeTime == .prototype)
        switch componentVertex.lifeTime {
        case .prototype: countPrototypeLifetime += 1
        case .objectGraph: countObjectGraphLifetime += 1
        case .perContainer: countCachedLifetime += 1
        case .perRun: countCachedLifetime += 1
        case .single: countCachedLifetime += 1
        case .custom: countCustomLifetime += 1
        }
      }

      if anyVerticesPrototype {
        successful = false
        log_cycleAnyVerticesPrototype(vertices: cycleVertices, edges: cycle.edges)
      }

      if countPrototypeLifetime > 0 {
        log_cycleHavePrototype(vertices: cycleVertices, edges: cycle.edges)
      }

      if countCachedLifetime > 0 && countPrototypeLifetime + countObjectGraphLifetime > 0 {
        log_cycleHaveInvariantLifetimes(vertices: cycleVertices, edges: cycle.edges)
      }
    }

    return successful
  }

  private func checkGraphCyclesEdges(cycles: [DICycle]) -> Bool {
    var successful: Bool = true
    for cycle in cycles {
      assert(cycle.edges.count >= 1)
      let cycleVertices = cycle.vertexIndices.map { vertices[$0] }

      var anyInitialEdge: Bool = true
      var hasBreakPointEdge: Bool = false
      for edge in cycle.edges {
        hasBreakPointEdge = hasBreakPointEdge || (edge.cycle || edge.delayed || (edge.initial && edge.many))
        anyInitialEdge = anyInitialEdge && (edge.initial && !edge.many && !edge.delayed)
      }

      if anyInitialEdge {
        successful = false
        log_cycleAnyInitEdges(vertices: cycleVertices, edges: cycle.edges)
      } else if !hasBreakPointEdge {
        successful = false
        log_cycleNoHaveBreakPoint(vertices: cycleVertices, edges: cycle.edges)
      }
    }

    return successful
  }
}
