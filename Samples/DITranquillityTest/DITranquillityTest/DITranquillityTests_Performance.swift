//
//  DITranquillityTests_Performance.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 11/09/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

private class PerformanceParameter {}

private class PerformanceTest {
  init() { }
  
  init(withOne: PerformanceParameter) { }
  init(withTwo: PerformanceParameter, two: PerformanceParameter) { }
  init(withThree: PerformanceParameter, two: PerformanceParameter, three: PerformanceParameter) { }
  init(withEight: PerformanceParameter, two: PerformanceParameter, three: PerformanceParameter, four: PerformanceParameter, five: PerformanceParameter, six: PerformanceParameter, seven: PerformanceParameter, eight: PerformanceParameter) { }
  
  var parameter: PerformanceParameter!
}

class DITranquillityTests_Performance: XCTestCase {
  /*
   register count:
   100 = 0.029
   200 = 0.071
   400 = 0.305
   800 = 1.278
   1000 = 1.781
   2000 = 6.381
   4000 = 27.200
   not linear!!!
   but 1k classes it's more.
   0.0015 per register
   
   parameters count (for 800):
   0 = 1.271
   1 = 1.276
   2 = 1.267
   3 = 1.281
   8 = 1.274
   const
   
   resolve (for 10000):
   perDependency = 0.935
   perScope = 0.759
   single = 0.773
   0.0001 per resolve with one register
   
   resolve by register count (for 10000):
   100 = 0.332
   200 = 0.380
   400 = 0.485
   800 = 0.614
   linear
   resolve type increase on 0.0008 per one register
   
   inject count (for 800):
   1 = 1.274
   2 = 1.285
   4 = 1.290
   8 = 1.297
   16 =  1.300
   log
   increase register time on 0.000003 per injection
   
   */
  
  func test01_registerType() {
    self.measure {
      let builder = DIContainerBuilder()
      for i in 0..<100 {
        builder.register(type: PerformanceTest.self, line: i).initialNotNecessary()
      }
      _ = try! builder.build()
    }
  }
  
  func test01_registerTypeX2() {
    self.measure {
      let builder = DIContainerBuilder()
      for i in 0..<200 {
        builder.register(type: PerformanceTest.self, line: i).initialNotNecessary()
      }
      _ = try! builder.build()
    }
  }
  
  func test01_registerTypeX4() {
    self.measure {
      let builder = DIContainerBuilder()
      for i in 0..<400 {
        builder.register(type: PerformanceTest.self, line: i).initialNotNecessary()
      }
      _ = try! builder.build()
    }
  }
  
  func test01_registerTypeX8() {
    self.measure {
      let builder = DIContainerBuilder()
      for i in 0..<800 {
        builder.register(type: PerformanceTest.self, line: i).initialNotNecessary()
      }
      _ = try! builder.build()
    }
  }
  
  func test02_registerInit() {
    self.measure {
      let builder = DIContainerBuilder()
      for i in 0..<800 {
        builder.register(line: i) { PerformanceTest() }
      }
      _ = try! builder.build()
    }
  }
  
 // one parameter increase time around 0.01sec / 0.62sec = 1.6%
   
  func test02_registerInitWithOne() {
    self.measure {
      let builder = DIContainerBuilder()
      for i in 0..<800 {
        builder.register(line: i) { PerformanceTest(withOne: $0) }
      }
      _ = try! builder.build()
    }
  }
  
  func test02_registerInitWithTwo() {
    self.measure {
      let builder = DIContainerBuilder()
      for i in 0..<800 {
        builder.register(line: i) { PerformanceTest(withTwo: $0, two: $1) }
      }
      _ = try! builder.build()
    }
  }
  
  func test02_registerInitWithThree() {
    self.measure {
      let builder = DIContainerBuilder()
      for i in 0..<800 {
        builder.register(line: i) { PerformanceTest(withThree: $0, two: $1, three: $2) }
      }
      _ = try! builder.build()
    }
  }
  
  func test02_registerInitWithEight() {
    self.measure {
      let builder = DIContainerBuilder()
      for i in 0..<800 {
        builder.register(line: i) { PerformanceTest(withEight: $0, two: $1, three: $2, four: $3, five: $4, six: $5, seven: $6, eight: $7) }
      }
      _ = try! builder.build()
    }
  }
  
  func test03_resolvePrototype() {
    let builder = DIContainerBuilder()
    builder.register{ PerformanceTest() }
      .lifetime(.perDependency)
    let container = try! builder.build()
    
    self.measure {
      for _ in 0..<10000 {
        _ = try! container.resolve() as PerformanceTest
      }
    }
  }
  
  func test03_resolveObjectGraph() {
    let builder = DIContainerBuilder()
    builder.register{ PerformanceTest() }
      .lifetime(.perScope)
    let container = try! builder.build()
    
    self.measure {
      for _ in 0..<10000 {
        _ = try! container.resolve() as PerformanceTest
      }
    }
  }
  
  func test03_resolveSingle() {
    let builder = DIContainerBuilder()
    builder.register{ PerformanceTest() }
      .lifetime(.single)
    let container = try! builder.build()
    
    self.measure {
      for _ in 0..<10000 {
        _ = try! container.resolve() as PerformanceTest
      }
    }
  }
  
  func test04_resolveWithMoreRegister() {
    let builder = DIContainerBuilder()
    for i in 0..<100 {
      builder.register(line: i){ PerformanceTest() }
        .lifetime(.perDependency)
    }
    let container = try! builder.build()
    
    self.measure {
      for _ in 0..<10000 {
        _ = try? container.resolve() as PerformanceTest
      }
    }
  }
  
  func test04_resolveWithMoreRegisterX2() {
    let builder = DIContainerBuilder()
    for i in 0..<200 {
      builder.register(line: i) { PerformanceTest() }
        .lifetime(.perDependency)
    }
    let container = try! builder.build()
    
    self.measure {
      for _ in 0..<10000 {
        _ = try? container.resolve() as PerformanceTest
      }
    }
  }
  
  func test04_resolveWithMoreRegisterX4() {
    let builder = DIContainerBuilder()
    for i in 0..<400 {
      builder.register(line: i) { PerformanceTest() }
        .lifetime(.perDependency)
    }
    let container = try! builder.build()
    
    self.measure {
      for _ in 0..<10000 {
        _ = try? container.resolve() as PerformanceTest
      }
    }
  }
  
  func test04_resolveWithMoreRegisterX8() {
    let builder = DIContainerBuilder()
    for i in 0..<800 {
      builder.register(line: i) { PerformanceTest() }
        .lifetime(.perDependency)
    }
    let container = try! builder.build()
    
    self.measure {
      for _ in 0..<10000 {
        _ = try? container.resolve() as PerformanceTest
      }
    }
  }
  
  func test05_registerInjectX1() {
    self.measure {
      let builder = DIContainerBuilder()
      for i in 0..<800 {
        builder.register(line: i) { PerformanceTest() }
          .injection{ $0.parameter = $1 }
      }
      _ = try! builder.build()
    }
  }
  
  func test05_registerInjectX2() {
    self.measure {
      let builder = DIContainerBuilder()
      for i in 0..<800 {
        builder.register(line: i) { PerformanceTest() }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
      }
      _ = try! builder.build()
    }
  }
  
  func test05_registerInjectX4() {
    self.measure {
      let builder = DIContainerBuilder()
      for i in 0..<800 {
        builder.register(line: i) { PerformanceTest() }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
      }
      _ = try! builder.build()
    }
  }
  
  func test05_registerInjectX8() {
    self.measure {
      let builder = DIContainerBuilder()
      for i in 0..<800 {
        builder.register(line: i) { PerformanceTest() }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
      }
      _ = try! builder.build()
    }
  }
  
  func test05_registerInjectX16() {
    self.measure {
      let builder = DIContainerBuilder()
      for i in 0..<800 {
        let r = builder.register(line: i) { PerformanceTest() }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
        r
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
      }
      _ = try! builder.build()
    }
  }
}
