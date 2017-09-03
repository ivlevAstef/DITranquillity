//
//  BundleContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 06/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

final class BundleContainer {
  private var imports = [HashableBundle: Set<HashableBundle>]()
  
  final func dependency(bundle: Bundle, import importBundle: Bundle) {
    let hbundle = HashableBundle(bundle: bundle)
    let himportBundle = HashableBundle(bundle: importBundle)
    
    if nil == imports[hbundle]?.insert(himportBundle) {
      imports[hbundle] = [himportBundle]
    }
  }
  
  func childs(for bundle: Bundle) -> [Bundle] {
    return imports[HashableBundle(bundle: bundle)]?.map{ $0.bundle } ?? []
  }
  
  static func compare(_ bundle1: Bundle, _ bundle2: Bundle) -> Bool {
    return HashableBundle(bundle: bundle1) == HashableBundle(bundle: bundle2)
  }
}

private final class HashableBundle: Hashable {
  fileprivate let bundle: Bundle
	private var identifier: String
	
	fileprivate init(bundle: Bundle) {
		self.bundle = bundle
		self.identifier = bundle.bundleIdentifier ?? bundle.bundlePath
	}
	
  var hashValue: Int { return identifier.hashValue }
  
  static func ==(lhs: HashableBundle, rhs: HashableBundle) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}
