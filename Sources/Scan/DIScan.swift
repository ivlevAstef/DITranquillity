//
//  DIScan.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

open class DIScanned {
  public required init() {
  }
}

open class DIScanWithInitializer<T: DIScanned>: DIScan<T> {
  public final func getObjects() -> [T] {
    return getTypes().map{ $0.init() }
  }
}

open class DIScan<T: AnyObject> {
  public typealias PredicateByType = (_ type: T.Type)->(Bool)
  public typealias PredicateByName = (_ name: String)->(Bool)
  
  public init(predicateByType: @escaping PredicateByType) {
    self.predicate = predicateByType
    self.bundle = nil
  }
  
  public init(predicateByType: @escaping PredicateByType, in bundle: Bundle) {
    self.predicate = predicateByType
    self.bundle = bundle
  }
  
  public init(predicateByName: @escaping PredicateByName) {
    self.predicate = { predicateByName(String(describing: $0)) }
    self.bundle = nil
  }
  
  public init(predicateByName: @escaping PredicateByName, in bundle: Bundle) {
    self.predicate = { predicateByName(String(describing: $0)) }
    self.bundle = bundle
  }
  
  public final func getTypes() -> [T.Type] {
    let allTypes = getAllTypes(by: T.self)
    let filterTypes = allTypes.filter{ self.predicate($0) }
    
    guard let bundle = self.bundle else {
      return filterTypes
    }
    
    
    return filterTypes.filter{ Bundle(for: $0).bundlePath == bundle.bundlePath }
  }
  
  private let predicate: PredicateByType
  private let bundle: Bundle?
}

fileprivate func getAllTypes<T>(by supertype: T.Type) -> [T.Type] {
  let expectedClassCount = objc_getClassList(nil, 0)
  let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(expectedClassCount))
  let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass?>(allClasses)
  let actualClassCount:Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)

  var result: [T.Type] = []
  for i in 0 ..< actualClassCount {
    guard let cls: AnyClass = allClasses[Int(i)] else {
      continue
    }
    
    if isSuperClass(cls, for: supertype) {
      result.append(cls as! T.Type)
    }
  }

  allClasses.deallocate(capacity: Int(expectedClassCount))

  return result
}

fileprivate func isSuperClass<T>(_ cls: AnyClass, for type: T.Type) -> Bool {
  if let superClass = class_getSuperclass(cls) {
    return superClass == T.self || isSuperClass(superClass, for: type)
  }
  return false
}
