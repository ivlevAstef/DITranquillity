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

    DISetting.Log.level = .info
    let container = registrateAndBuild()
    
    window!.rootViewController = (*container as UIStoryboard).instantiateInitialViewController()
    window!.makeKeyAndVisible()

    return true
  }
  
  func registrateAndBuild() -> DIContainer {
    let builder = DIContainerBuilder()
    
    // Delegate
		builder.register(ViewController.self)
      .lifetime(.weakSingle)
      .as(check: PopUpDelegate.self){$0}
      .as(check: Observer.self){$0} // And Observer
    
    builder.register(PopUpViewController.self)
      .injection { $0.delegate = $1 }
    
    // Observer
    builder.register(ViewControllerFirstObserver.self)
      .lifetime(.weakSingle)
      .as(check: Observer.self){$0}
    
    builder.register(ViewControllerSecondObserver.self)
      .lifetime(.weakSingle)
      .as(check: Observer.self){$0}
    
    builder.register(ViewControllerSlider.self)
      .injection { $0.observers = many($1) }
    
    
    // Storyboard
    builder.registerStoryboard(name: "Main", bundle: nil)
      .lifetime(.single)
    
    return try! builder.build()
  }
  
}

