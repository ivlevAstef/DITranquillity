//
//  AppDelegate.swift
//  SampleChaos
//
//  Created by Alexander Ivlev on 09/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit
import DITranquillity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func applicationDidFinishLaunching(_ application: UIApplication) {
    window = UIWindow(frame: UIScreen.main.bounds)

    let container = DIContainer()
    container.append(framework: Framework1.self)
    container.append(part: SampleStartupPart.self)

    if !container.validate() {
      fatalError("Container not valid")
    }

    let storyboard = DIStoryboard.create(name: "Main", bundle: nil, container: container)
    window!.rootViewController = storyboard.instantiateInitialViewController()
    window!.makeKeyAndVisible()
  }
}

