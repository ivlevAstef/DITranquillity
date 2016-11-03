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
		builder.register(vc: ViewController.self)
      .asType(PopUpDelegate.self)
      .asType(Observer.self) // And Observer
    
    builder.register(vc: PopUpViewController.self)
      .dependency { (scope, obj) in obj.delegate = *!scope }
    
    // Observer
    builder.register(vc: ViewControllerFirstObserver.self)
      .asType(Observer.self)
    
    builder.register(vc: ViewControllerSecondObserver.self)
      .asType(Observer.self)
    
    builder.register(vc: ViewControllerSlider.self)
      .dependency { (scope, obj) in obj.observers = **!scope }
    
    
    // Storyboard
    builder.register(UIStoryboard.self)
      .lifetime(.single)
      .initializer { scope in DIStoryboard(name: "Main", bundle: nil, container: scope) }
    
    return try! builder.build()
  }
  
}

