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
  private struct Cycle: Hashable {
    let vertexIndices: [Int]
    let edges: [DIEdge]
  }

  private func checkGraphForCycles() -> Bool {
    let cycles = findAllCycles()

    for cycle in cycles {
      assert(cycle.vertexIndices.count >= 2)
      assert(cycle.edges.count >= 2)
      assert(cycle.vertexIndices.count == cycle.edges.count)
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

      var anyInitialEdge: Bool = true
      var hasCycleEdge: Bool = false
      for edge in cycle.edges {
        // TODO: подумать
        hasCycleEdge = hasCycleEdge || (edge.cycle || (edge.initial && edge.many))
        anyInitialEdge = anyInitialEdge && (edge.initial && !edge.many)
      }

      if anyInitialEdge {
        log_cycleAnyInitEdges(vertices: cycleVertices, edges: cycle.edges)
      }
    }

    return true
  }

  private func findAllCycles() -> [Cycle] {
    var visitedVertices: Set<Int> = []
    var allCycles: [Cycle] = []
    for (index, vertex) in vertices.enumerated() {
      guard case .component = vertex else {
        continue
      }
      // Почему мы можем так делать? Почему пройденные вершины точно можно исключить из поиска циклов
      // Рассмотрим две ситуации:
      // Пройденная вершина не входит в цикл. Тогда стартуя из нее мы точно уже не найдем цикла - ведь мы с нее уже начинали и не нашли цикл.
      // Пройденная вершина входит в цикл. Тогда мы уже нашли этот цикл, так как нельзя взять вершину входящую в цикл и не найти все циклы проходящие через нее. На то он и цикл.
      // По этой причине мы можем смело выкидывать вершины которые уже просмотрели на одной из итераций
      if visitedVertices.contains(index) {
        continue
      }

      allCycles.append(contentsOf: findCycles(from: index, visited: &visitedVertices))
    }

    return allCycles
  }

  private func findCycles(from vertexIndex: Int, visited globalVisitedVertices: inout Set<Int>) -> [Cycle] {
    // Для поиска циклов используется обход в глубину
    // рекурсивный для простоты - в любом случае если упадет тут рекурсия, то уж точно упадет при получении зависимостей :)
    var result: [Cycle] = []
    findCycles(currentVertexIndex: vertexIndex,
               visitedVertices: [],
               visitedEdges: [],
               globalVisitedVertices: &globalVisitedVertices,
               result: &result)

    return result
  }

  private func findCycles(currentVertexIndex: Int,
                          visitedVertices: [Int], // need order for subcycle
                          visitedEdges: [DIEdge], // need order for subcycle
                          globalVisitedVertices: inout Set<Int>,
                          result: inout [Cycle]) {
    if let cycleStartIndex = visitedVertices.lastIndex(of: currentVertexIndex) {
      assert(visitedVertices.count == visitedEdges.count)
      // In all cases edges count equal vertexIndicesCount
      let cycleVertexIndices = Array(visitedVertices[cycleStartIndex...])
      let cycleEdges = Array(visitedEdges[cycleStartIndex...])

      let cycle = Cycle(vertexIndices: cycleVertexIndices, edges: cycleEdges)
      result.append(cycle)
      return
    }

    let visitedVertices = visitedVertices + [currentVertexIndex]
    globalVisitedVertices.insert(currentVertexIndex)

    for (edge, toIndices) in matrix[currentVertexIndex] {
      let visitedEdges = visitedEdges + [edge]
      for toVertexIndex in toIndices {
        findCycles(currentVertexIndex: toVertexIndex,
                   visitedVertices: visitedVertices,
                   visitedEdges: visitedEdges,
                   globalVisitedVertices: &globalVisitedVertices,
                   result: &result)
      }
    }
  }
}
