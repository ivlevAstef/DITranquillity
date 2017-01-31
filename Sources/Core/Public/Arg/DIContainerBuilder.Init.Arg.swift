//
//  DIContainerBuilder.Init.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30/01/17.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DIContainerBuilder {
  @discardableResult
  public func register<T, P0, P1>(init initm: @escaping (_ p0: P0, _ p1: P1) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(initm)
  }

  @discardableResult
  public func register<T, P0, P1, P2>(init initm: @escaping (_ p0: P0, _ p1: P1, _ p2: P2) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(initm)
  }

  @discardableResult
  public func register<T, P0, P1, P2, P3>(init initm: @escaping (_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(initm)
  }

  @discardableResult
  public func register<T, P0, P1, P2, P3, P4>(init initm: @escaping (_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(initm)
  }

  @discardableResult
  public func register<T, P0, P1, P2, P3, P4, P5>(init initm: @escaping (_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(initm)
  }

  @discardableResult
  public func register<T, P0, P1, P2, P3, P4, P5, P6>(init initm: @escaping (_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(initm)
  }

  @discardableResult
  public func register<T, P0, P1, P2, P3, P4, P5, P6, P7>(init initm: @escaping (_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(initm)
  }

  @discardableResult
  public func register<T, P0, P1, P2, P3, P4, P5, P6, P7, P8>(init initm: @escaping (_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(initm)
  }

  @discardableResult
  public func register<T, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9>(init initm: @escaping (_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8, _ p9: P9) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(initm)
  }


  private func createBuilder<T>(file: String, line: Int) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(container: self.rTypeContainer, component: DIComponent(type: T.self, file: file, line: line))
  }

}
