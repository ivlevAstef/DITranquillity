//
//  Main.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 16/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

public class Main {
  public static var container: ScopeProtocol? = nil
  
  public static func autoRegistrate() throws -> ScopeProtocol {
    let startupModuleClasses = getStartupModules()
    
    if startupModuleClasses.isEmpty {
      throw Error.NotFoundStartupModule()
    }
    
    let builder = ContainerBuilder()
    
    for cls in startupModuleClasses {
      builder.registerModule(cls.init())
    }
    
    self.container = try builder.build()
    
    return self.container!
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
      
      if class_getSuperclass(cls) == DIStartupModule.self {
        result.append(cls as! DIStartupModule.Type)
      }
    }
    
    allClasses.dealloc(Int(expectedClassCount))
    
    return result
  }
}