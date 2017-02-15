//
//  AppDelegate.swift
//  SampleHabr
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit
import DITranquillity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  public func applicationDidFinishLaunching(_ application: UIApplication) {
    let builder = DIContainerBuilder()
    builder.register(module: AppModule())
    let container = try! builder.build()
    
    window = UIWindow(frame: UIScreen.main.bounds)

    let storyboard: UIStoryboard = try! container.resolve(name: "Main") // Получаем наш Main storyboard
    window!.rootViewController = storyboard.instantiateInitialViewController()
    window!.makeKeyAndVisible()
  }
}
