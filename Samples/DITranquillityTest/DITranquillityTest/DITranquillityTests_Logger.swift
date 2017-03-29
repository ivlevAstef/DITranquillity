//
//  DITranquillityTests_Logger.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 09/03/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

private class MyLogger: DILogger {
  var logs: [DILogEvent] = []
  
  func log(_ event: DILogEvent, msg: String) {
    logs.append(event)
  }
}

// Tests

let file = #file
class DITranquillityTests_Logger: XCTestCase {
  
  func test01_AddLogger() {
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
  }
}
