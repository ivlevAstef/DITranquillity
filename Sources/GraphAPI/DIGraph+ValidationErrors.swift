//
//  DIGraph+ValidationErrors.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 03.07.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

extension DIGraph {

  // MARK: - not initialize

  func log_canNotInitializePrototype(_ vertex: DIVertex, from fromVertex: DIVertex, optional: Bool) {
    let logLevel = optional ? DILogLevel.warning : DILogLevel.error
    log(logLevel, msg: "No initialization method for \(vertex.description). And found reference on this component from \(fromVertex.description).")
  }

  func log_canNotInitializeObjectGraphWithoutCycle(_ vertex: DIVertex, from fromVertex: DIVertex, optional: Bool) {
    let logLevel = optional ? DILogLevel.warning : DILogLevel.error
    log(logLevel, msg: "No initialization method for \(vertex.description). And found reference on this component from \(fromVertex.description).")
  }

  func log_canNotInitializeObjectGraphWithCycle(_ vertex: DIVertex, from fromVertex: DIVertex, optional: Bool) {
    let logLevel = optional ? DILogLevel.info : DILogLevel.warning
    log(logLevel, msg: "No initialization method for \(vertex.description). This component can be created using `inject(into:...` or if created from storyboard. Otherwise it's incorrect. And found refrence on this component from \(fromVertex.description).")
  }

  func log_canNotInitializeCached(_ vertex: DIVertex, from fromVertex: DIVertex) {
    log(.info, msg: "No initialization method for \(vertex.description). This component can be created using `inject(into:...` or if created from storyboard. After first created component can be taken from cache. And found refrence on this component from \(fromVertex.description).")
  }

  func log_canNotInitialize(_ vertex: DIVertex) {
    log(.info, msg: "No initialization method for \(vertex.description). This component can be created using `inject(into:...` or if created from storyboard. Otherwise it's incorrect.")
  }

  func log_canNotInitializeCached(_ vertex: DIVertex) {
    log(.info, msg: "No initialization method for \(vertex.description). This component can be created using `inject(into:...` or if created from storyboard. After first created component can be taken from cache.")
  }

  // MARK: - ambiguity
  func log_ambiguityReference(from fromVertex: DIVertex, for type: DIAType, candidates: [DIVertex], optional: Bool) {
    let logLevel = optional ? DILogLevel.warning : DILogLevel.error
    log(logLevel, msg: "Ambiguity create object for type: \(type) into \(fromVertex.description). Candidates: \(candidates.map { $0.description })")
  }

  // MARK: - reachibility
  func log_invalidReferenceOptional(from fromVertex: DIVertex, on type: DIAType) {
    log(.warning, msg: "Invalid reference from \(fromVertex.description) because not found component type: Optional<\(type)>")
  }

  func log_invalidReferenceMany(from fromVertex: DIVertex, on type: DIAType) {
      log(.warning, msg: "Invalid reference from \(fromVertex.description) because not found component type: Array<\(type)>")
  }

  func log_invalidReference(from fromVertex: DIVertex, on type: DIAType) {
      log(.error, msg: "Invalid reference from \(fromVertex.description) because not found component for type: \(type)")
  }

  // MARK: - cycle
  func log_cycleAnyInitEdges(vertices: [DIVertex], edges: [DIEdge]) {
    let cycleDescriptionMaker = { makeCycleDescription(vertices: vertices, edges: edges) }
    log(.error, msg: "Found a cycle used only init methods. Please tear cycle: \(cycleDescriptionMaker())")
  }

  func log_cycleNoHaveBreakPoint(vertices: [DIVertex], edges: [DIEdge]) {
    let cycleDescriptionMaker = { makeCycleDescription(vertices: vertices, edges: edges) }
    log(.error, msg: "Found a cycle without tears. Please tear cycle use `.injection(cycle: true...`: \(cycleDescriptionMaker())")
  }

  func log_cycleAnyVerticesPrototype(vertices: [DIVertex], edges: [DIEdge]) {
    let cycleDescriptionMaker = { makeCycleDescription(vertices: vertices, edges: edges) }
    log(.error, msg: "Found a cycle where any components have lifetime `prototype`. This cycle will be created indefinitely. Please change lifetime on `objectGraph` or other. Cycle description: \(cycleDescriptionMaker())")
  }

  func log_cycleHavePrototype(vertices: [DIVertex], edges: [DIEdge]) {
    let cycleDescriptionMaker = { makeCycleDescription(vertices: vertices, edges: edges) }
    log(.warning, msg: "Found a cycle where is it components have lifetime `prototype`. This cycle can make incorrect, if call resolve from `prototype` component. You can change lifetime on `objectGraph` or ignore warning. Cycle description: \(cycleDescriptionMaker())")
  }

  func log_cycleHaveInvariantLifetimes(vertices: [DIVertex], edges: [DIEdge]) {
    let cycleDescriptionMaker = { makeCycleDescription(vertices: vertices, edges: edges) }
    log(.warning, msg: "Found a cycle where is it components have different lifetimes. This cycle can make incorrect. If start resolve from `prototype`/`objectGraph` you can reference from `perContainer`/`perRun`/`single` on other object because there is an old resolve in cache. Cycle description: \(cycleDescriptionMaker())")
  }
}

fileprivate func makeCycleDescription(vertices: [DIVertex], edges: [DIEdge]) -> String {
  var vertexDescriptions = vertices.map { $0.description }
  guard let firstDescription = vertexDescriptions.first else {
    return ""
  }
  vertexDescriptions.append(firstDescription)
  return vertexDescriptions.joined(separator: " -> ")
}
