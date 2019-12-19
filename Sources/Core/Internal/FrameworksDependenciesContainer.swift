//
//  FrameworksDependenciesContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 06/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

final class FrameworksDependenciesContainer {
  private var imports = [FrameworkWrapper: Set<FrameworkWrapper>]()
  private var mutex = PThreadMutex(normal: ())
  
  final func dependency(framework: DIFramework.Type, import importFramework: DIFramework.Type) {
    let frameworkWrapper = FrameworkWrapper(framework: framework)
    let importFrameworkWrapper = FrameworkWrapper(framework: importFramework)
    mutex.sync {
      if nil == imports[frameworkWrapper]?.insert(importFrameworkWrapper) {
        imports[frameworkWrapper] = [importFrameworkWrapper]
      }
    }
  }

  func filterByChilds(for framework: DIFramework.Type, components: Components) -> Components {
    let frameworkWrapper = FrameworkWrapper(framework: framework)
    let childs = mutex.sync {
      return imports[frameworkWrapper] ?? []
    }

    return components.filter { $0.framework.map { childs.contains(FrameworkWrapper(framework: $0)) } ?? false }
  }
}

private class FrameworkWrapper: Hashable {
  let framework: DIFramework.Type
  private let identifier: ObjectIdentifier

  init(framework: DIFramework.Type) {
    self.framework = framework
    self.identifier = ObjectIdentifier(framework)
  }

  #if swift(>=5.0)
  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
  #else
  var hashValue: Int {
    return identifier.hashValue
  }
  #endif

  static func ==(lhs: FrameworkWrapper, rhs: FrameworkWrapper) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}
