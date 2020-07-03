//
//  DIContainer+getGraph.swift
//  DITranquillity
//
//  Created by Ивлев А.Е. on 30.06.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

extension DIContainer {

  /// Make graph for public usage.
  /// Also your can call `validate` for check for correct
  /// - Returns: Dependency graph
  public func makeGraph() -> DIGraph {
    let components = componentContainer.components.sorted(by: { $0.order < $1.order })

    var vertices = makeVertices(by: components)

    var matrix: DIGraph.Matrix = Array(repeating: [], count: vertices.count)

    for (index, component) in components.enumerated() {
      // get all paramaters - from init and injection
      let parametersInfo = componentParametersInfo(component: component)
      for (parameter, cycle) in parametersInfo {
        // ignore reference on self
        if parameter.parsedType.useObject {
          continue
        }

        let edge = makeEdge(by: parameter, cycle: cycle)

        if addArgumentIfNeeded(by: parameter.parsedType, matrix: &matrix, vertices: &vertices) {
          matrix[index].append((edge, [vertices.count - 1]))
          continue
        }

        let candidates = resolver.findComponents(by: parameter.parsedType, with: parameter.name, from: component.framework)
        let toIndices = candidates.compactMap { findIndex(for: $0, in: components) }

        assert(candidates.count == toIndices.count)
        // not found candidates - need add reference on unknown type
        if toIndices.isEmpty {
          addUnknown(by: parameter.parsedType, matrix: &matrix, vertices: &vertices)
          matrix[index].append((edge, [vertices.count - 1]))
          continue
        }

        matrix[index].append((edge, toIndices))
      }
    }

    return DIGraph(vertices: vertices, matrix: matrix)
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

  private func addArgumentIfNeeded(by parsedType: ParsedType, matrix: inout DIGraph.Matrix, vertices: inout [DIVertex]) -> Bool {
    if !parsedType.arg {
      return false
    }

    guard let argType = parsedType.sType?.type else {
      return false
    }

    addVertex(DIVertex.argument(DIArgumentVertex(type: argType)), matrix: &matrix, vertices: &vertices)
    return true
  }

  private func addUnknown(by parsedType: ParsedType, matrix: inout DIGraph.Matrix, vertices: inout [DIVertex]) {
    addVertex(DIVertex.unknown(DIUnknownVertex(type: parsedType.type)), matrix: &matrix, vertices: &vertices)
  }

  private func addVertex(_ vertex: DIVertex, matrix: inout DIGraph.Matrix, vertices: inout [DIVertex]) {
    matrix.append([])
    vertices.append(vertex)
  }

  private func componentParametersInfo(component: Component) -> [(MethodSignature.Parameter, Bool)] {
    var result: [(MethodSignature.Parameter, Bool)] = []

    if let initial = component.initial {
      result.append(contentsOf: initial.parameters.map { ($0, false) })
    }

    for injection in component.injections {
      result.append(contentsOf: injection.signature.parameters.map{ ($0, injection.cycle) })
    }

    return result
  }

  private func makeVertices(by components: [Component]) -> [DIVertex] {
    return components.map { component in
      return .component(DIComponentVertex(
        componentInfo: component.info,
        lifeTime: component.lifeTime,
        isDefault: component.isDefault,
        canInitialize: component.initial != nil,
        framework: component.framework,
        part: component.part
      ))
    }
  }

  private func makeEdge(by parameter: MethodSignature.Parameter, cycle: Bool) -> DIEdge {
    var tags: [DITag] = []
    var typeIterator: ParsedType? = parameter.parsedType
    repeat {
      if let sType = typeIterator?.sType, sType.tag {
        tags.append(sType.tagType)
      }
      typeIterator = typeIterator?.parent
    } while typeIterator != nil

    return DIEdge(cycle: cycle,
                  optional: parameter.parsedType.optional,
                  many: parameter.parsedType.hasMany,
                  delayed: parameter.parsedType.hasDelayed,
                  tags: tags,
                  name: parameter.name,
                  type: parameter.parsedType.base.type)
  }
}
