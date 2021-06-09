//
//  DIContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import class Foundation.Thread

prefix operator *
/// Short syntax for resolve.
/// Using:
/// ```
/// let yourObj: YourClass = *container
/// ```
///
/// - Parameter container: A container.
/// - Returns: Created object.
public prefix func *<T>(container: DIContainer) -> T {
  return container.resolve()
}

/// A container holding all registered components,
/// allows you to register new components, parts, frameworks and
/// allows you to receive objects by type.
public final class DIContainer {
  /// Extensions for container. Use this components, for subscribe on event from container about registration or resolve or make component.
  public let extensions = DIExtensions()

  /// Make entry point for library
  ///
  /// - Parameter parent: parent container. first there is an attempt resolve from self, after from parent. For `many` resolve from both and recursive
  public init(parent: DIContainer? = nil) {
    self.parent = parent
    resolver = Resolver(container: self)
    
    register { [unowned self] in return self }.lifetime(.prototype)
  }
  
  internal let componentContainer = ComponentContainer()
  internal let frameworksDependencies = FrameworksDependenciesContainer()
  internal let extensionsContainer = ExtensionsContainer()
  internal let parent: DIContainer?
  internal private(set) var resolver: Resolver!
  
  ///MARK: Hierarchy
  final class IncludedParts {
    private var parts: Set<ObjectIdentifier> = []
    private let mutex = PThreadMutex(recursive: ())
    
    func checkAndInsert(_ part: ObjectIdentifier) -> Bool {
      return mutex.sync { parts.insert(part).inserted }
    }
  }
  
  final class Stack<T> {
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

// MARK: - register
extension DIContainer {
  /// Registering a new component without initial.
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   . ...
  /// ```
  ///
  /// - Parameters:
  ///   - type: A type of new component.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl>(_ type: Impl.Type, file: String = #file, line: Int = #line) -> DIComponentBuilder<Impl> {
    return DIComponentBuilder(container: self, componentInfo: DIComponentInfo(type: Impl.self, file: file, line: line))
  }
  
  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0>(file: String = #file, line: Int = #line, _ c: @escaping (P0) -> Impl) -> DIComponentBuilder<Impl> {
    if P0.self is Void.Type {
      return register(file, line, MethodMaker.makeVoid(by: c))
    } else {
      return register(file, line, MethodMaker.make1([P0.self], by: c))
    }
  }
  
  
  internal func register<Impl>(_ file: String, _ line: Int, _ signature: MethodSignature) -> DIComponentBuilder<Impl> {
    let builder = register(Impl.self, file: file, line: line)
    builder.component.set(initial: signature)
    return builder
  }
}

// MARK: - resolve
extension DIContainer {
  /// Resolve object by type.
  /// Can crash application, if can't found the type.
  /// But if the type is optional, then the application will not crash, but it returns nil.
  ///
  /// - Parameter framework: Framework from which to resolve a object
  /// - Parameter arguments: Information about injection arguments. Used only if your registration objects with `arg` modificator.
  /// - Returns: Object for the specified type, or nil (see description).
  public func resolve<T>(from framework: DIFramework.Type? = nil, arguments: AnyArguments? = nil) -> T {
    return resolver.resolve(from: framework, arguments: arguments)
  }

  /// Resolve object by type.
  /// Can crash application, if can't found the type.
  /// But if the type is optional, then the application will not crash, but it returns nil.
  ///
  /// - Parameter framework: Framework from which to resolve a object
  /// - Parameter arguments: arguments for resolved object by type.
  /// - Returns: Object for the specified type, or nil (see description).
  public func resolve<T>(from framework: DIFramework.Type? = nil, args: Any?...) -> T {
    return resolver.resolve(from: framework, arguments: AnyArguments(for: T.self, argsArray: args))
  }
  
  /// Resolve object by type with tag.
  /// Can crash application, if can't found the type with tag.
  /// But if the type is optional, then the application will not crash, but it returns nil.
  ///
  /// - Parameters:
  ///   - tag: Resolve tag.
  ///   - framework: Framework from which to resolve a object
  ///   - arguments: Information about injection arguments. Used only if your registration objects with `arg` modificator.
  /// - Returns: Object for the specified type with tag, or nil (see description).
  public func resolve<T, Tag>(tag: Tag.Type, from framework: DIFramework.Type? = nil, arguments: AnyArguments? = nil) -> T {
    return by(tag: tag, on: resolver.resolve(from: framework, arguments: arguments))
  }
  
  /// Resolve object by type with name.
  /// Can crash application, if can't found the type with name.
  /// But if the type is optional, then the application will not crash, but it returns nil.
  ///
  /// - Parameters:
  ///   - name: Resolve name.
  ///   - framework: Framework from which to resolve a object
  ///   - arguments: Information about injection arguments. Used only if your registration objects with `arg` modificator.
  /// - Returns: Object for the specified type with name, or nil (see description).
  public func resolve<T>(name: String, from framework: DIFramework.Type? = nil, arguments: AnyArguments? = nil) -> T {
    return resolver.resolve(name: name, from: framework, arguments: arguments)
  }
  
  /// Resolve many objects by type.
  ///
  /// - Parameter arguments: Information about injection arguments. Used only if your registration objects with `arg` modificator.
  /// - Returns: Objects for the specified type.
  public func resolveMany<T>(arguments: AnyArguments? = nil) -> [T] {
    return many(resolver.resolve(arguments: arguments))
  }
  
  /// Injected all dependencies into object.
  /// If the object type couldn't be found, then in logs there will be a warning, and nothing will happen.
  ///
  /// - Parameters:
  ///   - object: object in which injections will be introduced.
  ///   - framework: Framework from which to injection into object
  public func inject<T>(into object: T, from framework: DIFramework.Type? = nil) {
    resolver.injection(obj: object, from: framework)
  }
  
  /// Initialize registered object with lifetime `.single`
  public func initializeSingletonObjects() {
    initializeObjectsWithLifetime(.single)
  }

  /// Initialize registered object with specified scope. Please don't use this method if your scope don't cache objects.
  public func initializeObjectsForScope(_ scope: DIScope) {
    initializeObjectsWithLifetime(.custom(scope))
  }

  private func initializeObjectsWithLifetime(_ lifetime: DILifeTime) {
    let components = componentContainer.components.filter{ lifetime == $0.lifeTime }
    if components.isEmpty { // for ignore log
      return
    }

    log(.verbose, msg: "Begin resolving \(components.count) components with lifetime: \(lifetime)", brace: .begin)
    defer { log(.verbose, msg: "End resolving components with lifetime: \(lifetime)", brace: .end) }

    for component in components {
      resolver.resolveCached(component: component)
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
