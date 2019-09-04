//
//  BundleContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 06/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

import Foundation

final class BundleContainer {
  private var imports = [DIBundle: Set<DIBundle>]()
  private var mutex = PThreadMutex(normal: ())
  
  final func dependency(bundle: DIBundle, import importBundle: DIBundle) {
    mutex.sync {
      if nil == imports[bundle]?.insert(importBundle) {
        imports[bundle] = [importBundle]
      }
    }
  }
  
  func childs(for bundle: DIBundle) -> Set<DIBundle> {
    return mutex.sync {
      return imports[bundle] ?? []
    }
  }
}
