//
//  DIRegistrationBuilder.ShortSyntax.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIContainerBuilder {
	public func register<T>(_ initializer: @autoclosure @escaping () -> T) -> DIRegistrationBuilder<T> {
		return DIRegistrationBuilder<T>(self.rTypeContainer, T.self).initializer(initializer)
	}
}
