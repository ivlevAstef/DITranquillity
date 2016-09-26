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

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)

		let scope = registrateAndBuild()
		
    window!.rootViewController = try! scope.resolve(UIStoryboard).instantiateInitialViewController()
    window!.makeKeyAndVisible()

    return true
  }
	
	func registrateAndBuild() -> DIScope {
		let builder = DIContainerBuilder()
		
		// Delegate
		builder.register(ViewController)
			.asSelf()
			.asType(PopUpDelegate)
			.asType(Observer) // And Observer
			.instancePerRequest()
		
		builder.register(PopUpViewController)
			.instancePerRequest()
			.dependency { (scope, obj) in obj.delegate = *!scope }
		
		// Observer
		builder.register(ViewControllerFirstObserver)
			.asSelf()
			.asType(Observer)
			.instancePerRequest()
		
		builder.register(ViewControllerSecondObserver)
			.asSelf()
			.asType(Observer)
			.instancePerRequest()
		
		builder.register(ViewControllerSlider)
			.instancePerRequest()
			.dependency { (scope, obj) in obj.observers = **!scope }
		
		
		// Storyboard
		builder.register(UIStoryboard)
			.instanceSingle()
			.initializer { scope in DIStoryboard(name: "Main", bundle: nil, container: scope) }
		
		return try! builder.build()
	}
	
}

