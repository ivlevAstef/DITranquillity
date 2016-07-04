//
//  DIMain.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 16/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

internal class DIMain {
  internal static let single: DIMain = DIMain()
  
  internal var container: DIScope
  
  private init() {
    let startupModuleClasses = DIMain.getStartupModules()
    
    assert(!startupModuleClasses.isEmpty, "Not found startup module")
    
    let builder = DIContainerBuilder()
    
    for cls in startupModuleClasses {
      builder.registerModule(cls.init())
    }
    
    do {
      self.container = try builder.build()
    } catch {
      fatalError("Can't build with error: \(error)")
    }
  }
  
  
  private static func getStartupModules() -> [DIStartupModule.Type] {
    let expectedClassCount = objc_getClassList(nil, 0)
    let allClasses = UnsafeMutablePointer<AnyClass?>.alloc(Int(expectedClassCount))
    let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass?>(allClasses)
    let actualClassCount:Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)
    
    var result: [DIStartupModule.Type] = []
    for i in 0 ..< actualClassCount {
      guard let cls: AnyClass = allClasses[Int(i)] else {
        continue
      }
      
      if checkClassOnStartupModule(cls) {
        result.append(cls as! DIStartupModule.Type)
      }
    }
    
    allClasses.dealloc(Int(expectedClassCount))
    
    return result
  }
  
  private static func checkClassOnStartupModule(cls: AnyClass) -> Bool {
    return class_getSuperclass(cls) == DIStartupModule.self
  }
}