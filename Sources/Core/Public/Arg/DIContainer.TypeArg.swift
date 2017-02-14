//
//  DIContainer.TypeArg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIContainer {
  public func resolve<T,A0>(_: T.Type, arg a0:A0, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, type: T.self) { try ($0 as Method)(self, a0) } }
  }
  
  public func resolveMany<T,A0>(_: T.Type, arg a0:A0, f: String = #file, l: Int = #line) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0) throws -> Any
    return try ret(f, l) { try resolver.resolveMany(self, type: T.self) { try ($0 as Method)(self, a0) } }
  }
  
  public func resolve<T,A0>(_: T.Type, name: String, arg a0:A0, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, name: name, type: T.self) { try ($0 as Method)(self, a0) } }
  }
  
  public func resolve<T,A0,A1>(_: T.Type, arg a0:A0,_ a1:A1, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, type: T.self) { try ($0 as Method)(self, a0,a1) } }
  }
  
  public func resolveMany<T,A0,A1>(_: T.Type, arg a0:A0,_ a1:A1, f: String = #file, l: Int = #line) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0,_:A1) throws -> Any
    return try ret(f, l) { try resolver.resolveMany(self, type: T.self) { try ($0 as Method)(self, a0,a1) } }
  }
  
  public func resolve<T,A0,A1>(_: T.Type, name: String, arg a0:A0,_ a1:A1, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, name: name, type: T.self) { try ($0 as Method)(self, a0,a1) } }
  }
  
  public func resolve<T,A0,A1,A2>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, type: T.self) { try ($0 as Method)(self, a0,a1,a2) } }
  }
  
  public func resolveMany<T,A0,A1,A2>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2, f: String = #file, l: Int = #line) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2) throws -> Any
    return try ret(f, l) { try resolver.resolveMany(self, type: T.self) { try ($0 as Method)(self, a0,a1,a2) } }
  }
  
  public func resolve<T,A0,A1,A2>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, name: name, type: T.self) { try ($0 as Method)(self, a0,a1,a2) } }
  }
  
  public func resolve<T,A0,A1,A2,A3>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3) } }
  }
  
  public func resolveMany<T,A0,A1,A2,A3>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3, f: String = #file, l: Int = #line) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3) throws -> Any
    return try ret(f, l) { try resolver.resolveMany(self, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3) } }
  }
  
  public func resolve<T,A0,A1,A2,A3>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, name: name, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3) } }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3,a4) } }
  }
  
  public func resolveMany<T,A0,A1,A2,A3,A4>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4, f: String = #file, l: Int = #line) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4) throws -> Any
    return try ret(f, l) { try resolver.resolveMany(self, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3,a4) } }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, name: name, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3,a4) } }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3,a4,a5) } }
  }
  
  public func resolveMany<T,A0,A1,A2,A3,A4,A5>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5, f: String = #file, l: Int = #line) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5) throws -> Any
    return try ret(f, l) { try resolver.resolveMany(self, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3,a4,a5) } }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, name: name, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3,a4,a5) } }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6) } }
  }
  
  public func resolveMany<T,A0,A1,A2,A3,A4,A5,A6>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6, f: String = #file, l: Int = #line) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6) throws -> Any
    return try ret(f, l) { try resolver.resolveMany(self, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6) } }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, name: name, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6) } }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6,A7>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6,_:A7) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6,a7) } }
  }
  
  public func resolveMany<T,A0,A1,A2,A3,A4,A5,A6,A7>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7, f: String = #file, l: Int = #line) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6,_:A7) throws -> Any
    return try ret(f, l) { try resolver.resolveMany(self, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6,a7) } }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6,A7>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6,_:A7) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, name: name, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6,a7) } }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6,A7,A8>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7,_ a8:A8, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6,_:A7,_:A8) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6,a7,a8) } }
  }
  
  public func resolveMany<T,A0,A1,A2,A3,A4,A5,A6,A7,A8>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7,_ a8:A8, f: String = #file, l: Int = #line) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6,_:A7,_:A8) throws -> Any
    return try ret(f, l) { try resolver.resolveMany(self, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6,a7,a8) } }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6,A7,A8>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7,_ a8:A8, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6,_:A7,_:A8) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, name: name, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6,a7,a8) } }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7,_ a8:A8,_ a9:A9, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6,_:A7,_:A8,_:A9) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6,a7,a8,a9) } }
  }
  
  public func resolveMany<T,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9>(_: T.Type, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7,_ a8:A8,_ a9:A9, f: String = #file, l: Int = #line) throws -> [T] {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6,_:A7,_:A8,_:A9) throws -> Any
    return try ret(f, l) { try resolver.resolveMany(self, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6,a7,a8,a9) } }
  }
  
  public func resolve<T,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9>(_: T.Type, name: String, arg a0:A0,_ a1:A1,_ a2:A2,_ a3:A3,_ a4:A4,_ a5:A5,_ a6:A6,_ a7:A7,_ a8:A8,_ a9:A9, f: String = #file, l: Int = #line) throws -> T {
    typealias Method = (_:DIContainer,_:A0,_:A1,_:A2,_:A3,_:A4,_:A5,_:A6,_:A7,_:A8,_:A9) throws -> Any
    return try ret(f, l) { try resolver.resolve(self, name: name, type: T.self) { try ($0 as Method)(self, a0,a1,a2,a3,a4,a5,a6,a7,a8,a9) } }
  }
  
}
