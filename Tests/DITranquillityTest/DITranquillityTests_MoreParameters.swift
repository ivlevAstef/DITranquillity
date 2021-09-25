//
//  DITranquillityTests_MoreParameters.swift
//  DITranquillity-iOS
//
//  Created by Alexander Ivlev on 17/05/2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

private class A1 {}
private class A2 {}
private class A3 {}
private class A4 {}
private class A5 {}
private class A6 {}
private class A7 {}
private class A8 {}
private class A9 {}
private class A10 {}
private class A11 {}
private class A12 {}
private class A13 {}
private class A14 {}
private class A15 {}
private class A16 {}

/// with one parameters have more tests
private class RegTest {
  init() {}
  init(a1: A1, a2: A2) {}
  init(a1: A1, a2: A2, a3: A3) {}
  init(a1: A1, a2: A2, a3: A3, a4: A4) {}
  init(a1: A1, a2: A2, a3: A3, a4: A4, a5: A5) {}
  init(a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6) {}
  init(a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7) {}
  init(a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7, a8: A8) {}
  init(a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7, a8: A8, a9: A9) {}
  init(a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7, a8: A8, a9: A9, a10: A10) {}
  init(a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7, a8: A8, a9: A9, a10: A10, a11: A11) {}
  init(a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7, a8: A8, a9: A9, a10: A10, a11: A11, a12: A12) {}
  init(a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7, a8: A8, a9: A9, a10: A10, a11: A11, a12: A12, a13: A13) {}
  init(a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7, a8: A8, a9: A9, a10: A10, a11: A11, a12: A12, a13: A13, a14: A14) {}
  init(a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7, a8: A8, a9: A9, a10: A10, a11: A11, a12: A12, a13: A13, a14: A14, a15: A15) {}
  init(a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7, a8: A8, a9: A9, a10: A10, a11: A11, a12: A12, a13: A13, a14: A14, a15: A15, a16: A16) {}
}

private class MethodTest {
  init() {}
  func method(a1: A1, a2: A2) {}
  func method(a1: A1, a2: A2, a3: A3) {}
  func method(a1: A1, a2: A2, a3: A3, a4: A4) {}
  func method(a1: A1, a2: A2, a3: A3, a4: A4, a5: A5) {}
  func method(a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6) {}
  func method(a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7) {}
  func method(a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7, a8: A8) {}
}

/// with one parameters have more tests
private class RegArgTest {
    init() {}
    init(arg1: Int, a1: A1) {}
    init(arg1: Int, a1: A1, a2: A2) {}
    init(arg1: Int, a1: A1, a2: A2, a3: A3) {}
    init(arg1: Int, a1: A1, a2: A2, a3: A3, a4: A4) {}
    init(arg1: Int, a1: A1, a2: A2, a3: A3, a4: A4, a5: A5) {}
    init(arg1: Int, a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6) {}
    init(arg1: Int, a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7) {}
    init(arg1: Int, a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7, a8: A8) {}
    init(arg1: Int, a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7, a8: A8, a9: A9) {}
    init(arg1: Int, a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7, a8: A8, a9: A9, a10: A10) {}
    init(arg1: Int, a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7, a8: A8, a9: A9, a10: A10, a11: A11) {}
    init(arg1: Int, a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7, a8: A8, a9: A9, a10: A10, a11: A11, a12: A12) {}
    init(arg1: Int, a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7, a8: A8, a9: A9, a10: A10, a11: A11, a12: A12, a13: A13) {}
    init(arg1: Int, a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7, a8: A8, a9: A9, a10: A10, a11: A11, a12: A12, a13: A13, a14: A14) {}
    init(arg1: Int, a1: A1, a2: A2, a3: A3, a4: A4, a5: A5, a6: A6, a7: A7, a8: A8, a9: A9, a10: A10, a11: A11, a12: A12, a13: A13, a14: A14, a15: A15) {}
}


class DITranquillityTests_MoreParameters: XCTestCase {
  override func setUp() {
    super.setUp()
  }

  private func registerAllClasses(in container: DIContainer) {
    container.register(A1.init)
    container.register(A2.init)
    container.register(A3.init)
    container.register(A4.init)
    container.register(A5.init)
    container.register(A6.init)
    container.register(A7.init)
    container.register(A8.init)
    container.register(A9.init)
    container.register(A10.init)
    container.register(A11.init)
    container.register(A12.init)
    container.register(A13.init)
    container.register(A14.init)
    container.register(A15.init)
    container.register(A16.init)
  }

  private func testRegisterUse(_ regClosure: (_: DIContainer) -> ()) {
    let container = DIContainer()

    registerAllClasses(in: container)
    regClosure(container)

    let test: RegTest? = *container
    XCTAssertNotNil(test)
  }

  private func testMethodUse(_ methodClosure: (_: DIComponentBuilder<MethodTest>) -> ()) {
    let container = DIContainer()

    registerAllClasses(in: container)
    methodClosure(container.register(MethodTest.init))

    let test: MethodTest? = *container
    XCTAssertNotNil(test)
  }

  private func testArgsRegisterUse(_ regClosure: (_: DIContainer) -> ()) {
    let container = DIContainer()

    registerAllClasses(in: container)
    regClosure(container)

    let testWithoutArg: RegArgTest? = container.resolve()
    XCTAssertNil(testWithoutArg)

    let test: RegArgTest? = container.resolve(args: 10)
    XCTAssertNotNil(test)
  }

  func test01() {
    testRegisterUse { $0.register(RegTest.init(a1:a2:)) }
  }
  func test02() {
    testRegisterUse { $0.register(RegTest.init(a1:a2:a3:)) }
  }
  func test03() {
    testRegisterUse { $0.register(RegTest.init(a1:a2:a3:a4:)) }
  }
  func test04() {
    testRegisterUse { $0.register(RegTest.init(a1:a2:a3:a4:a5:)) }
  }
  func test05() {
    testRegisterUse { $0.register(RegTest.init(a1:a2:a3:a4:a5:a6:)) }
  }
  func test06() {
    testRegisterUse { $0.register(RegTest.init(a1:a2:a3:a4:a5:a6:a7:)) }
  }
  func test07() {
    testRegisterUse { $0.register(RegTest.init(a1:a2:a3:a4:a5:a6:a7:a8:)) }
  }
  func test08() {
    testRegisterUse { $0.register(RegTest.init(a1:a2:a3:a4:a5:a6:a7:a8:a9:)) }
  }
  func test09() {
    testRegisterUse { $0.register(RegTest.init(a1:a2:a3:a4:a5:a6:a7:a8:a9:a10:)) }
  }
  func test10() {
    testRegisterUse { $0.register(RegTest.init(a1:a2:a3:a4:a5:a6:a7:a8:a9:a10:a11:)) }
  }
  func test11() {
    testRegisterUse { $0.register(RegTest.init(a1:a2:a3:a4:a5:a6:a7:a8:a9:a10:a11:a12:)) }
  }
  func test12() {
    testRegisterUse { $0.register(RegTest.init(a1:a2:a3:a4:a5:a6:a7:a8:a9:a10:a11:a12:a13:)) }
  }
  func test13() {
    testRegisterUse { $0.register(RegTest.init(a1:a2:a3:a4:a5:a6:a7:a8:a9:a10:a11:a12:a13:a14:)) }
  }
  func test14() {
    testRegisterUse { $0.register(RegTest.init(a1:a2:a3:a4:a5:a6:a7:a8:a9:a10:a11:a12:a13:a14:a15:)) }
  }
  func test15() {
    testRegisterUse { $0.register(RegTest.init(a1:a2:a3:a4:a5:a6:a7:a8:a9:a10:a11:a12:a13:a14:a15:a16:)) }
  }

  func testMethod01() {
    testMethodUse { $0.injection { $0.method(a1: $1, a2: $2) } }
  }
  func testMethod02() {
    testMethodUse { $0.injection { $0.method(a1: $1, a2: $2, a3: $3) } }
  }
  func testMethod03() {
    testMethodUse { $0.injection { $0.method(a1: $1, a2: $2, a3: $3, a4: $4) } }
  }
  func testMethod04() {
    testMethodUse { $0.injection { $0.method(a1: $1, a2: $2, a3: $3, a4: $4, a5: $5) } }
  }
  func testMethod05() {
    testMethodUse { $0.injection { $0.method(a1: $1, a2: $2, a3: $3, a4: $4, a5: $5, a6: $6) } }
  }

  func testMethod06() {
    testMethodUse { $0.injection { $0.method(a1: $1, a2: $2, a3: $3, a4: $4, a5: $5, a6: $6, a7: $7) } }
  }

  func testMethod07() {
    testMethodUse { $0.injection { $0.method(a1: $1, a2: $2, a3: $3, a4: $4, a5: $5, a6: $6, a7: $7, a8: $8) } }
  }

  func testArg00() {
    testArgsRegisterUse { $0.register(RegArgTest.init(arg1:a1:)) { arg($0) } }
  }
  func testArg01() {
    testArgsRegisterUse { $0.register(RegArgTest.init(arg1:a1:a2:)) { arg($0) } }
  }
  func testArg02() {
    testArgsRegisterUse { $0.register(RegArgTest.init(arg1:a1:a2:a3:)) { arg($0) } }
  }
  func testArg03() {
    testArgsRegisterUse { $0.register(RegArgTest.init(arg1:a1:a2:a3:a4:)) { arg($0) } }
  }
  func testArg04() {
    testArgsRegisterUse { $0.register(RegArgTest.init(arg1:a1:a2:a3:a4:a5:)) { arg($0) } }
  }
  func testArg05() {
    testArgsRegisterUse { $0.register(RegArgTest.init(arg1:a1:a2:a3:a4:a5:a6:)) { arg($0) } }
  }
  func testArg06() {
    testArgsRegisterUse { $0.register(RegArgTest.init(arg1:a1:a2:a3:a4:a5:a6:a7:)) { arg($0) } }
  }
  func testArg07() {
    testArgsRegisterUse { $0.register(RegArgTest.init(arg1:a1:a2:a3:a4:a5:a6:a7:a8:)) { arg($0) } }
  }
  func testArg08() {
    testArgsRegisterUse { $0.register(RegArgTest.init(arg1:a1:a2:a3:a4:a5:a6:a7:a8:a9:)) { arg($0) } }
  }
  func testArg09() {
    testArgsRegisterUse { $0.register(RegArgTest.init(arg1:a1:a2:a3:a4:a5:a6:a7:a8:a9:a10:)) { arg($0) } }
  }
  func testArg10() {
    testArgsRegisterUse { $0.register(RegArgTest.init(arg1:a1:a2:a3:a4:a5:a6:a7:a8:a9:a10:a11:)) { arg($0) } }
  }
  func testArg11() {
    testArgsRegisterUse { $0.register(RegArgTest.init(arg1:a1:a2:a3:a4:a5:a6:a7:a8:a9:a10:a11:a12:)) { arg($0) } }
  }
  func testArg12() {
    testArgsRegisterUse { $0.register(RegArgTest.init(arg1:a1:a2:a3:a4:a5:a6:a7:a8:a9:a10:a11:a12:a13:)) { arg($0) } }
  }
  func testArg13() {
    testArgsRegisterUse { $0.register(RegArgTest.init(arg1:a1:a2:a3:a4:a5:a6:a7:a8:a9:a10:a11:a12:a13:a14:)) { arg($0) } }
  }
  func testArg14() {
    testArgsRegisterUse { $0.register(RegArgTest.init(arg1:a1:a2:a3:a4:a5:a6:a7:a8:a9:a10:a11:a12:a13:a14:a15:)) { arg($0) } }
  }

}
