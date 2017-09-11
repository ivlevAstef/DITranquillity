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
   1000 = 0.092
   2000 = 0.190
   4000 = 0.629
   8000 = 2.498
   not linear!!!
   but 1k classes it's more.
   0.00001 per register
   
   parameters count:
   0 = 0.172
   1 = 0.176
   2 = 0.177
   3 = 0.179
   8 = 0.182
   linear - 0.001 sec or 0.5%
   increase register time on 0.0000005 per parameter
   
   resolve:
   prototype = 0.056
   objectGraph = 0.064
   single = 0.053
   0.000005 per resolve with one register
   
   resolve by register count:
   1000 = 0.255
   2000 = 0.523
   4000 = 1.115
   8000 = 2.515
   linear
   resolve type increase on 0.0003 per one register
   
   inject count:
   1 = 0.184
   2 = 0.185
   4 = 0.198
   8 = 0.229
   16 = 0.288
   not linear, but this is not critical
   increase register time on 0.000025 per injection
   
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
      for _ in 0..<10000 {
        _ = container.resolve() as PerformanceTest
      }
    }
  }
  
  func test04_resolveWithMoreRegister() {
    DISetting.Log.fun = nil
    let container = DIContainer()
    for i in 0..<1000 {
      container.register(line: i, { PerformanceTest() })
        .lifetime(.prototype)
    }
    
    self.measure {
      for _ in 0..<10000 {
        _ = container.resolve() as PerformanceTest?
      }
    }
  }
  
  func test04_resolveWithMoreRegisterX2() {
    DISetting.Log.fun = nil
    let container = DIContainer()
    for i in 0..<2000 {
      container.register(line: i, { PerformanceTest() })
        .lifetime(.prototype)
    }
    
    self.measure {
      for _ in 0..<10000 {
        _ = container.resolve() as PerformanceTest?
      }
    }
  }
  
  func test04_resolveWithMoreRegisterX4() {
    DISetting.Log.fun = nil
    let container = DIContainer()
    for i in 0..<4000 {
      container.register(line: i, { PerformanceTest() })
        .lifetime(.prototype)
    }
    
    self.measure {
      for _ in 0..<10000 {
        _ = container.resolve() as PerformanceTest?
      }
    }
  }
  
  func test04_resolveWithMoreRegisterX8() {
    DISetting.Log.fun = nil
    let container = DIContainer()
    for i in 0..<8000 {
      container.register(line: i, { PerformanceTest() })
        .lifetime(.prototype)
    }
    
    self.measure {
      for _ in 0..<10000 {
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
        container.register(line: i, { PerformanceTest() })
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
          .injection{ $0.parameter = $1 }
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
    }
  }
}
