//
//  Helpers.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 14/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

protocol DITypeGetter {
	static var type: Any.Type { get }
}

extension ImplicitlyUnwrappedOptional: DITypeGetter {
	static var type: Any.Type { return Wrapped.self  }
}

extension Optional: DITypeGetter {
	static var type: Any.Type { return Wrapped.self  }
}

// It's worked but it's no good
func removedTypeWrappers(_ type: Any.Type) -> Any.Type {
	if let typeGetter = type as? DITypeGetter.Type {
		return removedTypeWrappers(typeGetter.type)
	}
	
	return type
}
