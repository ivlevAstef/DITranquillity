//
//  DIScanPart.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

open class DIScanPart: DIScan<DIPart>, DIPart {
  public static func load(builder: DIContainerBuilder) {
    for part in types {
      builder.register(part: part as! DIPart.Type)
    }
  }
}
/*
class ScanTest: DIScanComponent {
  override class var predicateByType: PredicateByType? { get { return { _ in true } } }
  override class var bundle: Bundle? { get { return Bundle(for: self) } }
}
*/
