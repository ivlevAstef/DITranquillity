//
//  DIScan.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public class DIScanned {
  public required init() {
  }
}

public class DIScan<T: DIScanned> {
  public typealias PredicateByType = (_ type: T.Type)->(Bool)
  public typealias PredicateByName = (_ name: String)->(Bool)

  public init(predicateByType: @escaping PredicateByType, in bundle: Bundle? = nil) {
    self.predicate = predicateByType
    self.bundle = bundle
  }

  public init(predicateByName: @escaping PredicateByName, in bundle: Bundle? = nil) {
    self.predicate = { predicateByName(String(describing: $0)) }
    self.bundle = bundle
  }

  func getObjects() -> [T] {
    return getTypes().map{ $0() }
  }

  private func getTypes() -> [T.Type] {
    let allTypes = Helpers.getTypes(by: T.self)
    let filterTypes = allTypes.filter{ self.predicate($0) }

    guard let bundle = self.bundle else {
      return filterTypes
    }

    return filterTypes.filter { Bundle(for: $0).bundlePath == bundle.bundlePath }
  }

  private let predicate: Predicate
  private let bundle: Bundle?
}

fileprivate func getTypes<T>(by supertype: T.Type) -> [T.Type] {
  let expectedClassCount = objc_getClassList(nil, 0)
  let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(Int(expectedClassCount))
  let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass?>(allClasses)
  let actualClassCount:Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)

  var result: [T.Type] = []
  for i in 0 ..< actualClassCount {
    guard let cls: AnyClass = allClasses[Int(i)] else {
      continue
    }
    
    if class_getSuperclass(cls) == T.self {
      result.append(cls as! T.Type)
    }
  }

  allClasses.deallocate(Int(expectedClassCount))

  return result
}