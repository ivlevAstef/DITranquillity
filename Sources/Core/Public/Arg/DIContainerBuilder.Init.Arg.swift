//
//  DIContainerBuilder.Init.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30/01/17.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DIContainerBuilder {
  @discardableResult
  public func register<T, A0, A1>(init initm: @escaping (_ a0: A0, _ a1: A1) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(init: initm)
  }

  @discardableResult
  public func register<T, A0, A1, A2>(init initm: @escaping (_ a0: A0, _ a1: A1, _ a2: A2) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(init: initm)
  }

  @discardableResult
  public func register<T, A0, A1, A2, A3>(init initm: @escaping (_ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(init: initm)
  }

  @discardableResult
  public func register<T, A0, A1, A2, A3, A4>(init initm: @escaping (_ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3, _ a4: A4) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(init: initm)
  }

  @discardableResult
  public func register<T, A0, A1, A2, A3, A4, A5>(init initm: @escaping (_ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3, _ a4: A4, _ a5: A5) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(init: initm)
  }

  @discardableResult
  public func register<T, A0, A1, A2, A3, A4, A5, A6>(init initm: @escaping (_ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3, _ a4: A4, _ a5: A5, _ a6: A6) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(init: initm)
  }

  @discardableResult
  public func register<T, A0, A1, A2, A3, A4, A5, A6, A7>(init initm: @escaping (_ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3, _ a4: A4, _ a5: A5, _ a6: A6, _ a7: A7) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(init: initm)
  }

  @discardableResult
  public func register<T, A0, A1, A2, A3, A4, A5, A6, A7, A8>(init initm: @escaping (_ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3, _ a4: A4, _ a5: A5, _ a6: A6, _ a7: A7, _ a8: A8) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(init: initm)
  }

  @discardableResult
  public func register<T, A0, A1, A2, A3, A4, A5, A6, A7, A8, A9>(init initm: @escaping (_ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3, _ a4: A4, _ a5: A5, _ a6: A6, _ a7: A7, _ a8: A8, _ a9: A9) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(init: initm)
  }


  private func createBuilder<T>(file: String, line: Int) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(container: self.rTypeContainer, component: DIComponent(type: T.self, file: file, line: line))
  }

}
