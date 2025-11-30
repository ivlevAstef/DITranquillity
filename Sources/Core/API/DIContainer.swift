//
//  DIContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import class Foundation.Thread

/// A container holding all registered components,
/// allows you to register new components, parts, frameworks and
/// allows you to receive objects by type.
public final class DIContainer: Sendable {
  /// Extensions for container. Use this components, for subscribe on event from container about registration or resolve or make component.
  nonisolated(unsafe) public let extensions = DIExtensions()

  /// Make entry point for library
  ///
  /// - Parameter parent: parent container. first there is an attempt resolve from self, after from parent. For `many` resolve from both and recursive
  public init(parent: DIContainer? = nil) {
    self.parent = parent
    resolver = Resolver(container: self)
    
    register { [unowned self] in return self }.lifetime(.prototype).unused()
  }

  internal let componentContainer = ComponentContainer()
  internal let frameworksDependencies = FrameworksDependenciesContainer()
  internal let extensionsContainer = ExtensionsContainer()
  internal let parent: DIContainer?
  nonisolated(unsafe) internal private(set) var resolver: Resolver!

  nonisolated(unsafe) internal var hasRootComponents: Bool = false

  ///MARK: Hierarchy
  final class IncludedParts: @unchecked Sendable {
    private var parts: Set<ObjectIdentifier> = []
    private let mutex = PThreadMutex(recursive: ())
    
    func checkAndInsert(_ part: ObjectIdentifier) -> Bool {
      return mutex.sync { parts.insert(part).inserted }
    }
  }
  
  final class Stack<T>: @unchecked Sendable {
    private let key: String
    
    var last: T? { return stack?.last }

    init(key: String) {
      self.key = key
    }
    
    func push(_ element: T) {
      if let stack = self.stack {
        self.stack = stack + [element]
      } else {
        self.stack = [element]
      }
    }
    
    func pop() {
      if let stack = self.stack {
        self.stack = Array(stack.dropLast())
      }
    }
    
    private var stack: [T]? {
      set { ThreadDictionary.insert(key: key, obj: newValue ?? []) }
      get { return ThreadDictionary.get(key: key) as? [T] }
    }
  }
  
  internal let includedParts = IncludedParts()
  internal let partStack = Stack<DIPart.Type>(key: "DIContainer_Stack_Part")
  internal let frameworkStack = Stack<DIFramework.Type>(key: "DIContainer_Stack_Framework")
}

extension DIContainer {
  /// Initialize registered object with lifetime `.single`
  public func initializeSingletonObjects() async {
    await initializeObjectsWithLifetime(.single)
  }

  /// Initialize registered object with specified scope. Please don't use this method if your scope don't cache objects.
  public func initializeObjectsForScope(_ scope: DIScope) async {
    await initializeObjectsWithLifetime(.custom(scope))
  }

  private func initializeObjectsWithLifetime(_ lifetime: DILifeTime) async {
    let components = componentContainer.components.filter{ lifetime == $0.lifeTime }
    if components.isEmpty { // for ignore log
      return
    }

    log(.verbose, msg: "Begin resolving \(components.count) components with lifetime: \(lifetime)", brace: .begin)
    defer { log(.verbose, msg: "End resolving components with lifetime: \(lifetime)", brace: .end) }

    for component in components {
      await resolver.resolveCached(component: component)
    }
  }
}

// MARK: - Clean
extension DIContainer {
  /// Remove all cached object in container with lifetime `perContainer(_)`
  public func clean() {
    resolver.clean()
  }
}
