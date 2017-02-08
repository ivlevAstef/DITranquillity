//
//  DIResolver.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class DIResolver {
  init(rTypeContainer: RTypeContainerFinal) {
    self.rTypeContainer = rTypeContainer
  }
	
	@discardableResult
	func check<T>(type: T.Type) throws -> [RTypeFinal] {
		let rTypes = try getTypes(type)
		
		if rTypes.count > 1 && !rTypes.contains(where: { $0.isDefault }) {
			throw DIError.defaultTypeIsNotSpecified(type: type, typesInfo: rTypes.map{ $0.typeInfo })
		}
		
		return rTypes
	}
	
	@discardableResult
	func check<T>(name: String, type: T.Type) throws -> [RTypeFinal] {
		let rTypes = try getTypes(type)
		
		if !rTypes.contains(where: { $0.has(name: name)}) {
			throw DIError.typeIsNotFoundForName(type: type, name: name, typesInfo: rTypes.map { $0.typeInfo })
		}
		
		return rTypes
	}
	
	func resolve<T, Method>(_ container: DIContainer, type: T.Type, method: @escaping (Method) -> Any) throws -> T {
		let rTypes = try check(type: type)

		let index = rTypes.count <= 1 ? 0 : rTypes.index(where: { $0.isDefault })!
    return try resolveUseRType(container, pair: RTypeWithName(rTypes[index]), method: method)
  }

  func resolveMany<T, Method>(_ container: DIContainer, type: T.Type, method: @escaping (Method) -> Any) throws -> [T] {
    let rTypes = try getTypes(type)

    var result: [T] = []
    for rType in rTypes {
      do {
        try result.append(resolveUseRType(container, pair: RTypeWithName(rType), method: method))
      } catch DIError.recursiveInitialization {
        // Ignore recursive initialization object for many
      } catch {
        throw error
      }
    }

    return result
  }

  func resolve<T, Method>(_ container: DIContainer, name: String, type: T.Type, method: @escaping (Method) -> Any) throws -> T {
		let rTypes = try check(name: name, type: type)

		let rType = rTypes.first(where: { $0.has(name: name) })!
    return try resolveUseRType(container, pair: RTypeWithName(rType, name), method: method)
  }

  func resolve<Method>(_ container: DIContainer, rType: RTypeFinal, method: @escaping (Method) -> Any) throws -> Any {
    return try resolveUseRType(container, pair: RTypeWithName(rType), method: method)
  }

  private func getTypes<T>(_ inputType: T.Type) throws -> [RTypeFinal] {
    let type = removeTypeWrappers(inputType)

    guard let rTypes = rTypeContainer[type], !rTypes.isEmpty else {
      throw DIError.typeIsNotFound(type: inputType)
    }

    return rTypes
  }

	private func resolveUseRType<T, Method>(_ container: DIContainer, pair: RTypeWithName, method: @escaping (Method) -> Any) throws -> T {
    objc_sync_enter(DIResolver.monitor)
    defer { objc_sync_exit(DIResolver.monitor) }

    switch pair.rType.lifeTime {
    case .single:
      return try resolveSingle(container, pair: pair, method: method)
    case .lazySingle:
      return try resolveSingle(container, pair: pair, method: method)
    case .weakSingle:
      return try resolveWeakSingle(container, pair: pair, method: method)
    case .perScope:
      return try resolvePerScope(container, pair: pair, method: method)
    case .perDependency:
      return try resolvePerDependency(container, pair: pair, method: method)
    }
  }

  private func resolveSingle<T, Method>(_ container: DIContainer, pair: RTypeWithName, method: @escaping (Method) -> Any) throws -> T {
    if let obj = Cache.single[pair.uniqueKey] {
      return obj as! T
    }

    let obj: T = try resolvePerDependency(container, pair: pair, method: method)
    Cache.single[pair.uniqueKey] = obj
    return obj
  }
  
  private func resolveWeakSingle<T, Method>(_ container: DIContainer, pair: RTypeWithName, method: @escaping (Method) -> Any) throws -> T {
    for data in Cache.weakSingle.filter({ $0.value.value == nil }) {
      Cache.weakSingle.removeValue(forKey: data.key)
    }
    
    if let obj = Cache.weakSingle[pair.uniqueKey]?.value {
      return obj as! T
    }
    
    let obj: T = try resolvePerDependency(container, pair: pair, method: method)
    Cache.weakSingle[pair.uniqueKey] = Weak(value: obj)
    return obj
  }

  private func resolvePerScope<T, Method>(_ container: DIContainer, pair: RTypeWithName, method: @escaping (Method) -> Any) throws -> T {
    if let obj = container.scope[pair.uniqueKey] {
      return obj as! T
    }

    let obj: T = try resolvePerDependency(container, pair: pair, method: method)
    container.scope[pair.uniqueKey] = obj
    return obj
  }

  private func resolvePerDependency<T, Method>(_ container: DIContainer, pair: RTypeWithName, method: @escaping (Method) -> Any) throws -> T {
    if recursiveInitializer.contains(pair.uniqueKey) {
      throw DIError.recursiveInitialization(typeInfo: pair.rType.typeInfo)
    }

    for recursiveTypeKey in circular.recursive {
      circular.dependencies.append(key: pair.uniqueKey, value: recursiveTypeKey)
    }

    let insertIndex = circular.objects.endIndex

    circular.recursive.append(pair.uniqueKey)
    let obj: T = try getObject(pair: pair, method: method)
    circular.recursive.removeLast()

    if !circular.objects.contains(where: { $0.1 as AnyObject === obj as AnyObject }) {
      circular.objects.insert((pair, obj), at: insertIndex)
    }

    if circular.recursive.isEmpty {
      setupAllDependency(container)
    }

    return obj
  }

  private func setupDependency(_ container: DIContainer, pair: RTypeWithName, obj: Any) {
    let mapSave = circular.objMap

    circular.recursive.append(pair.uniqueKey)
    for index in 0..<pair.rType.injections.count {
      circular.objMap = mapSave
      pair.rType.injections[index](container, obj)
    }
    circular.recursive.removeLast()
  }

  private func setupAllDependency(_ container: DIContainer) {
    repeat {
      for (pair, obj) in circular.objects {
        setupDependency(container, pair: pair, obj: obj)
        circular.objects.removeFirst()
      }
    } while (!circular.objects.isEmpty) // because setupDependency can added into allTypes

    circular.clean()
  }

  private func getObject<T, Method>(pair: RTypeWithName, method: @escaping (Method) -> Any) throws -> T {
    if circular.isCycle(pair: pair), let obj = circular.objMap[pair.uniqueKey] {
      return obj as! T
    }

		let objAny: Any
		if let specialMethod = (method as Any) as? () -> Any {
			objAny = specialMethod()
		} else {
			recursiveInitializer.insert(pair.uniqueKey)
			objAny = try pair.rType.new(method)
			recursiveInitializer.remove(pair.uniqueKey)
		}

    guard let obj = objAny as? T else {
      throw DIError.typeIsIncorrect(requestedType: T.self, realType: type(of: objAny), typeInfo: pair.typeInfo)
    }

    circular.objMap[pair.uniqueKey] = obj

    return obj
  }
  
  private let rTypeContainer: RTypeContainerFinal

  // needed for block call self from self
  private var recursiveInitializer: Set<RType.UniqueKey> = []

  // needed for circular
  private class Circular {
    fileprivate var objects: [(RTypeWithName, Any)] = []
    fileprivate var recursive: [RType.UniqueKey] = []
    fileprivate var dependencies = DIMultimap<RType.UniqueKey, RType.UniqueKey>()
    fileprivate var objMap: [RType.UniqueKey: Any] = [:]
    
    fileprivate func clean() {
      objects.removeAll()
      dependencies.removeAll()
      objMap.removeAll()
    }
    
    fileprivate func isCycle(pair: RTypeWithName) -> Bool {
      return recursive.contains { dependencies[$0].contains(pair.uniqueKey) }
    }
  }
  private let circular = Circular()
  

  private class Cache {
    fileprivate static var single: [RType.UniqueKey: Any] = [:]
    fileprivate static var weakSingle: [RType.UniqueKey: Weak] = [:]
  }
  
  // thread save
  private static let monitor = NSObject()
}
