//
//  DIScan.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol DIScanned {}

open class DIScan {  
  static func types(_ valid: (AnyClass)->Bool, _ predicate: (AnyClass)->Bool, _ bundle: Bundle?) -> [AnyClass] {
    let bpathOpt = bundle?.bundlePath
    
    var result: [AnyClass] = []
    for (cls, bpath) in scanned {
      if !valid(cls) {
        continue
      }
      
      if let sbpath = bpathOpt, bpath != sbpath {
        continue
      }
      
      if predicate(cls) {
        result.append(cls)
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
func name(by cls: AnyClass) -> String {
  let name: String = "\(cls)"
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

private let scanned: [(cls: AnyClass, bpath: String)] = {
  let expectedClassCount = objc_getClassList(nil, 0)
  let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(expectedClassCount))
  let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass?>(allClasses)
  let actualClassCount = Int(objc_getClassList(autoreleasingAllClasses, expectedClassCount))

  var result: [(cls: AnyClass, bpath: String)] = []
  for i in 0..<actualClassCount {
    if let cls = allClasses[i], cls is DIScanned.Type {
      result.append((cls, Bundle(for: cls).bundlePath))
    }
  }

  allClasses.deallocate(capacity: Int(expectedClassCount))

  return result
}()
