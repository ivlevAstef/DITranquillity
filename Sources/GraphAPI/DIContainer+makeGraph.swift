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

    var matrix: [[DIEdge?]] = Array(repeating: Array(repeating: nil, count: vertices.count), count: vertices.count)

    for (index, component) in components.enumerated() {
      // get all paramaters - from init and injection
      let parametersInfo = componentParametersInfo(component: component)
      for (parameter, cycle) in parametersInfo {
        // ignore reference on self
        if parameter.parsedType.useObject {
          continue
        }

        let edge = makeEdge(by: parameter, cycle: cycle)

        if addArgument(by: parameter.parsedType, matrix: &matrix, vertices: &vertices) {
          matrix[index][vertices.count] = edge
          continue
        }

        let candidates = resolver.findComponents(by: parameter.parsedType, with: parameter.name, from: component.framework)
        let toIndices = candidates.compactMap { findIndex(for: $0, in: components) }
        for toIndex in toIndices {
            matrix[index][toIndex] = edge
        }
        
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
      let center = (right - left) / 2
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

  private func addArgument(by parsedType: ParsedType, matrix: inout [[DIEdge?]], vertices: inout [DIVertex]) -> Bool {
    if !parsedType.arg {
      return false
    }

    guard let argType = parsedType.sType?.type else {
      return false
    }

    matrix.append(Array(repeating: nil, count: matrix.first?.count ?? 0))
    for index in matrix.indices {
      matrix[index].append(nil)
    }
    vertices.append(DIVertex.argument(DIArgumentVertex(type: argType)))

    return true
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
                  name: parameter.name)
  }
}

//for component in components {
//let parameters = component.signatures.flatMap{ $0.parameters }
//let framework = component.framework
//
//for parameter in parameters {
//  if parameter.parsedType.useObject || parameter.parsedType.arg {
//    continue
//  }
//
//  let candidates = resolver.findComponents(by: parameter.parsedType, with: parameter.name, from: framework)
//  let filtered = resolver.removeWhoDoesNotHaveInitialMethod(components: candidates)
//
//  let correct = 1 == filtered.count || parameter.parsedType.hasMany
//  let hasCachedLifetime = filtered.isEmpty && candidates.contains{ $0.lifeTime != .prototype }
//  let success = correct || parameter.parsedType.hasOptional || hasCachedLifetime
//  successfull = successfull && success
//
//  // Log
//  if !correct {
//    if candidates.isEmpty {
//      plog(parameter, msg: "Not found component for \(description(type: parameter.parsedType)) from \(component.info)")
//    } else if filtered.isEmpty {
//      let infos = candidates.map{ $0.info }
//
//      if hasCachedLifetime {
//        log(.info, msg: "Not found component for \(description(type: parameter.parsedType)) from \(component.info) that would have initialization methods, but object can maked from cache. Were found: \(infos)")
//      } else {
//        plog(parameter, msg: "Not found component for \(description(type: parameter.parsedType)) from \(component.info) that would have initialization methods. Were found: \(infos)")
//      }
//    } else if filtered.count >= 1 {
//      let infos = filtered.map{ $0.info }
//      plog(parameter, msg: "Ambiguous \(description(type: parameter.parsedType)) from \(component.info) contains in: \(infos)")
//    }
//  }
//}
