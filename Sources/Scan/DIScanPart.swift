//
//  DIScanPart.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

open class DIScanPart: DIScan, DIPart {
  public enum Predicate {
    case type((DIPart.Type)->Bool)
    case name((String)->Bool)
  }
  
  open class var predicate: Predicate? { return nil }
  open class var bundle: Bundle? { return nil }
  
  public static func load(builder: DIContainerBuilder) {
    let inpredicate: (AnyClass)->Bool
    switch predicate {
    case .some(.type(let p)):
      inpredicate = { p($0 as! DIPart.Type) }
    case .some(.name(let p)):
      inpredicate = { p(name(by: $0 as! DIPart.Type)) }
    case .none:
      inpredicate = { _ in return true }
    }
    
    for part in types({ $0 is DIPart.Type && !($0 is DIFramework.Type) }, inpredicate, bundle) {
      let part = part as! DIPart.Type
      builder.currentBundle = Bundle(for: part)
      part.load(builder: builder)
    }
  }
}
