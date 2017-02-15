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

    let container = registrateAndBuild()
    
    window!.rootViewController = try! container.resolve(UIStoryboard.self).instantiateInitialViewController()
    window!.makeKeyAndVisible()

    return true
  }
  
  func registrateAndBuild() -> DIContainer {
    let builder = DIContainerBuilder()
    
    // Delegate
		builder.register(vc: ViewController.self)
      .as(PopUpDelegate.self).check{$0}
      .as(Observer.self).check{$0} // And Observer
    
    builder.register(vc: PopUpViewController.self)
      .injection { $0.delegate = $1 }
    
    // Observer
    builder.register(vc: ViewControllerFirstObserver.self)
      .as(Observer.self).check{$0}
    
    builder.register(vc: ViewControllerSecondObserver.self)
      .as(Observer.self).check{$0}
    
    builder.register(vc: ViewControllerSlider.self)
      .injection { container, vc in vc.observers = try **container }
    
    
    // Storyboard
    builder.register(type: UIStoryboard.self)
      .lifetime(.single)
      .initial { DIStoryboard(name: "Main", bundle: nil, container: $0) }
    
    return try! builder.build()
  }
  
}

