//
//  DIContainerBuilder.ShortSyntax.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIContainerBuilder {
  @discardableResult
  public func register<T, Arg>(initializer: @escaping (_ scope: DIScope, _ arg: Arg) -> T) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(self.rTypeContainer, T.self).initializer(method: initializer)
  }

  @discardableResult
  public func register<T, Arg, Arg1>(initializer: @escaping (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1) -> T) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(self.rTypeContainer, T.self).initializer(method: initializer)
  }

  @discardableResult
  public func register<T, Arg, Arg1, Arg2>(initializer: @escaping (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2) -> T) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(self.rTypeContainer, T.self).initializer(method: initializer)
  }

  @discardableResult
  public func register<T, Arg, Arg1, Arg2, Arg3>(initializer: @escaping (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> T) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(self.rTypeContainer, T.self).initializer(method: initializer)
  }

  @discardableResult
  public func register<T, Arg, Arg1, Arg2, Arg3, Arg4>(initializer: @escaping (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) -> T) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(self.rTypeContainer, T.self).initializer(method: initializer)
  }

  @discardableResult
  public func register<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5>(initializer: @escaping (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) -> T) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(self.rTypeContainer, T.self).initializer(method: initializer)
  }

  @discardableResult
  public func register<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(initializer: @escaping (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6) -> T) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(self.rTypeContainer, T.self).initializer(method: initializer)
  }

  @discardableResult
  public func register<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(initializer: @escaping (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7) -> T) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(self.rTypeContainer, T.self).initializer(method: initializer)
  }

  @discardableResult
  public func register<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(initializer: @escaping (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8) -> T) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(self.rTypeContainer, T.self).initializer(method: initializer)
  }

  @discardableResult
  public func register<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9>(initializer: @escaping (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9) -> T) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(self.rTypeContainer, T.self).initializer(method: initializer)
  }

}
