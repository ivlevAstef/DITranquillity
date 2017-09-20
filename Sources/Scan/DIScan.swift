//
//  DIScan.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

/// Protocol to indicate which classes should be included in scan.
/// Don't use this opportunity thoughtlessly - use it only if you don't know in advance number of parts or frameworks in the application.
public protocol DIScanned {}

/// Base class for scan. It doesn't make much sense to inherit from it. see: `DIScanFramework` and `DIScanPart`
open class DIScan {  
  static func types(_ valid: (AnyClass)->Bool, _ predicate: (AnyClass)->Bool, _ bundle: Bundle?) -> [AnyClass] {
    if let bpath = bundle?.bundlePath {
      return scanned.flatMap { cls, clsBPath in
        valid(cls) && bpath == clsBPath && predicate(cls) ? cls : nil
      }
    }
    
    return scanned.flatMap { cls, _ in
      valid(cls) && predicate(cls) ? cls : nil
    }
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
  #if swift(>=4.0)
    let allClasses = UnsafeMutablePointer<AnyClass>.allocate(capacity: Int(expectedClassCount))
    let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(allClasses)
  #else
    let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(expectedClassCount))
    let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass?>(allClasses)
  #endif
  let actualClassCount = Int(objc_getClassList(autoreleasingAllClasses, expectedClassCount))
  
  var result: [(cls: AnyClass, bpath: String)] = []
  for i in 0..<actualClassCount {
    #if swift(>=4.0)
      if allClasses[i] is DIScanned.Type {
        result.append((allClasses[i], Bundle(for: allClasses[i]).bundlePath))
      }
    #else
      if let cls = allClasses[i], cls is DIScanned.Type {
      result.append((cls, Bundle(for: cls).bundlePath))
      }
    #endif
  }
  
  allClasses.deallocate(capacity: Int(expectedClassCount))
  
  return result
}()
