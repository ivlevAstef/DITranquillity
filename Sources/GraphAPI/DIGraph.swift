//
//  DIGraph.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30.06.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

/// Dependency graph representation for analysis and validation.
///
/// `DIGraph` provides a complete view of all registered components and their dependencies.
/// Use it to validate your DI configuration, detect issues, and analyze dependency relationships.
///
/// ## Overview
///
/// The graph consists of:
/// - **Vertices**: All registered components, runtime arguments, and unknown dependencies
/// - **Adjacency List**: Directed edges representing dependencies between vertices
///
/// ## Creating a Graph
///
/// ```swift
/// let container = DIContainer()
/// // ... register components ...
///
/// let graph = container.makeGraph()
/// ```
///
/// ## Validation
///
/// ```swift
/// // Validate the entire graph
/// let isValid = graph.checkIsValid()
///
/// // Find cycles in the graph
/// let cycles = graph.findCycles()
/// ```
///
/// ## Dependency Analysis
///
/// ```swift
/// // Iterate through all vertices
/// for vertex in graph.vertices {
///     switch vertex {
///     case .component(let component):
///         print("Component: \(component.componentInfo)")
///     case .argument(let arg):
///         print("Runtime argument: \(arg.type)")
///     case .unknown(let unknown):
///         print("Missing dependency: \(unknown.type)")
///     }
/// }
///
/// // Analyze dependencies
/// for (index, edges) in graph.adjacencyList.enumerated() {
///     for (edge, targetIndices) in edges {
///         print("\(graph.vertices[index]) -> \(targetIndices.map { graph.vertices[$0] })")
///     }
/// }
/// ```
public struct DIGraph {
    /// Type alias for the adjacency list structure.
    ///
    /// Each entry is an array of (edge, target indices) tuples representing
    /// outgoing dependencies from a vertex.
    public typealias AdjacencyList = [[(edge: DIEdge, toIndices: [Int])]]

    /// All vertices in the dependency graph.
    ///
    /// Contains all registered components, runtime arguments, and unknown type dependencies.
    /// Use the index into this array with `adjacencyList` to traverse dependencies.
    public let vertices: [DIVertex]

    /// Directed adjacency list representing dependencies.
    ///
    /// For each vertex index, contains an array of (edge, target indices) tuples.
    /// The edge describes the dependency relationship, and target indices point to
    /// the dependent vertices.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// for (edge, toIndices) in graph.adjacencyList[fromIndex] {
    ///     // fromIndex vertex depends on vertices at toIndices
    ///     // edge contains dependency metadata (optional, many, delayed, etc.)
    /// }
    /// ```
    ///
    /// - Note: Multiple target indices occur for `many` dependencies or invalid graphs
    ///   where multiple components match a single dependency.
    public let adjacencyList: AdjacencyList

    init(vertices: [DIVertex], adjacencyList: AdjacencyList) {
        self.vertices = vertices
        self.adjacencyList = adjacencyList
    }
}
