//
//  DIContainerBuilder.Register.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30/01/17.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DIContainerBuilder {
  @discardableResult
  public func register<T, P0>(file: String = #file, line: Int = #line, type initial: @escaping (P0) -> T) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

  @discardableResult
  public func register<T, P0,P1>(file: String = #file, line: Int = #line, type initial: @escaping (P0,P1) -> T) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

  @discardableResult
  public func register<T, P0,P1,P2>(file: String = #file, line: Int = #line, type initial: @escaping (P0,P1,P2) -> T) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

  @discardableResult
  public func register<T, P0,P1,P2,P3>(file: String = #file, line: Int = #line, type initial: @escaping (P0,P1,P2,P3) -> T) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

  @discardableResult
  public func register<T, P0,P1,P2,P3,P4>(file: String = #file, line: Int = #line, type initial: @escaping (P0,P1,P2,P3,P4) -> T) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

  @discardableResult
  public func register<T, P0,P1,P2,P3,P4,P5>(file: String = #file, line: Int = #line, type initial: @escaping (P0,P1,P2,P3,P4,P5) -> T) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

  @discardableResult
  public func register<T, P0,P1,P2,P3,P4,P5,P6>(file: String = #file, line: Int = #line, type initial: @escaping (P0,P1,P2,P3,P4,P5,P6) -> T) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

  @discardableResult
  public func register<T, P0,P1,P2,P3,P4,P5,P6,P7>(file: String = #file, line: Int = #line, type initial: @escaping (P0,P1,P2,P3,P4,P5,P6,P7) -> T) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

  @discardableResult
  public func register<T, P0,P1,P2,P3,P4,P5,P6,P7,P8>(file: String = #file, line: Int = #line, type initial: @escaping (P0,P1,P2,P3,P4,P5,P6,P7,P8) -> T) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

  @discardableResult
  public func register<T, P0,P1,P2,P3,P4,P5,P6,P7,P8,P9>(file: String = #file, line: Int = #line, type initial: @escaping (P0,P1,P2,P3,P4,P5,P6,P7,P8,P9) -> T) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

}
