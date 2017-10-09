//
//  DIScanFramework.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

/// Allows you to find all frameworks marked as `DIScanned` in the application that satisfy certain characteristics:
/// predicate - allows you to check a framework type both by its name or using the type itself
/// Using:
/// ```
/// class YourScanFramework: DIScanFramework {
///   override class var predicate: Predicate? { return .name({ $0.contains("ScannedFramework") }) }
/// }
/// ```
/// OR
/// ```
/// class YourScanFramework: DIScanFramework {
///   override class var predicate: Predicate? { return .type({ $0 is YourCustomFrameworkBase.Type }) }
/// }
/// ```
open class DIScanFramework: DIScan, DIFramework {	
  /// Variants of the predicate on the basis of which these frameworks will be included.
  ///
  /// - type->Bool: Allows you to specify method that will filter a frameworks by type.
  /// - name->Bool: Allows you to specify method that will filter a frameworks by name.
  public enum Predicate {
    case type((DIFramework.Type)->Bool)
    case name((String)->Bool)
  }
  
  /// Predicate on the basis of which these frameworks will be included.
  open class var predicate: Predicate? { return nil }
  
  /// implementation of the function for scan.
  public static func load(container: DIContainer) {
    let inpredicate: (AnyClass)->Bool
    switch predicate {
    case .some(.type(let p)):
      inpredicate = { p($0 as! DIFramework.Type) }
    case .some(.name(let p)):
      inpredicate = { p(name(by: $0 as! DIFramework.Type)) }
    case .none:
      inpredicate = { _ in return true }
    }
    
    for framework in types({ $0 is DIFramework.Type }, inpredicate, nil) {
      container.append(framework: framework as! DIFramework.Type)
    }
  }
}

