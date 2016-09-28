//
//  AppDelegate.swift
//  SampleDelegateAndObserver
//
//  Created by Alexander Ivlev on 08/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit
import DITranquillity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)

    let scope = registrateAndBuild()
    
    window!.rootViewController = try! scope.resolve(UIStoryboard.self).instantiateInitialViewController()
    window!.makeKeyAndVisible()

    return true
  }
  
  func registrateAndBuild() -> DIScope {
    let builder = DIContainerBuilder()
    
    // Delegate
    builder.register(ViewController.self)
      .asSelf()
      .asType(PopUpDelegate.self)
      .asType(Observer.self) // And Observer
      .instancePerRequest()
    
    builder.register(PopUpViewController.self)
      .instancePerRequest()
      .dependency { (scope, obj) in obj.delegate = *!scope }
    
    // Observer
    builder.register(ViewControllerFirstObserver.self)
      .asSelf()
      .asType(Observer.self)
      .instancePerRequest()
    
    builder.register(ViewControllerSecondObserver.self)
      .asSelf()
      .asType(Observer.self)
      .instancePerRequest()
    
    builder.register(ViewControllerSlider.self)
      .instancePerRequest()
      .dependency { (scope, obj) in obj.observers = **!scope }
    
    
    // Storyboard
    builder.register(UIStoryboard.self)
      .instanceSingle()
      .initializer { scope in DIStoryboard(name: "Main", bundle: nil, container: scope) }
    
    return try! builder.build()
  }
  
}

