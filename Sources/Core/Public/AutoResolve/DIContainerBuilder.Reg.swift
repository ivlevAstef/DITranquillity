//
//  DIContainerBuilder.Reg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/01/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

private typealias MM = MethodMaker

public extension DIContainerBuilder {

  @discardableResult
  public func register<Impl,P0>(file: String = #file, line: Int = #line, _ c: @escaping (P0) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make(by: c))
  }

  @discardableResult
  public func register<Impl,P0,P1>(file: String = #file, line: Int = #line, _ c: @escaping (P0,P1) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make(by: c))
  }

  @discardableResult
  public func register<Impl,P0,P1,P2>(file: String = #file, line: Int = #line, _ c: @escaping (P0,P1,P2) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make(by: c))
  }

  @discardableResult
  public func register<Impl,P0,P1,P2,P3>(file: String = #file, line: Int = #line, _ c: @escaping (P0,P1,P2,P3) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make(by: c))
  }

  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4>(file: String = #file, line: Int = #line, _ c: @escaping (P0,P1,P2,P3,P4) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make(by: c))
  }

  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5>(file: String = #file, line: Int = #line, _ c: @escaping (P0,P1,P2,P3,P4,P5) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make(by: c))
  }

  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6>(file: String = #file, line: Int = #line, _ c: @escaping (P0,P1,P2,P3,P4,P5,P6) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make(by: c))
  }

  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7>(file: String = #file, line: Int = #line, _ c: @escaping (P0,P1,P2,P3,P4,P5,P6,P7) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make(by: c))
  }

  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8>(file: String = #file, line: Int = #line, _ c: @escaping (P0,P1,P2,P3,P4,P5,P6,P7,P8) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make(by: c))
  }

  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9>(file: String = #file, line: Int = #line, _ c: @escaping (P0,P1,P2,P3,P4,P5,P6,P7,P8,P9) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make(by: c))
  }

}
