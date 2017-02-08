//
//  DIContainer.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIContainer {
  public func resolve<T,A0>(arg a0:A0) throws -> T {
    typealias Method = (_:DIContainer,_:A0) -> Any
    return try resolver.resolve(self, type: T.self) { ($0 as Method)(self, a0) }
  }
  
  public func resolveMany<T,A0>(arg a0:A0) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0) -> Any
    return try resolver.resolveMany(self, type: T.self) { ($0 as Method)(self, a0) }
  }
  
  public func resolve<T,A0>(name: String, arg a0:A0) throws -> T {
    typealias Method = (_:DIContainer,_:A0) -> Any
    return try resolver.resolve(self, name: name, type: T.self) { ($0 as Method)(self, a0) }
  }
  
  public func resolve<T,A0,A1>(arg a0:A0,_ a1:A1) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1) -> Any
    return try resolver.resolve(self, type: T.self) { ($0 as Method)(self, a0,a1) }
  }
  
  public func resolveMany<T,A0,A1>(arg a0:A0,_ a1:A1) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0,_:A1) -> Any
    return try resolver.resolveMany(self, type: T.self) { ($0 as Method)(self, a0,a1) }
  }
  
  public func resolve<T,A0,A1>(name: String, arg a0:A0,_ a1:A1) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1) -> Any
    return try resolver.resolve(self, name: name, type: T.self) { ($0 as Method)(self, a0,a1) }
  }
  
  public func resolve<T,A0,A1,A2>(arg a0:A0,_ a1:A1,_ a2:A2) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2) -> Any
    return try resolver.resolve(self, type: T.self) { ($0 as Method)(self, a0,a1,a2) }
  }
  
  public func resolveMany<T,A0,A1,A2>(arg a0:A0,_ a1:A1,_ a2:A2) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2) -> Any
    return try resolver.resolveMany(self, type: T.self) { ($0 as Method)(self, a0,a1,a2) }
  }
  
  public func resolve<T,A0,A1,A2>(name: String, arg a0:A0,_ a1:A1,_ a2:A2) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2) -> Any
    return try resolver.resolve(self, name: name, type: T.self) { ($0 as Method)(self, a0,a1,a2) }
  }
  
  public func resolve<T,A0,A1,A2,A3>(arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3) -> Any
    return try resolver.resolve(self, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3) }
  }
  
  public func resolveMany<T,A0,A1,A2,A3>(arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3) -> Any
    return try resolver.resolveMany(self, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3) }
  }
  
  public func resolve<T,A0,A1,A2,A3>(name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3) -> Any
    return try resolver.resolve(self, name: name, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4>(arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4) -> Any
    return try resolver.resolve(self, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3,a4) }
  }
  
  public func resolveMany<T,A0,A1,A2,A3,A4>(arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4) -> Any
    return try resolver.resolveMany(self, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3,a4) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4>(name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4) -> Any
    return try resolver.resolve(self, name: name, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3,a4) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5>(arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5) -> Any
    return try resolver.resolve(self, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3,a4,a5) }
  }
  
  public func resolveMany<T,A0,A1,A2,A3,A4,A5>(arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5) -> Any
    return try resolver.resolveMany(self, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3,a4,a5) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5>(name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5) -> Any
    return try resolver.resolve(self, name: name, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3,a4,a5) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6>(arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6) -> Any
    return try resolver.resolve(self, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6) }
  }
  
  public func resolveMany<T,A0,A1,A2,A3,A4,A5,A6>(arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6) -> Any
    return try resolver.resolveMany(self, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6>(name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6) -> Any
    return try resolver.resolve(self, name: name, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6,A7>(arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6,_:A7) -> Any
    return try resolver.resolve(self, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6,a7) }
  }
  
  public func resolveMany<T,A0,A1,A2,A3,A4,A5,A6,A7>(arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6,_:A7) -> Any
    return try resolver.resolveMany(self, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6,a7) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6,A7>(name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6,_:A7) -> Any
    return try resolver.resolve(self, name: name, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6,a7) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6,A7,A8>(arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7,_ a8:A8) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6,_:A7,_:A8) -> Any
    return try resolver.resolve(self, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6,a7,a8) }
  }
  
  public func resolveMany<T,A0,A1,A2,A3,A4,A5,A6,A7,A8>(arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7,_ a8:A8) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6,_:A7,_:A8) -> Any
    return try resolver.resolveMany(self, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6,a7,a8) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6,A7,A8>(name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7,_ a8:A8) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6,_:A7,_:A8) -> Any
    return try resolver.resolve(self, name: name, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6,a7,a8) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9>(arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7,_ a8:A8,_ a9:A9) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6,_:A7,_:A8,_:A9) -> Any
    return try resolver.resolve(self, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6,a7,a8,a9) }
  }
  
  public func resolveMany<T,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9>(arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7,_ a8:A8,_ a9:A9) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6,_:A7,_:A8,_:A9) -> Any
    return try resolver.resolveMany(self, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6,a7,a8,a9) }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9>(name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7,_ a8:A8,_ a9:A9) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6,_:A7,_:A8,_:A9) -> Any
    return try resolver.resolve(self, name: name, type: T.self) { ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6,a7,a8,a9) }
  }
  
}
