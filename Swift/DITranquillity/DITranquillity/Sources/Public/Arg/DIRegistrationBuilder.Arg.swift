//
//  DIRegistrationBuilder.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIRegistrationBuilder {
  public func initializer<Arg1>(method: (scope: DIScope, arg1: Arg1) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg1) -> Any in return method(scope: s, arg1: arg1) }
    return self
  }
  
  public func initializer<Arg1, Arg2>(method: (scope: DIScope, arg1: Arg1, arg2: Arg2) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg1, arg2) -> Any in return method(scope: s, arg1: arg1, arg2: arg2) }
    return self
  }
  
  public func initializer<Arg1, Arg2, Arg3>(method: (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg1, arg2, arg3) -> Any in return method(scope: s, arg1: arg1, arg2: arg2, arg3: arg3) }
    return self
  }
  
  public func initializer<Arg1, Arg2, Arg3, Arg4>(method: (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg1, arg2, arg3, arg4) -> Any in return method(scope: s, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4) }
    return self
  }
  
  public func initializer<Arg1, Arg2, Arg3, Arg4, Arg5>(method: (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg1, arg2, arg3, arg4, arg5) -> Any in return method(scope: s, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5) }
    return self
  }
  
  public func initializer<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(method: (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg1, arg2, arg3, arg4, arg5, arg6) -> Any in return method(scope: s, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6) }
    return self
  }
  
  public func initializer<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(method: (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg1, arg2, arg3, arg4, arg5, arg6, arg7) -> Any in return method(scope: s, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7) }
    return self
  }
  
  public func initializer<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(method: (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -> Any in return method(scope: s, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7, arg8: arg8) }
    return self
  }
  
  public func initializer<Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9>(method: (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8, arg9: Arg9) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) -> Any in return method(scope: s, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7, arg8: arg8, arg9: arg9) }
    return self
  }
  
}
