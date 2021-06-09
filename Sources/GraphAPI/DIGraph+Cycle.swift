//
//  DIGraph+Cycle.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 06.07.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

/// Information about cycle.
public struct DICycle {
  /// array of vertex indices. Don't contains dublicates.
  public let vertexIndices: [Int]
  /// array of edges. edges[index] it's edge from vertexIndices[index] to vertexIndices[(index + 1) % count]
  public let edges: [DIEdge]
}


extension DIGraph {
  /// Function found all cycles in graph and safe this cycles in array.
  /// - Returns: array of cycles
  public func findCycles() -> [DICycle] {
    return CycleFinder(in: self).findAllCycles()
  }
}

/// Class need for optimization - he containts local properties.
fileprivate final class CycleFinder {
  private let graph: DIGraph

  private var startVertexIndex: Int = 0
  private var result: [DICycle] = []

  private var reachableIndices: [Set<Int>] // Optimization x100

  fileprivate init(in graph: DIGraph) {
    self.graph = graph
    reachableIndices = Array(repeating: [], count: graph.vertices.count)
  }

  fileprivate func findAllCycles() -> [DICycle] {
    findAllReachableIndices()

    result = []
    for (index, vertex) in graph.vertices.enumerated() {
      guard case .component = vertex else {
        continue
      }

      startVertexIndex = index
      // dfs
      findCycles(currentVertexIndex: index,
                 visitedVertices: [],
                 visitedEdges: [])
    }

    return result
  }

  private func findAllReachableIndices() {
    assert(reachableIndices.count == graph.vertices.count)

    for (index, vertex) in graph.vertices.enumerated() {
      guard case .component = vertex else {
        continue
      }

      reachableIndices[index] = findAllReachableIndices(for: index)
    }
  }

  private func findAllReachableIndices(for startVertexIndex: Int) -> Set<Int> {
    var visited: Set<Int> = []
    var stack: [Int] = [startVertexIndex]
    while let fromIndex = stack.popLast() {
      visited.insert(fromIndex)
      for toIndex in graph.adjacencyList[fromIndex].flatMap({ $0.toIndices }) {
        if !visited.contains(toIndex) {
          stack.insert(toIndex, at: 0)
        }
      }
    }

    return visited
  }

  private func findCycles(currentVertexIndex: Int,
                          visitedVertices: [Int], // need order for subcycle
                          visitedEdges: [DIEdge]) {
    if currentVertexIndex == startVertexIndex && !visitedVertices.isEmpty {
      result.append(DICycle(vertexIndices: visitedVertices, edges: visitedEdges))
      return
    }

    if visitedVertices.contains(currentVertexIndex) {
      return
    }

    // first check - current vertex find ALL cycles via current vertex.
    // Second check - current vertex guaranted not cycles via startVertexIndex.
    if currentVertexIndex < startVertexIndex || !reachableIndices[currentVertexIndex].contains(startVertexIndex) {
      return
    }

    let visitedVertices = visitedVertices + [currentVertexIndex]

    for (edge, toIndices) in graph.adjacencyList[currentVertexIndex] {
      let visitedEdges = visitedEdges + [edge]
      for toVertexIndex in toIndices {
        findCycles(currentVertexIndex: toVertexIndex,
                   visitedVertices: visitedVertices,
                   visitedEdges: visitedEdges)
      }
    }
  }
}
