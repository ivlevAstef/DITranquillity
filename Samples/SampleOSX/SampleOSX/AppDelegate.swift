//
//  AppDelegate.swift
//  SampleOSX
//
//  Created by Alexander Ivlev on 04.10.16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Cocoa
import DITranquillity

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		let builder = DIContainerBuilder()
		register(builder: builder)
		let container = try! builder.build()
		
		let storyboard: NSStoryboard = *container
		
		let viewController = storyboard.instantiateInitialController() as! NSViewController
		
		let window = NSApplication.shared().windows.first
		window?.contentViewController = viewController
	}	
	
	private func register(builder: DIContainerBuilder) {
    builder.registerStoryboard(name: "ViewControllers", bundle: nil)
		
		builder.register(ViewController.self)
			.injection { $0.buttonName = "Next" }
		
		builder.register(NextViewController.self)
			.injection { $0.inject = 10 }
		
	}


}

