//
//  DITranquillityTests_Extensions.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 17/08/2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

private protocol Tag { }

private protocol MyProtocol {
  func empty()
}

private class Class: MyProtocol
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

  func empty() { }
}

private class DepthClass: MyProtocol
{
  let c: Class

  internal init(c: Class) {
    self.c = c
  }

  func empty() { }
}

private class OptionalClass: MyProtocol
{
  let p1: Int?
  let p2: String?
  let p3: Double?

  internal init(p1: Int?, p2: String?, p3: Double?) {
    self.p1 = p1
    self.p2 = p2
    self.p3 = p3
  }

  func empty() { }
}

class DITranquillityTests_Extensions: XCTestCase {

  func test01_Arguments() {
    let container = DIContainer()

    container.register{ "injection" as String }

    container.register{ Class(p1: arg($0), p2: $1, p3: arg($2)) }
      .injection{ $0.p4 = arg($1) }
      .injection(\.p5) { arg($0) }

    let obj: Class = container.resolve(args: 111, 22.2, [1,2,3,4,5], ["H","e","l","l","o"])

    XCTAssertEqual(obj.p1, 111)
    XCTAssertEqual(obj.p2, "injection")
    XCTAssertEqual(obj.p3, 22.2)
    XCTAssertEqual(obj.p4.count, 5)
    XCTAssertEqual(obj.p5.joined(), "Hello")
  }

  func test02_DepthArguments() {
    let container = DIContainer()

    container.register{ 111 as Int }

    container.register{ Class(p1: $0, p2: arg($1), p3: arg($2)) }
      .injection{ $0.p4 = arg($1) }
      .injection(\.p5) { arg($0) }

    container.register(DepthClass.init)

    let obj: DepthClass = container.resolve(
      arguments: AnyArguments(for: Class.self, args: "injection", 22.2, [1,2,3,4,5], ["H","e","l","l","o"]))

    XCTAssertEqual(obj.c.p1, 111)
    XCTAssertEqual(obj.c.p2, "injection")
    XCTAssertEqual(obj.c.p3, 22.2)
    XCTAssertEqual(obj.c.p4.count, 5)
    XCTAssertEqual(obj.c.p5.joined(), "Hello")
  }

  func test03_OptionalArguments() {
    let container = DIContainer()

    container.register{ OptionalClass(p1: arg($0), p2: $1, p3: arg($2)) }

    let obj: OptionalClass = container.resolve(args: nil, 22.2)

    XCTAssertNil(obj.p1)
    XCTAssertNil(obj.p2)
    XCTAssertEqual(obj.p3, 22.2)
  }

  func test04_NotSetOptionalArguments() {
    let container = DIContainer()

    container.register{ OptionalClass(p1: arg($0), p2: $1, p3: arg($2)) }

    let obj: OptionalClass = *container

    XCTAssertNil(obj.p1)
    XCTAssertNil(obj.p2)
    XCTAssertNil(obj.p3)
  }

  func test05_ProtocolArguments() {
    let container = DIContainer()

    container.register{ Class(p1: arg($0), p2: arg($1), p3: arg($2)) }
      .as(MyProtocol.self)

    var arguments = AnyArguments()
    arguments.addArgs(for: MyProtocol.self, args: 11, "test", 15.0)
    let obj: Class = container.resolve(arguments: arguments)

    XCTAssertEqual(obj.p1, 11)
    XCTAssertEqual(obj.p2, "test")
    XCTAssertEqual(obj.p3, 15.0)
  }

  func test06_OptionalClass() {
    let container = DIContainer()

    container.register{ OptionalClass(p1: arg($0), p2: $1, p3: arg($2)) }

    let obj: OptionalClass? = container.resolve(args: nil, 22.2)

    XCTAssertNil(obj?.p1)
    XCTAssertNil(obj?.p2)
    XCTAssertEqual(obj?.p3, 22.2)
  }

  func test06_ManyClass() {
    let container = DIContainer()

    container.register{ OptionalClass(p1: arg($0), p2: $1, p3: arg($2)) }

    let obj: [OptionalClass] = many(container.resolve(args: nil, 22.2))

    XCTAssertEqual(obj.count, 1)
    XCTAssertNil(obj.first?.p1)
    XCTAssertNil(obj.first?.p2)
    XCTAssertEqual(obj.first?.p3, 22.2)
  }

  func test06_TagClass() {
    let container = DIContainer()

    container.register{ Class(p1: arg($0), p2: arg($1), p3: arg($2)) }
      .as(MyProtocol.self, tag: Tag.self)

    var arguments = AnyArguments()
    arguments.addArgs(for: MyProtocol.self, args: 11, "test", 15.0)
    let obj: MyProtocol? = by(tag: Tag.self, on: container.resolve(arguments: arguments))

    XCTAssertEqual((obj as? Class)?.p1, 11)
    XCTAssertEqual((obj as? Class)?.p2, "test")
    XCTAssertEqual((obj as? Class)?.p3, 15.0)
  }

  func test06_NameClass() {
    let container = DIContainer()

    container.register{ Class(p1: arg($0), p2: arg($1), p3: arg($2)) }
      .as(MyProtocol.self, name: "name")

    var arguments = AnyArguments()
    arguments.addArgs(for: MyProtocol.self, args: 11, "test", 15.0)
    let obj: MyProtocol? = container.resolve(name: "name", arguments: arguments)

    XCTAssertEqual((obj as? Class)?.p1, 11)
    XCTAssertEqual((obj as? Class)?.p2, "test")
    XCTAssertEqual((obj as? Class)?.p3, 15.0)
  }
}

