//
//  DITranquillityTests_Extensions.swift
//  DITranquillity
//
//  Created by Ивлев Александр Евгеньевич on 17/08/2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

private class Class
{
  let p1: Int
  let p2: String
  let p3: Double
  var p4: [Int] = []
  var p5: [String] = []

  internal init(p1: Int, p2: String, p3: Double) {
    self.p1 = p1
    self.p2 = p2
    self.p3 = p3
  }
}

private class DepthClass
{
  let c: Class

  internal init(c: Class) {
    self.c = c
  }
}

private class OptionalClass
{
  let p1: Int?
  let p2: String?
  let p3: Double?

  internal init(p1: Int?, p2: String?, p3: Double?) {
    self.p1 = p1
    self.p2 = p2
    self.p3 = p3
  }
}

class DITranquillityTests_Extensions: XCTestCase {

  func test01_Arguments() {
    let container = DIContainer()

    container.register{ "injection" as String }

    container.register{ Class(p1: arg($0), p2: $1, p3: arg($2)) }
      .injection{ $0.p4 = arg($1) }
      .injection(\.p5) { arg($0) }

    container.extensions(for: Class.self)?.setArgs(111, 22.2, [1,2,3,4,5], ["H","e","l","l","o"])

    let obj: Class = *container

    XCTAssert(obj.p1 == 111)
    XCTAssert(obj.p2 == "injection")
    XCTAssert(obj.p3 == 22.2)
    XCTAssert(obj.p4.count == 5)
    XCTAssert(obj.p5.joined() == "Hello")
  }

  func test02_DepthArguments() {
    let container = DIContainer()

    container.register{ 111 as Int }

    container.register{ Class(p1: $0, p2: arg($1), p3: arg($2)) }
      .injection{ $0.p4 = arg($1) }
      .injection(\.p5) { arg($0) }

    #if swift(>=3.2)
      container.register1(DepthClass.init)
    #else
      container.register(DepthClass.init)
    #endif


    container.extensions(for: Class.self)?.setArgs("injection", 22.2, [1,2,3,4,5], ["H","e","l","l","o"])

    let obj: DepthClass = *container

    XCTAssert(obj.c.p1 == 111)
    XCTAssert(obj.c.p2 == "injection")
    XCTAssert(obj.c.p3 == 22.2)
    XCTAssert(obj.c.p4.count == 5)
    XCTAssert(obj.c.p5.joined() == "Hello")
  }

  func test03_OptionalArguments() {
    let container = DIContainer()

    container.register{ OptionalClass(p1: arg($0), p2: $1, p3: arg($2)) }

    container.extensions(for: OptionalClass.self)?.setArgs(nil, 22.2)

    let obj: OptionalClass = *container

    XCTAssert(obj.p1 == nil)
    XCTAssert(obj.p2 == nil)
    XCTAssert(obj.p3 == 22.2)
  }

  func test04_NotSetOptionalArguments() {
    let container = DIContainer()

    container.register{ OptionalClass(p1: arg($0), p2: $1, p3: arg($2)) }

    let obj: OptionalClass = *container

    XCTAssert(obj.p1 == nil)
    XCTAssert(obj.p2 == nil)
    XCTAssert(obj.p3 == nil)
  }

}

