//
//  DIScanComponent.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

final public class DIScanComponent: DIScan<DIComponent>, DIComponent {
  public static func load(builder: DIContainerBuilder) {
    for component in types {
      builder.register(component: component as! DIComponent.Type)
    }
  }
}
/*
class ScanTest: DIScanComponent {
  override class var predicateByType: PredicateByType? { get { return { _ in true } } }
  override class var bundle: Bundle? { get { return Bundle(for: self) } }
}
*/
