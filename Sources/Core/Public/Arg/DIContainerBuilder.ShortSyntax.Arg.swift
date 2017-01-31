//
//  DIContainerBuilder.ShortSyntax.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIContainerBuilder {
  @discardableResult
  public func register<T, P0>(closure: @escaping (_ s: DIScope, _ p0: P0) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(closure: closure)
  }

  @discardableResult
  public func register<T, P0, P1>(closure: @escaping (_ s: DIScope, _ p0: P0, _ p1: P1) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(closure: closure)
  }

  @discardableResult
  public func register<T, P0, P1, P2>(closure: @escaping (_ s: DIScope, _ p0: P0, _ p1: P1, _ p2: P2) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(closure: closure)
  }

  @discardableResult
  public func register<T, P0, P1, P2, P3>(closure: @escaping (_ s: DIScope, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(closure: closure)
  }

  @discardableResult
  public func register<T, P0, P1, P2, P3, P4>(closure: @escaping (_ s: DIScope, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(closure: closure)
  }

  @discardableResult
  public func register<T, P0, P1, P2, P3, P4, P5>(closure: @escaping (_ s: DIScope, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(closure: closure)
  }

  @discardableResult
  public func register<T, P0, P1, P2, P3, P4, P5, P6>(closure: @escaping (_ s: DIScope, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(closure: closure)
  }

  @discardableResult
  public func register<T, P0, P1, P2, P3, P4, P5, P6, P7>(closure: @escaping (_ s: DIScope, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(closure: closure)
  }

  @discardableResult
  public func register<T, P0, P1, P2, P3, P4, P5, P6, P7, P8>(closure: @escaping (_ s: DIScope, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(closure: closure)
  }

  @discardableResult
  public func register<T, P0, P1, P2, P3, P4, P5, P6, P7, P8, P9>(closure: @escaping (_ s: DIScope, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8, _ p9: P9) -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return createBuilder(file: file, line: line).initializer(closure: closure)
  }


  private func createBuilder<T>(file: String, line: Int) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(container: self.rTypeContainer, component: DIComponent(type: T.self, file: file, line: line))
  }

}
