//
//  DIRegistrationBuilder.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIRegistrationBuilder {
  public func initializer<Arg>(method: @escaping (_ scope: DIScope, _ arg: Arg) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg) -> Any in return method(s, arg) }
    return self
  }
  
  public func initializer<Arg, Arg1>(method: @escaping (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg, arg1) -> Any in return method(s, arg, arg1) }
    return self
  }
  
  public func initializer<Arg, Arg1, Arg2>(method: @escaping (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg, arg1, arg2) -> Any in return method(s, arg, arg1, arg2) }
    return self
  }
  
  public func initializer<Arg, Arg1, Arg2, Arg3>(method: @escaping (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg, arg1, arg2, arg3) -> Any in return method(s, arg, arg1, arg2, arg3) }
    return self
  }
  
  public func initializer<Arg, Arg1, Arg2, Arg3, Arg4>(method: @escaping (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg, arg1, arg2, arg3, arg4) -> Any in return method(s, arg, arg1, arg2, arg3, arg4) }
    return self
  }
  
  public func initializer<Arg, Arg1, Arg2, Arg3, Arg4, Arg5>(method: @escaping (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg, arg1, arg2, arg3, arg4, arg5) -> Any in return method(s, arg, arg1, arg2, arg3, arg4, arg5) }
    return self
  }
  
  public func initializer<Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(method: @escaping (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg, arg1, arg2, arg3, arg4, arg5, arg6) -> Any in return method(s, arg, arg1, arg2, arg3, arg4, arg5, arg6) }
    return self
  }
  
  public func initializer<Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(method: @escaping (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg, arg1, arg2, arg3, arg4, arg5, arg6, arg7) -> Any in return method(s, arg, arg1, arg2, arg3, arg4, arg5, arg6, arg7) }
    return self
  }
  
  public func initializer<Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(method: @escaping (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) -> Any in return method(s, arg, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) }
    return self
  }
  
  public func initializer<Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9>(method: @escaping (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9) -> ImplObj) -> Self {
    rType.setInitializer { (s, arg, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) -> Any in return method(s, arg, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) }
    return self
  }
  
}
