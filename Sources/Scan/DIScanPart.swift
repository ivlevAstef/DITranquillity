//
//  DIScanPart.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

/// Allows you to find all parts marked as `DIScanned` in the application that satisfy certain characteristics:
/// predicate - allows you to check a part type both by its name or using the type itself
/// bundle - leaves only those parts that are in the specified bundle
/// Using:
/// ```
/// class YourScanPart: DIScanPart {
///   override class var predicate: Predicate? { return .name({ $0.contains("ScannedPart") }) }
///   override class var bundle: Bundle? { return YourBundle() }
/// }
/// ```
/// OR
/// ```
/// class YourScanPart: DIScanPart {
///   override class var predicate: Predicate? { return .type({ $0 is YourCustomPartBase.Type }) }
///   override class var bundle: Bundle? { return Bundle(for: YourClass.self) }
/// }
/// ```
open class DIScanPart: DIScan, DIPart {
  /// Variants of the predicate on the basis of which these parts will be included.
  ///
  /// - type->Bool: Allows you to specify method that will filter a parts by type.
  /// - name->Bool: Allows you to specify method that will filter a parts by name.
  public enum Predicate {
    case type((DIPart.Type)->Bool)
    case name((String)->Bool)
  }
  
  /// Predicate on the basis of which these parts will be included.
  open class var predicate: Predicate? { return nil }
  
  /// It allows you to cut off parts not belonging to the specified bundle.
  open class var bundle: Bundle? { return nil }
  
  /// implementation of the function for scan.
  public static func load(container: DIContainer) {
    let inpredicate: (AnyClass)->Bool
    switch predicate {
    case .some(.type(let p)):
      inpredicate = { p($0 as! DIPart.Type) }
    case .some(.name(let p)):
      inpredicate = { p(name(by: $0 as! DIPart.Type)) }
    case .none:
      inpredicate = { _ in return true }
    }
    
    for part in types({ $0 is DIPart.Type }, inpredicate, bundle) {
      container.append(part: part as! DIPart.Type)
    }
  }
}
