//
//  DIContainerBuilder.Register.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30/01/17.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DIContainerBuilder {
  @discardableResult
  public func register<T, P0>(type initial: @escaping (_:P0) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

  @discardableResult
  public func register<T, P0,P1>(type initial: @escaping (_:P0,_:P1) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

  @discardableResult
  public func register<T, P0,P1,P2>(type initial: @escaping (_:P0,_:P1,_:P2) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

  @discardableResult
  public func register<T, P0,P1,P2,P3>(type initial: @escaping (_:P0,_:P1,_:P2,_:P3) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

  @discardableResult
  public func register<T, P0,P1,P2,P3,P4>(type initial: @escaping (_:P0,_:P1,_:P2,_:P3,_:P4) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

  @discardableResult
  public func register<T, P0,P1,P2,P3,P4,P5>(type initial: @escaping (_:P0,_:P1,_:P2,_:P3,_:P4,_:P5) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

  @discardableResult
  public func register<T, P0,P1,P2,P3,P4,P5,P6>(type initial: @escaping (_:P0,_:P1,_:P2,_:P3,_:P4,_:P5,_:P6) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

  @discardableResult
  public func register<T, P0,P1,P2,P3,P4,P5,P6,P7>(type initial: @escaping (_:P0,_:P1,_:P2,_:P3,_:P4,_:P5,_:P6,_:P7) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

  @discardableResult
  public func register<T, P0,P1,P2,P3,P4,P5,P6,P7,P8>(type initial: @escaping (_:P0,_:P1,_:P2,_:P3,_:P4,_:P5,_:P6,_:P7,_:P8) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

  @discardableResult
  public func register<T, P0,P1,P2,P3,P4,P5,P6,P7,P8,P9>(type initial: @escaping (_:P0,_:P1,_:P2,_:P3,_:P4,_:P5,_:P6,_:P7,_:P8,_:P9) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }

}
