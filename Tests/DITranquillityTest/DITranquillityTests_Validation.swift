//
//  DITranquillityTests_Validation.swift
//  DITranquillityTests
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

private protocol TestProtocol { }
private class TestClass1: TestProtocol { }
private class TestClass2: TestProtocol { }

private class InjectedClass {
  private let test: TestProtocol
  init(test: TestProtocol) {
    self.test = test
  }
}

private class OptionalInjectedClass {
  init(test: TestProtocol?) {
  }
}

private class SelfInit {
  private let test: SelfInit
  init(_ test: SelfInit) {
    self.test = test
  }
}

private class RInit1 {
  init(_ test: RInit2) { }
}

private class RInit2 {
  init(_ test: RInit3Protocol) { }
}

private protocol RInit3Protocol {}

private class RInit3: RInit3Protocol {
  init(_ test: RInit1) { }
}

private class RInit3Array: RInit3Protocol {
  init(_ test: [RInit1]) { }
}

private class RInit3InjectOptional: RInit3Protocol {
  var test: RInit1?
}

private class RInit3Inject {
  var test: RInit1!
}

private class RCycle {
  init(_ two: RCycle2) {}
}
private class RCycle2 {
  var inject: RCycle!
}


class DITranquillityTests_Build: XCTestCase {
  var file: String { return #file }
  
  static var logs: [(level: DILogLevel, msg: String)] = []
  static func logFunction(level: DILogLevel, msg: String) {
    logs.append((level, msg))
  }
  
  override func setUp() {
    super.setUp()
  }

  func test01_NotSetInitializer() {
    let container = DIContainer()
    
    container.register(TestProtocol.self)
    
    container.register(InjectedClass.init)
    
    XCTAssert(!container.validate())
  }
  
  func test01_NotSetProtocol() {
    let container = DIContainer()
    
    container.register(InjectedClass.init)
    
    XCTAssert(!container.validate())
  }
  
  func test01_NotSetInitializerForClass() {
    let container = DIContainer()
    
    container.register(TestClass1.self)
    
    container.register(InjectedClass.init)
    
    XCTAssert(!container.validate())
  }
  
  func test01_RegistrateOnlyRealization() {
    let container = DIContainer()
    
    container.register(TestClass1.init)
    
    container.register(InjectedClass.init)
    
    XCTAssert(!container.validate())
  }
  
  func test01_RegistrateWithOptional() {
    let container = DIContainer()
    
    container.register(OptionalInjectedClass.init)
    DISetting.Log.level = .warning
    
    XCTAssert(container.validate())
  }
  
  
  func test02_MultiplyRegistrateType() {
    let container = DIContainer()
    
    container.register(TestClass1.init)
      .as(check: TestProtocol.self){$0}
    
    container.register(TestClass2.init)
      .as(check: TestProtocol.self){$0}
    
    container.register(InjectedClass.init)
    
    XCTAssert(!container.validate())
  }
  
  func test02_MultiplyRegistrateTypeWithDefault() {
    let container = DIContainer()
    
    container.register(TestClass1.init)
      .as(check: TestProtocol.self){$0}
      .default()
    
    container.register(TestClass2.init)
      .as(check: TestProtocol.self){$0}
    
    container.register(InjectedClass.init)
    
    XCTAssert(container.validate())
  }
  
  func test02_MultiplyRegistrateTypeWithName() {
    let container = DIContainer()
    
    container.register(TestClass1.init)
      .as(check: TestProtocol.self, name: "undefault"){$0}
    
    container.register(TestClass2.init)
      .as(check: TestProtocol.self){$0}
    
    container.register(InjectedClass.init)
    
    XCTAssert(container.validate())
  }
  
  func test02_MultiplyRegistrateTypeWithTag() {
    let container = DIContainer()
    
    container.register(TestClass1.init)
      .as(check: TestProtocol.self, tag: TestClass1.self){$0}
    
    container.register(TestClass2.init)
      .as(check: TestProtocol.self){$0}
    
    container.register(InjectedClass.init)
    
    XCTAssert(container.validate())
  }
  
  func test04_SelfInit() {
    let container = DIContainer()
    container.register(SelfInit.init)
    
    XCTAssert(!container.validate())
  }
  
  func test04_RecursiveTripleInit() {
    let container = DIContainer()
    
    container.register(RInit1.init)
    container.register(RInit2.init)
    container.register(RInit3.init).as(RInit3Protocol.self)
    
    
    XCTAssert(!container.validate())
  }
  
  func test04_RecursiveTripleInitArray() {
    let container = DIContainer()
    
    container.register(RInit1.init)
    container.register(RInit2.init)
    container.register(RInit3Array.init).as(RInit3Protocol.self)
    
    XCTAssert(!container.validate())
  }
  
  func test04_RecursiveTripleInitArrayWithCorrectLifetime() {
    let container = DIContainer()
    
    container.register(RInit1.init).lifetime(.objectGraph)
    container.register(RInit2.init).lifetime(.objectGraph)
    
    container.register(RInit3Array.init).as(RInit3Protocol.self).lifetime(.objectGraph)
    
    XCTAssert(!container.validate())
  }
  
  func test05_RecursiveTripleInitInject() {
    let container = DIContainer()
    
    container.register(RInit1.init).lifetime(.objectGraph)
    container.register(RInit2.init).lifetime(.objectGraph)
    container.register(RInit3Inject.init)
      .as(RInit3Protocol.self)
      .injection{ $0.test = $1 }
      .lifetime(.objectGraph)
    
    XCTAssert(!container.validate())
  }
  
  func test05_RecursiveTripleInitInjectIsCycleButLifetime() {
    let container = DIContainer()
    
    container.register(RInit1.init)
    container.register(RInit2.init)
    container.register(RInit3Inject.init)
      .as(RInit3Protocol.self)
      .injection{ $0.test = $1 }
    
    XCTAssert(!container.validate())
  }
  
  func test05_RecursiveTripleInitInjectIsCycle() {
    let container = DIContainer()
    
    container.register(RInit1.init).lifetime(.objectGraph)
    container.register(RInit2.init).lifetime(.objectGraph)
    container.register(RInit3Inject.init)
      .as(RInit3Protocol.self)
      .injection(cycle: true) { $0.test = $1 }
      .lifetime(.objectGraph)
    
    XCTAssert(container.validate())
  }
  
  func test05_RecursiveTripleInitInjectOptional() {
    let container = DIContainer()
    
    container.register(RInit1.init).lifetime(.objectGraph)
    container.register(RInit2.init).lifetime(.objectGraph)
    
    container.register(RInit3InjectOptional.init)
      .as(RInit3Protocol.self)
      .injection{ $0.test = $1 }
      .lifetime(.objectGraph)
    
    XCTAssert(!container.validate())
  }
  
  func test06_CycleWithoutInit() {
    let container = DIContainer()
    
    container.register(RCycle.init)
      .lifetime(.prototype)
      
    container.register(RCycle2.self)
      .injection{ $0.inject = $1 }
      .lifetime(.objectGraph)
    
    XCTAssert(!container.validate())
  }
  
}
