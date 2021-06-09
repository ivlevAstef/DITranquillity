//
//  DIContainer+getGraph.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30.06.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

extension DIContainer {

  /// Make graph for public usage.
  /// Your can call `checkIsValid` for check for correct.
  /// Or Your can use this graph for dependency analysis.
  /// - Returns: Dependency graph
  public func makeGraph() -> DIGraph {
    let components = componentContainer.components

    var edgeId: Int = 0
    var vertices: [DIVertex] = components.map { .component(DIComponentVertex(component: $0)) }
    var adjacencyList: DIGraph.AdjacencyList = Array(repeating: [], count: vertices.count)

    for (index, component) in components.enumerated() {
      // get all paramaters - from init and injection
      let parametersInfo = componentParametersInfo(component: component)
      for (parameter, initial, cycle) in parametersInfo {
        // ignore reference on self
        if parameter.parsedType.useObject {
          continue
        }

        edgeId += 1
        let edge = DIEdge(by: parameter, id: edgeId, initial: initial, cycle: cycle)

        if addArgumentIfNeeded(by: parameter.parsedType, adjacencyList: &adjacencyList, vertices: &vertices) {
          adjacencyList[index].append((edge, [vertices.count - 1]))
          continue
        }

        let candidates = resolver.findComponents(by: parameter.parsedType, with: parameter.name, from: component.framework)
        let toIndices = candidates.compactMap { findIndex(for: $0, in: components) }

        assert(candidates.count == toIndices.count)
        // not found candidates - need add reference on unknown type
        if toIndices.isEmpty {
          addUnknown(by: parameter.parsedType, adjacencyList: &adjacencyList, vertices: &vertices)
          adjacencyList[index].append((edge, [vertices.count - 1]))
          continue
        }

        adjacencyList[index].append((edge, toIndices))
      }
    }

    return DIGraph(vertices: vertices, adjacencyList: adjacencyList)
  }

  private func findIndex(for component: Component, in components: [Component]) -> Int? {
    if components.isEmpty {
      return nil
    }

    let count = components.count
    var left = 0
    var right = count

    while left <= right {
      let center = (right + left) / 2
      if components[center] === component {
        return center
      }

      if component.order < components[center].order {
        right = center - 1
      } else {
        left = center + 1
      }
    }

    return nil
  }

  private func addArgumentIfNeeded(by parsedType: ParsedType, adjacencyList: inout DIGraph.AdjacencyList, vertices: inout [DIVertex]) -> Bool {
    if !parsedType.arg {
      return false
    }

    let baseType = parsedType.base
    let argType = baseType.sType?.type ?? baseType.type

    let id = vertices.count
    addVertex(DIVertex.argument(DIArgumentVertex(id: id, type: argType)), adjacencyList: &adjacencyList, vertices: &vertices)
    return true
  }

  private func addUnknown(by parsedType: ParsedType, adjacencyList: inout DIGraph.AdjacencyList, vertices: inout [DIVertex]) {
    let id = vertices.count
    let baseType = parsedType.base
    let unknownType = baseType.sType?.type ?? baseType.type

    addVertex(DIVertex.unknown(DIUnknownVertex(id: id, type: unknownType)), adjacencyList: &adjacencyList, vertices: &vertices)
  }

  private func addVertex(_ vertex: DIVertex, adjacencyList: inout DIGraph.AdjacencyList, vertices: inout [DIVertex]) {
    adjacencyList.append([])
    vertices.append(vertex)
  }

  typealias ParameterInfo = (parameter: MethodSignature.Parameter, initial: Bool, cycle: Bool)
  private func componentParametersInfo(component: Component) -> [ParameterInfo] {
    var result: [ParameterInfo] = []

    if let initial = component.initial {
      result.append(contentsOf: initial.parameters.map { ($0, true, false) })
    }

    for injection in component.injections {
      result.append(contentsOf: injection.signature.parameters.map{ ($0, false, injection.cycle) })
    }

    return result
  }
}
