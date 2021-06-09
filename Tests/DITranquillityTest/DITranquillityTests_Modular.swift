//
//  DITranquillityTests_Modular.swift
//  DITranquillityTests
//
//  Created by Alexander Ivlev on 17/02/2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

private class C1 {}
private class F1: DIFramework {
  static func load(container: DIContainer) {
    container.append(framework: F2.self)
    container.append(framework: F2_2.self)
    container.register(C1.init)
  }
}

private class C2 {}
private class F2: DIFramework {
  static func load(container: DIContainer) {
    container.append(framework: F3.self)
    container.import(F2_2.self)
    container.register(C2.init)
  }
}

private class C2_2 {}
private class F2_2: DIFramework {
  static func load(container: DIContainer) {
    container.register(C2_2.init)
  }
}

private class C3 {}
private class F3: DIFramework {
  static func load(container: DIContainer) {
    container.append(part: P1.self)
    container.append(part: P2.self)
    container.register(C3.init)
  }
}

private class CP1 {}
private class P1: DIPart {
  static func load(container: DIContainer) {
    container.register(CP1.init)
  }
}

private class CP2 {}
private class P2: DIPart {
  static func load(container: DIContainer) {
    container.register(CP2.init)
  }
}

class DITranquillityTests_Modular: XCTestCase {
  override func setUp() {
    super.setUp()
  }

  func test01_only_check_code() {
    // Only for validate code works, and add codecoverage... not check hard cases
    let container = DIContainer()

    container.append(framework: F1.self)

    let p1: CP1? = container.resolve()
    let p2: CP2? = container.resolve()

    XCTAssertNotNil(p1)
    XCTAssertNotNil(p2)
  }
}
