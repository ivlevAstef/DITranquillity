//
//  DITranquillityTests_Performance.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 11/09/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

#if !DEBUG

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
   /// time for core i7-6800K in virtual machine
   register count:
   1000 = 0.040
   2000 = 0.135
   4000 = 0.532
   8000 = 2.217
   not linear!!!
   but 1k classes it's more.
   0.000008 per register
   
   parameters count (for 2000):
   0 = 0.131
   1 = 0.135
   2 = 0.134
   3 = 0.137
   8 = 0.136
   linear - 0.001 sec or 0.5%
   increase register time on 0.0000005 per parameter
   
   resolve (for 50000):
   prototype = 0.101
   objectGraph = 0.264
   single = 0.227
   0.000003 per resolve with one register
   
   resolve by register count (for 50000):
   250 = 0.419
   500 = 0.798
   1000 = 1.607
   2000 = 3.726
   linear
   resolve type increase on 0.0011 (for 50000) per one register
   0.00002 per resolve with 1000 register
   
   inject count (for 2000):
   1 = 0.137
   2 = 0.142
   4 = 0.146
   8 = 0.163
   16 = 0.216
   not linear, but this is not critical
   increase register time on 0.000022 per injection
   
   */
  
  func test01_registerType() {
    DISetting.Log.fun = nil
    self.measure {
      let container = DIContainer()
      for i in 0..<1000 {
        container.register(PerformanceTest.self, line: i)
      }
    }
  }
  
  func test01_registerTypeX2() {
    DISetting.Log.fun = nil
    self.measure {
      let container = DIContainer()
      for i in 0..<2000 {
        container.register(PerformanceTest.self, line: i)
      }
    }
  }
  
  func test01_registerTypeX4() {
    DISetting.Log.fun = nil
    self.measure {
      let container = DIContainer()
      for i in 0..<4000 {
        container.register(PerformanceTest.self, line: i)
      }
    }
  }
  
  func test01_registerTypeX8() {
    DISetting.Log.fun = nil
    self.measure {
      let container = DIContainer()
      for i in 0..<8000 {
        container.register(PerformanceTest.self, line: i)
      }
    }
  }
  
  func test02_registerInit() {
    DISetting.Log.fun = nil
    self.measure {
      let container = DIContainer()
      for i in 0..<2000 {
        container.register(line: i, { PerformanceTest() })
      }
    }
  }
  
 // one parameter increase time around 0.01sec / 0.62sec = 1.6%
   
  func test02_registerInitWithOne() {
    DISetting.Log.fun = nil
    self.measure {
      let container = DIContainer()
      for i in 0..<2000 {
        container.register(line: i, { PerformanceTest(withOne: $0) })
      }
    }
  }
  
  func test02_registerInitWithTwo() {
    DISetting.Log.fun = nil
    self.measure {
      let container = DIContainer()
      for i in 0..<2000 {
        container.register(line: i, { PerformanceTest(withTwo: $0, two: $1) })
      }
    }
  }
  
  func test02_registerInitWithThree() {
    DISetting.Log.fun = nil
    self.measure {
      let container = DIContainer()
      for i in 0..<2000 {
        container.register(line: i, { PerformanceTest(withThree: $0, two: $1, three: $2) })
      }
    }
  }
  
  func test02_registerInitWithEight() {
    DISetting.Log.fun = nil
    self.measure {
      let container = DIContainer()
      for i in 0..<2000 {
        container.register(line: i, { PerformanceTest(withEight: $0, two: $1, three: $2, four: $3, five: $4, six: $5, seven: $6, eight: $7) })
      }
    }
  }
  
  func test03_resolvePrototype() {
    DISetting.Log.fun = nil
    let container = DIContainer()
    container.register{ PerformanceTest() }
      .lifetime(.prototype)
    
    self.measure {
      for _ in 0..<10000 {
        _ = container.resolve() as PerformanceTest
      }
    }
  }
  
  func test03_resolveObjectGraph() {
    DISetting.Log.fun = nil
    let container = DIContainer()
    container.register{ PerformanceTest() }
      .lifetime(.objectGraph)
    
    self.measure {
      for _ in 0..<10000 {
        _ = container.resolve() as PerformanceTest
      }
    }
  }
  
  func test03_resolveSingle() {
    DISetting.Log.fun = nil
    let container = DIContainer()
    container.register{ PerformanceTest() }
      .lifetime(.single)
    
    container.initializeSingletonObjects()
    
    self.measure {
      for _ in 0..<50000 {
        _ = container.resolve() as PerformanceTest
      }
    }
  }
  
  func test04_resolveWithMoreRegister() {
    DISetting.Log.fun = nil
    let container = DIContainer()
    for i in 0..<250 {
      container.register(line: i, { PerformanceTest() })
        .lifetime(.prototype)
    }
    
    self.measure {
      for _ in 0..<50000 {
        _ = container.resolve() as PerformanceTest?
      }
    }
  }
  
  func test04_resolveWithMoreRegisterX2() {
    DISetting.Log.fun = nil
    let container = DIContainer()
    for i in 0..<500 {
      container.register(line: i, { PerformanceTest() })
        .lifetime(.prototype)
    }
    
    self.measure {
      for _ in 0..<50000 {
        _ = container.resolve() as PerformanceTest?
      }
    }
  }
  
  func test04_resolveWithMoreRegisterX4() {
    DISetting.Log.fun = nil
    let container = DIContainer()
    for i in 0..<1000 {
      container.register(line: i, { PerformanceTest() })
        .lifetime(.prototype)
    }
    
    self.measure {
      for _ in 0..<50000 {
        _ = container.resolve() as PerformanceTest?
      }
    }
  }
  
  func test04_resolveWithMoreRegisterX8() {
    DISetting.Log.fun = nil
    let container = DIContainer()
    for i in 0..<2000 {
      container.register(line: i, { PerformanceTest() })
        .lifetime(.prototype)
    }
    
    self.measure {
      for _ in 0..<50000 {
        _ = container.resolve() as PerformanceTest?
      }
    }
  }
  
  func test05_registerInjectX1() {
    DISetting.Log.fun = nil
    
    self.measure {
      let container = DIContainer()
      for i in 0..<2000 {
        container.register(line: i, { PerformanceTest() })
          .injection{ $0.parameter = $1 }
      }
    }
  }
  
  func test05_registerInjectX2() {
    DISetting.Log.fun = nil
    
    self.measure {
      let container = DIContainer()
      for i in 0..<2000 {
        container.register(line: i, { PerformanceTest() })
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
      }
    }
  }
  
  func test05_registerInjectX4() {
    DISetting.Log.fun = nil
    
    self.measure {
      let container = DIContainer()
      for i in 0..<2000 {
        container.register(line: i, { PerformanceTest() })
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
      }
    }
  }
  
  func test05_registerInjectX8() {
    DISetting.Log.fun = nil
    
    self.measure {
      let container = DIContainer()
      for i in 0..<2000 {
        let r = container.register(line: i, { PerformanceTest() })
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
        r
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
      }
    }
  }
  
  func test05_registerInjectX16() {
    DISetting.Log.fun = nil
    
    self.measure {
      let container = DIContainer()
      for i in 0..<2000 {
        let r = container.register(line: i, { PerformanceTest() })
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
        r
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
        r
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
        r
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
      }
    }
  }

  func test07_complex_1000_prototype() {
    DISetting.Log.fun = nil
    GeneratedComplexRegResolve.lifetime = .prototype

    self.measure {
      let container = DIContainer()
      GeneratedComplexRegResolve.register(container: container, count: 500)
      GeneratedComplexRegResolve.resolve(container: container, count: 500)
    }
  }

  func test07_complex_1000_objectGraph() {
    DISetting.Log.fun = nil
    GeneratedComplexRegResolve.lifetime = .objectGraph

    self.measure {
      let container = DIContainer()
      GeneratedComplexRegResolve.register(container: container, count: 1000)
      GeneratedComplexRegResolve.resolve(container: container, count: 1000)
    }
  }
}

#endif
