//
//  DIContainer.TypeArg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DIContainer {
  public func resolve<T,A0>(_: T.Type, arg a0:A0) -> T {
    typealias Method = (DIContainer,A0) -> Any
    return resolver.resolve(self, type: T.self){ ($0 as Method)(self,a0) }
  }
  
  public func resolve<T,A0>(_: T.Type, name: String, arg a0:A0) -> T {
    typealias Method = (DIContainer,A0) -> Any
    return resolver.resolve(self, name: name, type: T.self){ ($0 as Method)(self,a0) }
  }
  
  public func resolve<T,Tag,A0>(_: T.Type, tag: Tag, arg a0:A0) -> T {
    typealias Method = (DIContainer,A0) -> Any
    return resolver.resolve(self, tag: tag, type: T.self){ ($0 as Method)(self,a0) }
  }
  
  public func resolve<T,A0,A1>(_: T.Type, arg a0:A0,_ a1:A1) -> T {
    typealias Method = (DIContainer,A0,A1) -> Any
    return resolver.resolve(self, type: T.self){ ($0 as Method)(self,a0,a1) }
  }
  
  public func resolve<T,A0,A1>(_: T.Type, name: String, arg a0:A0,_ a1:A1) -> T {
    typealias Method = (DIContainer,A0,A1) -> Any
    return resolver.resolve(self, name: name, type: T.self){ ($0 as Method)(self,a0,a1) }
  }
  
  public func resolve<T,Tag,A0,A1>(_: T.Type, tag: Tag, arg a0:A0,_ a1:A1) -> T {
    typealias Method = (DIContainer,A0,A1) -> Any
    return resolver.resolve(self, tag: tag, type: T.self){ ($0 as Method)(self,a0,a1) }
  }
  
  public func resolve<T,A0,A1,A2>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2) -> T {
    typealias Method = (DIContainer,A0,A1,A2) -> Any
    return resolver.resolve(self, type: T.self){ ($0 as Method)(self,a0,a1,a2) }
  }
  
  public func resolve<T,A0,A1,A2>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2) -> T {
    typealias Method = (DIContainer,A0,A1,A2) -> Any
    return resolver.resolve(self, name: name, type: T.self){ ($0 as Method)(self,a0,a1,a2) }
  }
  
  public func resolve<T,Tag,A0,A1,A2>(_: T.Type, tag: Tag, arg a0:A0,_ a1:A1,_ a2:A2) -> T {
    typealias Method = (DIContainer,A0,A1,A2) -> Any
    return resolver.resolve(self, tag: tag, type: T.self){ ($0 as Method)(self,a0,a1,a2) }
  }
  
  public func resolve<T,A0,A1,A2,A3>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3) -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3) -> Any
    return resolver.resolve(self, type: T.self){ ($0 as Method)(self,a0,a1,a2,a3) }
  }
  
  public func resolve<T,A0,A1,A2,A3>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3) -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3) -> Any
    return resolver.resolve(self, name: name, type: T.self){ ($0 as Method)(self,a0,a1,a2,a3) }
  }
  
  public func resolve<T,Tag,A0,A1,A2,A3>(_: T.Type, tag: Tag, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3) -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3) -> Any
    return resolver.resolve(self, tag: tag, type: T.self){ ($0 as Method)(self,a0,a1,a2,a3) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4) -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4) -> Any
    return resolver.resolve(self, type: T.self){ ($0 as Method)(self,a0,a1,a2,a3,a4) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4) -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4) -> Any
    return resolver.resolve(self, name: name, type: T.self){ ($0 as Method)(self,a0,a1,a2,a3,a4) }
  }
  
  public func resolve<T,Tag,A0,A1,A2,A3,A4>(_: T.Type, tag: Tag, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4) -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4) -> Any
    return resolver.resolve(self, tag: tag, type: T.self){ ($0 as Method)(self,a0,a1,a2,a3,a4) }
  }
  
}
