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

  /// a graph contains object which create - have initialized or can maked and safed in cache
  private func checkGraphOnCanInitialize() -> Bool {
    var successful: Bool = true

    for fromIndex in matrix.indices {
      for (edge, toIndex) in matrix[fromIndex] {
        guard case .component(let componentVertex) = vertices[toIndex] else {
          continue
        }
        if componentVertex.canInitialize {
          continue
        }

        // fromIndex have edge into toIndex. If toIndex have path to fromIndex then it's cycle
        let hasCycle = hasPath(from: toIndex, to: fromIndex)

        successful = successful && componentVertex.lifeTime != .prototype
        successful = successful && (componentVertex.lifeTime != .objectGraph || hasCycle)

        // TODO: add error if lifeTime prototype
        // add error if lifeTime objectGraph and not found circle (To -> ... -> From -> To)
        // add warning if lifeTime objectGraph - it's correct only if start from To and have circle (see prev)
        // add info if lifetime perContainer, perRun, single - it's correct if call injection for this type
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

      for (_, toIndex) in matrix[fromIndex] {
        if !visited.contains(toIndex) {
          stack.append(toIndex)
        }
      }
      visited.insert(fromIndex)
    }

    return false
  }

  /// a graph is unambiguous if any dependency can always be passed unambiguously to another one
  private func checkGraphForUnambiguity() -> Bool {
    var successful: Bool = true

    for fromIndex in matrix.indices {
      var parameterNumberMapToCount: [Int: [Int]] = [:]

      for (edge, toIndex) in matrix[fromIndex] {
        if edge.many { // ignore many
          continue
        }

        parameterNumberMapToCount[edge.parameterNumber, default: []].append(toIndex)
      }

      // TODO: add error about ambiguity - fromIndex contais ambiguity injection to components
      let haveAmbiguityParameter = parameterNumberMapToCount.contains { $0.value.count > 1 }
      successful = successful && !haveAmbiguityParameter
    }

     //plog(parameter, msg: "Ambiguous \(description(type: parameter.parsedType)) from \(component.info) contains in: \(infos)")

    return successful
  }

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
        for (edge, _) in matrix[fromIndex].filter({ $0.toIndex == toIndex }) {
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
