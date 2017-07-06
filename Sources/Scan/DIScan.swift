//
//  DIScan.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol DIScanned {}

open class DIScan<T> {
  public typealias PredicateByType = (_ type: T.Type)->(Bool)
  public typealias PredicateByName = (_ name: String)->(Bool)
  
  open class var predicateByType: PredicateByType? {
    get { return nil }
  }
  
  open class var predicateByName: PredicateByName? {
    get { return nil }
  }
  
  open class var bundle: Bundle? {
    get { return nil }
  }
  
  public static var types: [T.Type] {
    let sbpath = bundle?.bundlePath ?? ""
    let spredicate = predicateByType ?? predicateByName.map{ p in { p(name(by: $0)) } } ?? { _ in true }
    
    var result: [T.Type] = []
    for (type, bpath) in scanned {
      if let type = type as? T.Type, bpath == sbpath, spredicate(type) {
        result.append(type)
      }
    }
    return result
  }
}

private func name<T>(by type: T.Type) -> String {
  var fullName: String = "\(type)"
  
  if "(" == fullName[fullName.startIndex] {
    fullName.remove(at: fullName.startIndex)
  }
  
  let range = fullName.range(of: " in")
  if let range = range {
    return fullName.substring(to: range.lowerBound)
  }
  return fullName
}

private let scanned: [(type: DIScanned.Type, bpath: String)] = {
  let expectedClassCount = objc_getClassList(nil, 0)
  let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(expectedClassCount))
  let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass?>(allClasses)
  let actualClassCount = Int(objc_getClassList(autoreleasingAllClasses, expectedClassCount))

  var result: [(type: DIScanned.Type, bpath: String)] = []
  for i in 0..<actualClassCount {
    if let cls = allClasses[i], let type = cls as? DIScanned.Type {
      result.append((type, Bundle(for: cls).bundlePath))
    }
  }

  allClasses.deallocate(capacity: Int(expectedClassCount))

  return result
}()
