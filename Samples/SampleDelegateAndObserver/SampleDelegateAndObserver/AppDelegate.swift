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
    let container = DIContainer()
    
    // Delegate
    container.register(ViewController.self)
      .lifetime(.perRun(.weak))
      .as(check: PopUpDelegate.self){$0}
      .as(check: Observer.self){$0} // And Observer
    
    container.register(PopUpViewController.self)
      .injection { $0.delegate = $1 }
    
    // Observer
    container.register(ViewControllerFirstObserver.self)
      .lifetime(.perRun(.weak))
      .as(check: Observer.self){$0}
    
    container.register(ViewControllerSecondObserver.self)
      .lifetime(.perRun(.weak))
      .as(check: Observer.self){$0}
    
    container.register(ViewControllerSlider.self)
      .injection { $0.observers = many($1) }
    
    
    // Storyboard
    container.registerStoryboard(name: "Main", bundle: nil)
      .lifetime(.single)

    if !container.validate() {
      fatalError()
    }

    return container
  }
  
}

