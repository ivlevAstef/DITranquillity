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
    // TODO: implementation
    // if hasCachedLifetime {
    //  log(.info, msg: "Not found component for \(description(type: parameter.parsedType)) from \(component.info) that would have initialization methods, but object can maked from cache. Were found: \(infos)")
    // } else {
    //   plog(parameter, msg: "Not found component for \(description(type: parameter.parsedType)) from \(component.info) that would have initialization methods. Were found: \(infos)")
    // }
    return true
  }

  /// a graph is unambiguous if any dependency can always be passed unambiguously to another one
  private func checkGraphForUnambiguity() -> Bool {
    var successful: Bool = true

    for fromIndex in matrix.indices {
      var parameterNumberMapToCount: [Int: [Int]] = [:]

      for toIndex in matrix[fromIndex].indices {
        guard let edge = matrix[fromIndex][toIndex] else {
          continue
        }
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

    for (toIndex, vertex) in vertices.enumerated() {
      guard case .unknown(let unknownVertex) = vertex else {
        continue
      }

      var success: Bool = true
      var edgesCount: Int = 0
      var optionalCount: Int = 0
      var manyCount: Int = 0
      for fromIndex in matrix.indices {
        guard let edge = matrix[fromIndex][toIndex] else {
          continue
        }
        edgesCount += 1
        optionalCount += edge.optional ? 1 : 0
        manyCount += edge.many ? 1 : 0

        let isOptionalEdge = edge.optional || edge.many
        success = success && isOptionalEdge
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
