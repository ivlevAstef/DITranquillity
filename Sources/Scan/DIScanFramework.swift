//
//  DIScanFramework.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

open class DIScanFramework: DIScan, DIFramework {
  public enum Predicate {
    case type((DIFramework.Type)->Bool)
    case name((String)->Bool)
  }
  
  open class var predicate: Predicate? { return nil }
  open class var bundle: Bundle? { return nil }
  
  public static func load(builder: DIContainerBuilder) {
    let inpredicate: (AnyClass)->Bool
    switch predicate {
    case .some(.type(let p)):
      inpredicate = { p($0 as! DIFramework.Type) }
    case .some(.name(let p)):
      inpredicate = { p(name(by: $0 as! DIFramework.Type)) }
    case .none:
      inpredicate = { _ in return true }
    }
    
    for framework in types({ $0 is DIFramework.Type }, inpredicate, bundle) {
      let framework = framework as! DIFramework.Type
      builder.currentBundle = Bundle(for: framework)
      framework.load(builder: builder)
    }
  }
}

