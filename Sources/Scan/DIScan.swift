//
//  DIScan.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol DIScanned {}

open class DIScan<T> {
  public enum Predicate {
    case type((T.Type)->Bool)
    case name((String)->Bool)
  }
  
  open class var predicate: Predicate? {
    get { return nil }
  }
  
  open class var bundle: Bundle? {
    get { return nil }
  }
  
  
  static var types: [T.Type] {
    let sbpath = bundle?.bundlePath ?? ""
  
    let spredicate: (T.Type)->Bool
    switch predicate {
    case .some(.type(let p)):
      spredicate = p
    case .some(.name(let p)):
      spredicate = { p(name(by: $0)) }
    case .none:
      spredicate = { _ in true }
    }
    
    var result: [T.Type] = []
    for (type, bpath) in scanned {
      if let type = type as? T.Type, bpath == sbpath, spredicate(type) {
        result.append(type)
      }
    }
    return result
  }
}

// Type - for one public/internal
// Type - for class in class (bug?)
// Framework.Type for more public/internal
// (Type in _HASH) for private
// (Type #1) for func class

private let pubCharacters = CharacterSet(charactersIn: ".")
private let inCharacters = CharacterSet(charactersIn: " ()")
private func name<T>(by type: T.Type) -> String {
  let name: String = "\(type)"
  let pubComponents = name.components(separatedBy: pubCharacters)
  if pubComponents.count > 1 {
    return pubComponents.last!
  }
  
  let inComponents = name.components(separatedBy: inCharacters)
  if inComponents.count > 1 {
    return inComponents[1]
  }
  
  return name
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
