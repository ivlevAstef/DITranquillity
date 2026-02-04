//
//  DIGraph+Cycle.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 06.07.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

/// Information about a dependency cycle in the graph.
///
/// A cycle represents a circular dependency chain where components depend on each other
/// in a loop. Cycles can cause infinite recursion if not properly handled.
///
/// ## Breaking Cycles
///
/// Cycles can be broken by:
/// - Using `Lazy<T>`,`AsyncLazy<T>` or `Provider<T>`,`AsyncProvider<T>` wrappers
/// - Marking injections as cycle: `.injection(cycle: true, ...)`
/// - Using cached lifetimes (perContainer, perRun, single)
public struct DICycle {
    /// Indices of vertices forming the cycle (no duplicates).
    ///
    /// Use these indices with `DIGraph.vertices` to get the actual vertices.
    public let vertexIndices: [Int]

    /// Edges connecting the cycle vertices.
    ///
    /// `edges[i]` is the edge from `vertexIndices[i]` to `vertexIndices[(i + 1) % count]`.
    public let edges: [DIEdge]
}


extension DIGraph {
    /// Finds all dependency cycles in the graph.
    ///
    /// This method performs a comprehensive search for all cycles, regardless of
    /// whether they start from root components.
    ///
    /// - Returns: Array of all cycles found in the graph.
    ///
    /// - Note: This is a computationally expensive operation for large graphs.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let cycles = graph.findCycles()
    /// for cycle in cycles {
    ///     print("Cycle length: \(cycle.vertexIndices.count)")
    ///     for index in cycle.vertexIndices {
    ///         print("  - \(graph.vertices[index])")
    ///     }
    /// }
    /// ```
    public func findCycles() -> [DICycle] {
        return CycleFinder(in: self).findAllCycles()
    }

    /// Finds cycles that may arise from root or singleton components.
    ///
    /// This method is more efficient than `findCycles()` as it only searches
    /// for cycles starting from root components and singletons.
    ///
    /// - Returns: Array of cycles reachable from root/singleton components.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // More efficient for graphs with root components
    /// let cycles = graph.findRootCycles()
    /// ```
    public func findRootCycles() -> [DICycle] {
        return CycleFinder(in: self).findRootCycles()
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
        findCycles(use: { _ in return true })
    }

    fileprivate func findRootCycles() -> [DICycle] {
        findCycles(use: { $0.isRoot || $0.lifeTime == .single })
    }

    fileprivate func findCycles(use canUseComponent: (DIComponentVertex) -> Bool) -> [DICycle] {
        findAllReachableIndices()

        result = []
        for (index, vertex) in graph.vertices.enumerated() {
            guard case .component(let component) = vertex else {
                continue
            }
            if !canUseComponent(component) {
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
