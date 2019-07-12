//
//  DIContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

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

  /// Make entry point for library
  ///
  /// - Parameter parent: parent container. first there is an attempt resolve from self, after from parent. For `many` resolve from both and recursive
  public init(parent: DIContainer? = nil) {
    self.parent = parent
    resolver = Resolver(container: self)
    
    register { [unowned self] in return self }.lifetime(.prototype)
  }
  
  internal let componentContainer = ComponentContainer()
  internal let bundleContainer = BundleContainer()
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
    private let key = "DIContainer_Stack_ThreadSafe\(T.self)\(UUID().uuidString)"
    
    var last: T? { return stack?.last }
    
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
      set { return Thread.current.threadDictionary[key] = newValue }
      get { return Thread.current.threadDictionary[key] as? [T] }
    }
  }
  
  internal let includedParts = IncludedParts()
  internal let partStack = Stack<DIPart.Type>()
  internal let frameworkStack = Stack<DIFramework.Type>()
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
  /// - Parameter bundle: Bundle from which to resolve a object
  /// - Returns: Object for the specified type, or nil (see description).
  public func resolve<T>(from bundle: Bundle? = nil) -> T {
    return resolver.resolve(from: bundle)
  }
  
  /// Resolve object by type with tag.
  /// Can crash application, if can't found the type with tag.
  /// But if the type is optional, then the application will not crash, but it returns nil.
  ///
  /// - Parameters:
  ///   - tag: Resolve tag.
  ///   - bundle: Bundle from which to resolve a object
  /// - Returns: Object for the specified type with tag, or nil (see description).
  public func resolve<T, Tag>(tag: Tag.Type, from bundle: Bundle? = nil) -> T {
    return by(tag: tag, on: resolver.resolve(from: bundle))
  }
  
  /// Resolve object by type with name.
  /// Can crash application, if can't found the type with name.
  /// But if the type is optional, then the application will not crash, but it returns nil.
  ///
  /// - Parameters:
  ///   - name: Resolve name.
  ///   - bundle: Bundle from which to resolve a object
  /// - Returns: Object for the specified type with name, or nil (see description).
  public func resolve<T>(name: String, from bundle: Bundle? = nil) -> T {
    return resolver.resolve(name: name, from: bundle)
  }
  
  /// Resolve many objects by type.
  ///
  /// - Returns: Objects for the specified type.
  public func resolveMany<T>() -> [T] {
    return many(resolver.resolve())
  }
  
  /// Injected all dependencies into object.
  /// If the object type couldn't be found, then in logs there will be a warning, and nothing will happen.
  ///
  /// - Parameters:
  ///   - object: object in which injections will be introduced.
  ///   - bundle: Bundle from which to injection into object
  public func inject<T>(into object: T, from bundle: Bundle? = nil) {
    _ = resolver.injection(obj: object, from: bundle)
  }
  
  /// Initialize registered object with lifetime `.single`
  public func initializeSingletonObjects() {
    let singleComponents = componentContainer.components.filter{ .single == $0.lifeTime }
    
    if singleComponents.isEmpty { // for ignore log
      return
    }
    
    log(.verbose, msg: "Begin resolving \(singleComponents.count) singletons", brace: .begin)
    defer { log(.verbose, msg: "End resolving singletons", brace: .end) }
    
    for component in singleComponents {
      resolver.resolveSingleton(component: component)
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


// MARK: - Validation
extension DIContainer {
  
  /// Validate the graph by checking various conditions. For faster performance, set false.
  ///
  /// - Parameter checkGraphCycles: check cycles in the graph of heavy operation. So it can be disabled
  /// - Returns: true if validation success.
  @discardableResult
  public func validate(checkGraphCycles isCheckGraphCycles: Bool = true) -> Bool {
    let components = componentContainer.components
    return checkGraph(components) && (!isCheckGraphCycles || checkGraphCycles(components))
  }
}


// MARK: - validate implementation
extension DIContainer {
  private func plog(_ parameter: MethodSignature.Parameter, msg: String) {
    let level: DILogLevel = parameter.parsedType.optional ? .warning : .error
    log(level, msg: msg)
  }
  
  /// Check graph on presence of all necessary objects. That is, to reach the specified vertices from any vertex
  ///
  /// - Parameter resolver: resolver for use functions from him
  /// - Returns: true if graph is valid, false otherwire
  fileprivate func checkGraph(_ components: [Component]) -> Bool {
    var successfull: Bool = true
    
    for component in components {
      let parameters = component.signatures.flatMap{ $0.parameters }
      let bundle = component.bundle
      
      for parameter in parameters {
        if parameter.parsedType.useObject {
          continue
        }
        
        let candidates = resolver.findComponents(by: parameter.parsedType, with: parameter.name, from: bundle)
        let filtered = resolver.removeWhoDoesNotHaveInitialMethod(components: candidates)
        
        let correct = 1 == filtered.count || parameter.parsedType.hasMany
        let hasCachedLifetime = filtered.isEmpty && candidates.contains{ $0.lifeTime != .prototype }
        let success = correct || parameter.parsedType.hasOptional || hasCachedLifetime
        successfull = successfull && success

        // Log
        if !correct {
          if candidates.isEmpty {
            plog(parameter, msg: "Not found component for \(description(type: parameter.parsedType)) from \(component.info)")
          } else if filtered.isEmpty {
            let infos = candidates.map{ $0.info }

            if hasCachedLifetime {
              log(.info, msg: "Not found component for \(description(type: parameter.parsedType)) from \(component.info) that would have initialization methods, but object can maked from cache. Were found: \(infos)")
            } else {
              plog(parameter, msg: "Not found component for \(description(type: parameter.parsedType)) from \(component.info) that would have initialization methods. Were found: \(infos)")
            }
          } else if filtered.count >= 1 {
            let infos = filtered.map{ $0.info }
            plog(parameter, msg: "Ambiguous \(description(type: parameter.parsedType)) from \(component.info) contains in: \(infos)")
          }
        }
      }
    }

    return successfull
  }

  fileprivate func checkGraphCycles(_ components: [Component]) -> Bool {
    var success: Bool = true
    
    typealias Stack = (component: Component, initial: Bool, cycle: Bool, many: Bool)
    func dfs(for component: Component, visited: Set<Component>, stack: [Stack]) {
      // it's cycle
      if visited.contains(component) {
        func isValidCycle() -> Bool {
          if stack.first!.component != component {
            // but inside -> will find in a another dfs call.
            return true
          }
          
          let infos = stack.dropLast().map{ $0.component.info }
          let short = infos.map{ "\($0.type)" }.joined(separator: " - ")
          
          let allInitials = !stack.contains{ !($0.initial && !$0.many) }
          if allInitials {
            log(.error, msg: "You have a cycle: \(short) consisting entirely of initialization methods. Full: \(infos)")
            return false
          }
          
          let hasGap = stack.contains{ $0.cycle || ($0.initial && $0.many) }
          if !hasGap {
            log(.error, msg: "Cycle has no discontinuities. Please install at least one explosion in the cycle: \(short) using `injection(cycle: true) { ... }`. Full: \(infos)")
            return false
          }
          
          let allPrototypes = !stack.contains{ $0.component.lifeTime != .prototype }
          if allPrototypes {
            log(.error, msg: "You cycle: \(short) consists only of object with lifetime - prototype. Please change at least one object lifetime to another. Full: \(infos)")
            return false
          }
          
          let containsPrototype = stack.contains{ $0.component.lifeTime == .prototype }
          if containsPrototype {
            log(.info, msg: "You cycle: \(short) contains an object with lifetime - prototype. In some cases this can lead to an udesirable effect.  Full: \(infos)")
          }
          
          return true
        }
        
        success = isValidCycle() && success
        return
      }
      
      let bundle = component.bundle
      
      var visited = visited
      visited.insert(component)
      
      
      func callDfs(by parameters: [MethodSignature.Parameter], initial: Bool, cycle: Bool) {
        for parameter in parameters {
          let candidates = resolver.findComponents(by: parameter.parsedType, with: parameter.name, from: bundle)
          if candidates.isEmpty {
            continue
          }
          
          let filtered = candidates.filter {
           (nil != $0.initial || ($0.lifeTime != .prototype && visited.contains($0)))
          }
          let many = parameter.parsedType.hasMany
          for subcomponent in filtered {
            var stack = stack
            stack.append((subcomponent, initial, cycle || parameter.parsedType.hasDelayed, many))
            dfs(for: subcomponent, visited: visited, stack: stack)
          }
        }
      }
      
      if let initial = component.initial {
        callDfs(by: initial.parameters, initial: true, cycle: false)
      }
      
      for injection in component.injections {
        callDfs(by: injection.signature.parameters, initial: false, cycle: injection.cycle)
      }
    }
    
    
    for component in components {
      let stack = [(component, false, false, false)]
      dfs(for: component, visited: [], stack: stack)
    }
    
    return success
  }
}

extension Component {
  fileprivate var signatures: [MethodSignature] {
    var result: [MethodSignature] = []
    
    if let initial = self.initial {
      result.append(initial)
    }
    
    for injection in injections {
      result.append(injection.signature)
    }
    
    return result
  }
}
