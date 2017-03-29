//
//  DIContainer.TypeArg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIContainer {
  public func resolve<T,A0>(_: T.Type, arg a0:A0) throws -> T {
    typealias Method = (DIContainer,A0) throws -> Any
    return try resolver.resolve(self, type: T.self){ try ($0 as Method)(self,a0) }
  }
  
  public func resolveMany<T,A0>(_: T.Type, arg a0:A0) throws -> [T] {
    typealias Method = (DIContainer,A0) throws -> Any
    return try resolver.resolveMany(self, type: T.self){ try ($0 as Method)(self,a0) }
  }
  
  public func resolve<T,A0>(_: T.Type, name: String, arg a0:A0) throws -> T {
    typealias Method = (DIContainer,A0) throws -> Any
    return try resolver.resolve(self, name: name, type: T.self){ try ($0 as Method)(self,a0) }
  }
  
  public func resolve<T,A0,A1>(_: T.Type, arg a0:A0,_ a1:A1) throws -> T {
    typealias Method = (DIContainer,A0,A1) throws -> Any
    return try resolver.resolve(self, type: T.self){ try ($0 as Method)(self,a0,a1) }
  }
  
  public func resolveMany<T,A0,A1>(_: T.Type, arg a0:A0,_ a1:A1) throws -> [T] {
    typealias Method = (DIContainer,A0,A1) throws -> Any
    return try resolver.resolveMany(self, type: T.self){ try ($0 as Method)(self,a0,a1) }
  }
  
  public func resolve<T,A0,A1>(_: T.Type, name: String, arg a0:A0,_ a1:A1) throws -> T {
    typealias Method = (DIContainer,A0,A1) throws -> Any
    return try resolver.resolve(self, name: name, type: T.self){ try ($0 as Method)(self,a0,a1) }
  }
  
  public func resolve<T,A0,A1,A2>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2) throws -> T {
    typealias Method = (DIContainer,A0,A1,A2) throws -> Any
    return try resolver.resolve(self, type: T.self){ try ($0 as Method)(self,a0,a1,a2) }
  }
  
  public func resolveMany<T,A0,A1,A2>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2) throws -> [T] {
    typealias Method = (DIContainer,A0,A1,A2) throws -> Any
    return try resolver.resolveMany(self, type: T.self){ try ($0 as Method)(self,a0,a1,a2) }
  }
  
  public func resolve<T,A0,A1,A2>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2) throws -> T {
    typealias Method = (DIContainer,A0,A1,A2) throws -> Any
    return try resolver.resolve(self, name: name, type: T.self){ try ($0 as Method)(self,a0,a1,a2) }
  }
  
  public func resolve<T,A0,A1,A2,A3>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3) throws -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3) throws -> Any
    return try resolver.resolve(self, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3) }
  }
  
  public func resolveMany<T,A0,A1,A2,A3>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3) throws -> [T] {
    typealias Method = (DIContainer,A0,A1,A2,A3) throws -> Any
    return try resolver.resolveMany(self, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3) }
  }
  
  public func resolve<T,A0,A1,A2,A3>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3) throws -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3) throws -> Any
    return try resolver.resolve(self, name: name, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4) throws -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4) throws -> Any
    return try resolver.resolve(self, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3,a4) }
  }
  
  public func resolveMany<T,A0,A1,A2,A3,A4>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4) throws -> [T] {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4) throws -> Any
    return try resolver.resolveMany(self, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3,a4) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4) throws -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4) throws -> Any
    return try resolver.resolve(self, name: name, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3,a4) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5) throws -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4,A5) throws -> Any
    return try resolver.resolve(self, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3,a4,a5) }
  }
  
  public func resolveMany<T,A0,A1,A2,A3,A4,A5>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5) throws -> [T] {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4,A5) throws -> Any
    return try resolver.resolveMany(self, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3,a4,a5) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5) throws -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4,A5) throws -> Any
    return try resolver.resolve(self, name: name, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3,a4,a5) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6) throws -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4,A5,A6) throws -> Any
    return try resolver.resolve(self, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3,a4,a5,a6) }
  }
  
  public func resolveMany<T,A0,A1,A2,A3,A4,A5,A6>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6) throws -> [T] {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4,A5,A6) throws -> Any
    return try resolver.resolveMany(self, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3,a4,a5,a6) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6) throws -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4,A5,A6) throws -> Any
    return try resolver.resolve(self, name: name, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3,a4,a5,a6) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6,A7>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7) throws -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4,A5,A6,A7) throws -> Any
    return try resolver.resolve(self, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3,a4,a5,a6,a7) }
  }
  
  public func resolveMany<T,A0,A1,A2,A3,A4,A5,A6,A7>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7) throws -> [T] {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4,A5,A6,A7) throws -> Any
    return try resolver.resolveMany(self, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3,a4,a5,a6,a7) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6,A7>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7) throws -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4,A5,A6,A7) throws -> Any
    return try resolver.resolve(self, name: name, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3,a4,a5,a6,a7) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6,A7,A8>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7,_ a8:A8) throws -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4,A5,A6,A7,A8) throws -> Any
    return try resolver.resolve(self, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3,a4,a5,a6,a7,a8) }
  }
  
  public func resolveMany<T,A0,A1,A2,A3,A4,A5,A6,A7,A8>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7,_ a8:A8) throws -> [T] {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4,A5,A6,A7,A8) throws -> Any
    return try resolver.resolveMany(self, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3,a4,a5,a6,a7,a8) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6,A7,A8>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7,_ a8:A8) throws -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4,A5,A6,A7,A8) throws -> Any
    return try resolver.resolve(self, name: name, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3,a4,a5,a6,a7,a8) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7,_ a8:A8,_ a9:A9) throws -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9) throws -> Any
    return try resolver.resolve(self, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9) }
  }
  
  public func resolveMany<T,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7,_ a8:A8,_ a9:A9) throws -> [T] {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9) throws -> Any
    return try resolver.resolveMany(self, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7,_ a8:A8,_ a9:A9) throws -> T {
    typealias Method = (DIContainer,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9) throws -> Any
    return try resolver.resolve(self, name: name, type: T.self){ try ($0 as Method)(self,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9) }
  }
  
}
