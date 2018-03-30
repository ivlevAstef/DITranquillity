//
//  AppDelegate.swift
//  SampleHabr
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit
import DITranquillity

func dilog(level: DILogLevel, msg: String) {
  switch level {
  case .error:
    print("ERR: " + msg)
  case .warning:
    print("WRN: " + msg)
  case .info:
    print("INF: " + msg)
  case .verbose, .none:
    break
  }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  public func applicationDidFinishLaunching(_ application: UIApplication) {
    DISetting.Log.fun = dilog
    
    let container = DIContainer()
    container.append(framework: AppFramework.self)

    if !container.validate() {
      fatalError()
    }

    container.initializeSingletonObjects()
    
    window = UIWindow(frame: UIScreen.main.bounds)

    let storyboard: UIStoryboard = container.resolve(name: "Main") // Получаем наш Main storyboard
    window!.rootViewController = storyboard.instantiateInitialViewController()
    window!.makeKeyAndVisible()
  }
}
