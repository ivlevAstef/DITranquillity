//
//  AppDelegate.swift
//  CompareSpeedSwinjectVSTranquillity
//
//  Created by Alexander Ivlev on 12/09/2017.
//  Copyright © 2017 SIA. All rights reserved.
//

import UIKit

import DITranquillity
import Swinject
import SwinjectAutoregistration

struct Ref1 {}
struct Ref1_inject {}
struct Ref3_inject {}
struct Ref3_inject2 {}

struct Ref4 {}
struct Ref4_2 {}

class PerformanceParameter1 {
  init(ref: Ref1) { }
  
  var property: Ref1_inject!
}
class PerformanceParameter2 {}
class PerformanceParameter3 {
  var property1: Ref3_inject!
  var property2: Ref3_inject2!
}

class PerformanceParameter4 {
  init(ref1: Ref4, ref2: Ref4_2) {}
}

class PerformanceTest {
  init(one: PerformanceParameter1, two: PerformanceParameter2, three: PerformanceParameter3, four: PerformanceParameter4) { }
  
  var parameter1: PerformanceParameter3!
  var parameter2: PerformanceParameter4!
}

private let TestsCount = 50
private let ResolveCount = 1500
private let useAsync = false

// NEW (3.5.2 vc 2.5.0)
/// iPhone 8 plus, release (register = 128, tests = 200, resolve = 600, async = false)
// Tranquillity time: 5.893729458
// Swinject time: 7.930794125
// SwinjectAutoRegistration time: 9.615140625

/// OLD
/// iPhone 5s, release (tests = 50, resolve = 600, async = false)
/// Tranquillity time: 9.2 (around)
/// Swinject time: 17.2 (around)
/// SwinjectAutoRegistration time: 17.9 (around)

/// iPhoneX simulator, release (tests = 100, resolve = 1000, async = false) on 4x3,24 GHz
/// Tranquillity time: 5.2
/// Swinject time: 18.0
/// SwinjectAutoRegistration time: 14.8

/// iPhoneX simulator, release (tests = 100, resolve = 1000, async = true) on 4x3,24 GHz
/// Tranquillity: Ok
/// Swinject: Crash (not always, but often)
/// """
/// Swinject: Resolution failed. Expected registration:
/// { Service: Ref3_inject2, Factory: (Resolver) -> Ref3_inject2 }
/// Available registrations:
/// { Service: Ref3_inject2, Factory: (Resolver) -> Ref3_inject2, ObjectScope: transient }
/// """



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    DISetting.Log.fun = nil // disable logs
    DISetting.Log.level = .none
    
    DispatchQueue.main.async {
      var start = DispatchTime.now()
      var end = DispatchTime.now()
      
      print("Swinject Start")
      start = DispatchTime.now()
      for _ in 0..<TestsCount {
        self.useSwinject()
      }
      end = DispatchTime.now()
      let time2 = Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000.0
      print("Swinject End")

      print("Tranquillity Start")
      start = DispatchTime.now()
      for _ in 0..<TestsCount {
        self.useTranquillity()
      }
      end = DispatchTime.now()
      let time1 = Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000.0
      print("Tranquillity End")
      
      print("SwinjectAuto Start")
      start = DispatchTime.now()
      for _ in 0..<TestsCount {
        self.useSwinjectAuto()
      }
      end = DispatchTime.now()
      let time3 = Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000.0
      print("SwinjectAuto End")

      print("Tranquillity time: \(time1)")
      print("Swinject time: \(time2)")
      print("SwinjectAutoRegistration time: \(time3)")
    }
    
    return true
  }
  
  private func useTranquillity() {
    let container = DIContainer()
    
    container.register(Ref1.init).lifetime(.prototype)
    container.register(Ref1_inject.init).lifetime(.prototype)
    container.register(Ref3_inject.init).lifetime(.prototype)
    container.register(Ref3_inject2.init).lifetime(.prototype)
    container.register(Ref4.init).lifetime(.prototype)
    container.register(Ref4_2.init).lifetime(.prototype)

    container.register(PerformanceParameter1.init)
      .injection { $0.property = $1 }
      .lifetime(.prototype)

    container.register(PerformanceParameter2.init)
      .lifetime(.prototype)

    container.register(PerformanceParameter3.init)
      .injection { $0.property1 = $1 }
      .injection { $0.property2 = $1 }
      .lifetime(.prototype)

    container.register(PerformanceParameter4.init)
      .lifetime(.prototype)

    container.register(PerformanceTest.init)
      .injection { $0.parameter1 = $1 }
      .injection { $0.parameter2 = $1 }
      .lifetime(.prototype)

    
    if useAsync {
      let group = DispatchGroup()
      
      DispatchQueue.global(qos: .userInteractive).async(group: group) {
        moreTranquillity(container: container)
      }
      
      DispatchQueue.global(qos: .userInitiated).async(group: group) {
        for _ in 0..<ResolveCount {
          _ = container.resolve() as PerformanceTest
        }
      }
      
      DispatchQueue.global(qos: .userInteractive).async(group: group) {
        for _ in 0..<ResolveCount {
          _ = container.resolve() as PerformanceParameter1
        }
      }
      
      DispatchQueue.global(qos: .utility).async(group: group) {
        for _ in 0..<ResolveCount {
          _ = container.resolve() as PerformanceParameter3
        }
      }
      
      group.wait()
    } else {
      moreTranquillity(container: container)
      for _ in 0..<ResolveCount {
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as Ref1
        _ = container.resolve() as PerformanceTest
        _ = container.resolve() as PerformanceParameter1
        _ = container.resolve() as PerformanceParameter3
        _ = container.resolve() as PerformanceParameter4
      }
    }
  }
  
  private func useSwinject() {
    let container = Container()
    
    container.register(Ref1.self) { _ in Ref1() }.inObjectScope(.transient)
    container.register(Ref1_inject.self) { _ in Ref1_inject() }.inObjectScope(.transient)
    container.register(Ref3_inject.self) { _ in Ref3_inject() }.inObjectScope(.transient)
    container.register(Ref3_inject2.self) { _ in Ref3_inject2() }.inObjectScope(.transient)
    container.register(Ref4.self) { _ in Ref4() }.inObjectScope(.transient)
    container.register(Ref4_2.self) { _ in Ref4_2() }.inObjectScope(.transient)

    container.register(PerformanceParameter1.self) { r in
      let obj = PerformanceParameter1(ref: r.resolve(Ref1.self)!)
      obj.property = r.resolve(Ref1_inject.self)!
      return obj
    }.inObjectScope(.transient)

    container.register(PerformanceParameter2.self) { _ in
      PerformanceParameter2()
    }.inObjectScope(.transient)

    container.register(PerformanceParameter3.self) { r in
      let obj = PerformanceParameter3()
      obj.property1 = r.resolve(Ref3_inject.self)!
      obj.property2 = r.resolve(Ref3_inject2.self)!
      return obj
    }.inObjectScope(.transient)

    container.register(PerformanceParameter4.self) { r in
      return PerformanceParameter4(ref1: r.resolve(Ref4.self)!, ref2: r.resolve(Ref4_2.self)!)
    }.inObjectScope(.transient)

    container.register(PerformanceTest.self) { r in
      let obj = PerformanceTest(one: r.resolve(PerformanceParameter1.self)!, two: r.resolve(PerformanceParameter2.self)!, three: r.resolve(PerformanceParameter3.self)!, four: r.resolve(PerformanceParameter4.self)!)
      obj.parameter1 = r.resolve(PerformanceParameter3.self)!
      obj.parameter2 = r.resolve(PerformanceParameter4.self)!
      return obj
    }.inObjectScope(.transient)

    
    if useAsync {
      let group = DispatchGroup()
      
      DispatchQueue.global(qos: .userInteractive).async(group: group) {
        moreSwinject(container: container)
      }
      
      DispatchQueue.global(qos: .userInitiated).async(group: group) {
        for _ in 0..<ResolveCount {
          _ = container.resolve(PerformanceTest.self)!
        }
      }
      
      DispatchQueue.global(qos: .userInteractive).async(group: group) {
        for _ in 0..<ResolveCount {
          _ = container.resolve(PerformanceParameter1.self)!
        }
      }
      
      DispatchQueue.global(qos: .utility).async(group: group) {
        for _ in 0..<ResolveCount {
          _ = container.resolve(PerformanceParameter3.self)!
        }
      }
      
      group.wait()
    } else {
      moreSwinject(container: container)
      for _ in 0..<ResolveCount {
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!

        _ = container.resolve(PerformanceTest.self)!
        _ = container.resolve(PerformanceParameter1.self)!
        _ = container.resolve(PerformanceParameter3.self)!
        _ = container.resolve(PerformanceParameter4.self)!
      }
    }
  }
  
  private func useSwinjectAuto() {
    let container = Container()
    
    container.autoregister(Ref1.self, initializer: Ref1.init).inObjectScope(.transient)
    container.autoregister(Ref1_inject.self, initializer: Ref1_inject.init).inObjectScope(.transient)
    container.autoregister(Ref3_inject.self, initializer: Ref3_inject.init).inObjectScope(.transient)
    container.autoregister(Ref3_inject2.self, initializer: Ref3_inject2.init).inObjectScope(.transient)
    container.autoregister(Ref4.self, initializer: Ref4.init).inObjectScope(.transient)
    container.autoregister(Ref4_2.self, initializer: Ref4_2.init).inObjectScope(.transient)

    container.autoregister(PerformanceParameter1.self, initializer: PerformanceParameter1.init)
      .initCompleted{ $1.property = $0.resolve(Ref1_inject.self)! }
      .inObjectScope(.transient)

    container.autoregister(PerformanceParameter2.self, initializer: PerformanceParameter2.init)
      .inObjectScope(.transient)

    container.autoregister(PerformanceParameter3.self, initializer: PerformanceParameter3.init)
      .initCompleted {
        $1.property1 = $0.resolve(Ref3_inject.self)!
        $1.property2 = $0.resolve(Ref3_inject2.self)!
      }
      .inObjectScope(.transient)

    container.autoregister(PerformanceParameter4.self, initializer: PerformanceParameter4.init)
      .inObjectScope(.transient)

    container.autoregister(PerformanceTest.self, initializer: PerformanceTest.init)
      .initCompleted {
        $1.parameter1 = $0.resolve(PerformanceParameter3.self)!
        $1.parameter2 = $0.resolve(PerformanceParameter4.self)!
      }
      .inObjectScope(.transient)

    if useAsync {
      let group = DispatchGroup()
      
      DispatchQueue.global(qos: .userInteractive).async(group: group) {
        moreAutoSwinject(container: container)
      }
      
      DispatchQueue.global(qos: .userInitiated).async(group: group) {
        for _ in 0..<ResolveCount {
          _ = container.resolve(PerformanceTest.self)!
        }
      }
      
      DispatchQueue.global(qos: .userInteractive).async(group: group) {
        for _ in 0..<ResolveCount {
          _ = container.resolve(PerformanceParameter1.self)!
        }
      }
      
      DispatchQueue.global(qos: .utility).async(group: group) {
        for _ in 0..<ResolveCount {
          _ = container.resolve(PerformanceParameter3.self)!
        }
      }
      
      group.wait()
    } else {
      moreAutoSwinject(container: container)
      for _ in 0..<ResolveCount {
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(Ref1.self)!
        _ = container.resolve(PerformanceTest.self)!
        _ = container.resolve(PerformanceParameter1.self)!
        _ = container.resolve(PerformanceParameter3.self)!
        _ = container.resolve(PerformanceParameter4.self)!
      }
    }
  }

}

