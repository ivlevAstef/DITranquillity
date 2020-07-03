//
//  DIGraph+validationErrors.swift
//  DITranquillity
//
//  Created by Ивлев А.Е. on 03.07.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

import Foundation


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

}
