//
//  DIGraph.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30.06.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

/// Dependency graph. Contains vertices array: components or argument or type. and transition adjacency list.
public struct DIGraph {
  public typealias AdjacencyList = [[(edge: DIEdge, toIndices: [Int])]]
  /// vertices array. It's All dependencies. Contains All components, all arguments and all unknown type dependencies.
  public let vertices: [DIVertex]

  /// Directed, Transition adjacency list. Contains information about transition from vertex to vertices. Containts edges.
  /// For get transition information your can write: `for (edge, toIndices) in adjacencyList[fromIndexVertices]`
  /// This write means that component by fromIndexVertices can dependency on toIndices.
  /// array of to indices need only for many, or if not valid graph.
  public let adjacencyList: AdjacencyList

  init(vertices: [DIVertex], adjacencyList: AdjacencyList) {
    self.vertices = vertices
    self.adjacencyList = adjacencyList
  }
}
