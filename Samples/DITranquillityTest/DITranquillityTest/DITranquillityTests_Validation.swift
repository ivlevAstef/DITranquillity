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

private protocol Test2Protocol { }

extension DIComponentInfo {
  init(type: DIAType, file: String, line: Int) {
    self.type = type
    self.file = file
    self.line = line
  }
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

  /*func test01_NotSetInitializer() {
    let container = DIContainer()
    
    let _ = container.register(TestProtocol.self); let line = #line
    
    do {
      try container.build()
    } catch DIError.build(let errors) {
      return
    } catch {
      XCTFail("Catched error: \(error)")
    }
    XCTFail("No try exceptions")
  }
  
  func test03_MultiplyRegistrateTypeWithMultyDefault() {
    let container = DIContainer()
    
    let lineClass1 = #line; container.register(type: TestClass1.self)
      .as(TestProtocol.self).check{$0}
      .set(.default)
      .initial{ TestClass1() }
    
    let lineClass2 = #line; container.register(type: TestClass2.self)
      .as(TestProtocol.self).check{$0}
      .set(.default)
      .initial(TestClass2.init)
    
    
    container.register(type: TestClass1.self)
      .initial(init)
    
    do {
      try container.build()
    } catch DIError.build(let errors) {
      XCTAssertEqual(errors, [
        DIError.pluralDefaultAd(type: TestProtocol.self, typesInfo: [
          DITypeInfo(type: TestClass1.self, file: file, line: lineClass1),
          DITypeInfo(type: TestClass2.self, file: file, line: lineClass2)
        ])
      ])
      return
    } catch {
      XCTFail("Catched error: \(error)")
    }
    XCTFail("No try exceptions")
  }
  
  func test04_MultiplyRegistrateTypeWithOneDefault() {
    let container = DIContainer()
    
    container.register(type: TestClass1.self)
      .as(TestProtocol.self).check{$0}
      .set(.default)
      .initial(TestClass1.init)
    
    container.register(type: TestClass2.self)
      .as(TestProtocol.self).check{$0}
      .initial{ TestClass2() }
    
    do {
      try container.build()
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
  func test05_MultiplyRegistrateTypeWithNames() {
    let container = DIContainer()
    
    container.register(type: TestClass1.self)
      .as(TestProtocol.self).check{$0}
      .set(name: "foo")
      .initial{ TestClass1() }
    
    container.register(type: TestClass2.self)
      .as(TestProtocol.self).check{$0}
      .set(name: "bar")
      .initial{ TestClass2() }
    
    do {
      try container.build()
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
//  func test06_IncorrectRegistrateType() {
//    let container = DIContainer()
//    
//    let line = #line; container.register(type: TestClass1.self)
//      .as(Test2Protocol.self).check{$0} //<---- Swift not supported static check
//      .initial{ TestClass1() }
//    
//    do {
//      let container = try container.build()
//     
//      do {
//        let type: Test2Protocol = try container.resolve()
//        print("\(type)")
//      } catch DIError.typeIsIncorrect(let requestedType, let realType, let typeInfo) {
//        XCTAssert(equals(requestedType, Test2Protocol.self))
//        XCTAssert(equals(realType, TestClass1.self))
//        XCTAssertEqual(typeInfo, DITypeInfo(type: TestClass1.self, file: file, line: line))
//        return
//      } catch {
//        XCTFail("Catched error: \(error)")
//      }
//      XCTFail("No try exceptions")
//    } catch {
//      XCTFail("Catched error: \(error)")
//    }
//  }
  
  func test07_RegistrationByProtocolAndGetByClass() {
    let container = DIContainer()
    
    container.register(type: TestClass1.self)
      .as(TestProtocol.self).unsafe()
      .initial(TestClass1.init)
    
    do {
      let container = try container.build()
      
      
      do {
        let type: TestClass1 = try container.resolve()
        print("\(type)")
      } catch DIError.typeNotFound(let type) {
          XCTAssert(equals(type, TestClass1.self))
          return
      } catch {
        XCTFail("Catched error: \(error)")
        return
      }
      XCTFail("No try exceptions")
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
  func registerForTest(container: DIContainer) {
    container.register(type: TestClass1.init)
  }
  
  func test08_DoubleRegistrationOneLine() {
    let container = DIContainer()
    
    registerForTest(builder: builder)
    registerForTest(builder: builder)
    
    let container = try! container.build()
    
    let type: TestClass1 = try! container.resolve()
    print(type) // ignore
  }

  */
  
  /*  func test01_AddLogger() {
  let myLogger = MyLogger()
  if !DILoggerComposite.add(logger: myLogger) {
  XCTFail("Can't add logger")
  }
  
  if DILoggerComposite.add(logger: myLogger) {
  XCTFail("Double add logger")
  }
  
  let myLogger2 = MyLogger()
  
  if !DILoggerComposite.add(logger: myLogger2) {
  XCTFail("Can't add logger two")
  }
  
  if DILoggerComposite.add(logger: myLogger2) {
  XCTFail("Double add logger two")
  }
  }
  
  func test02_oneObj() {
  let myLogger = MyLogger()
  DILoggerComposite.add(logger: myLogger)
  
  let builder = DIContainerBuilder()
  builder.register(type: FooService.init).lifetime(.perDependency); let line = #line
  
  let container = try! builder.build()
  
  let service: FooService = try! container.resolve()
  print(service.foo()) // ignore
  
  DILoggerComposite.wait()
  XCTAssertEqual(myLogger.logs, [
  .registration,
  .resolving(.begin),
  .found(typeInfo: DITypeInfo(type: FooService.self, file: file, line: line)),
  .resolve(.new),
  .resolving(.end)
  ])
  }
  
  func test03_perScope() {
  let myLogger = MyLogger()
  DILoggerComposite.add(logger: myLogger)
  
  let builder = DIContainerBuilder()
  builder.register(type: FooService.init).lifetime(.perScope); let line = #line
  
  let container = try! builder.build()
  
  let service: FooService = try! container.resolve()
  print(service.foo()) // ignore
  
  DILoggerComposite.wait()
  XCTAssertEqual(myLogger.logs, [
  .registration,
  .resolving(.begin),
  .found(typeInfo: DITypeInfo(type: FooService.self, file: file, line: line)),
  .resolve(.new),
  .cached,
  .resolving(.end)
  ])
  }
  
  
  func test04_single_double() {
  let myLogger = MyLogger()
  DILoggerComposite.add(logger: myLogger)
  
  let builder = DIContainerBuilder()
  builder.register(type: FooService.init).lifetime(.single); let line = #line
  
  let container = try! builder.build()
  
  
  let service: FooService = try! container.resolve()
  print(service.foo()) // ignore
  
  DILoggerComposite.wait()
  XCTAssertEqual(myLogger.logs, [
  .registration,
  .createSingle(.begin),
  .resolving(.begin),
  .found(typeInfo: DITypeInfo(type: FooService.self, file: file, line: line)),
  .resolve(.new),
  .cached,
  .resolving(.end),
  .createSingle(.end),
  
  .resolving(.begin),
  .found(typeInfo: DITypeInfo(type: FooService.self, file: file, line: line)),
  .resolve(.cache),
  .resolving(.end)
  ])
  }
  
  func test05_injection() {
  let myLogger = MyLogger()
  DILoggerComposite.add(logger: myLogger)
  
  let builder = DIContainerBuilder()
  builder.register(type: FooService.init).as(ServiceProtocol.self){$0}.lifetime(.perDependency); let fooline = #line
  builder.register(type: InjectImplicitly.init).injection{ $0.service = $1 }.lifetime(.perDependency); let iline = #line
  
  let container = try! builder.build()
  
  
  let inject: InjectImplicitly = try! container.resolve()
  print(inject.service.foo()) // ignore
  
  DILoggerComposite.wait()
  XCTAssertEqual(myLogger.logs, [
  .registration,
  .registration,
  
  .resolving(.begin),
  .found(typeInfo: DITypeInfo(type: InjectImplicitly.self, file: file, line: iline)),
  .resolve(.new),
  
  .injection(.begin),
  .resolving(.begin),
  .found(typeInfo: DITypeInfo(type: FooService.self, file: file, line: fooline)),
  .resolve(.new),
  .resolving(.end),
  .injection(.end),
  
  .resolving(.end),
  ])
  }
  
  func test07_error() {
  let myLogger = MyLogger()
  DILoggerComposite.add(logger: myLogger)
  
  let builder = DIContainerBuilder()
  builder.register(type: InjectImplicitly.init).injection{ $0.service = $1 }.lifetime(.perDependency); let line = #line
  
  let container = try! builder.build()
  
  
  do {
  let inject: InjectImplicitly = try container.resolve()
  print(inject.service.foo()) // ignore
  XCTFail("resolve incorrect object")
  } catch {
  
  }
  
  DILoggerComposite.wait()
  XCTAssertEqual(myLogger.logs, [
  .registration,
  
  .resolving(.begin),
  .found(typeInfo: DITypeInfo(type: InjectImplicitly.self, file: file, line: line)),
  .resolve(.new),
  
  .injection(.begin),
  .resolving(.begin),
  .error(DIError.typeNotFound(type: ServiceProtocol.self)),
  .resolving(.end),
  .injection(.end),
  
  .resolving(.end),
  ])
  }*/
}
