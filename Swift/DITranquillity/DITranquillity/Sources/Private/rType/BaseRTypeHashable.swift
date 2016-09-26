//
//  BaseRTypeHashable.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

//Hashable
internal class BaseRTypeHashable: Hashable {
  init(implType: Any) {
    self.implType = implType
		self.address = String(describing: Unmanaged.passUnretained(self).toOpaque())
  }

  internal let implType: Any
  internal var hashValue: Int { return uniqueKey.hash }
	internal var uniqueKey: String { return String(describing: implType) + address }
	
	private var address: String!
}

internal func == (lhs: BaseRTypeHashable, rhs: BaseRTypeHashable) -> Bool {
  return lhs.uniqueKey == rhs.uniqueKey
}
