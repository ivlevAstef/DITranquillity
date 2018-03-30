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
        let container = DIContainer()
        register(container: container)

        if !container.validate() {
            fatalError()
        }

        let storyboard: NSStoryboard = *container

        let viewController = storyboard.instantiateInitialController() as! NSViewController

        #if swift(>=4.0)
            let window = NSApplication.shared.windows.first
        #else
            let window = NSApplication.shared().windows.first
        #endif
        window?.contentViewController = viewController
    }

    private func register(container: DIContainer) {
        container.registerStoryboard(name: "ViewControllers", bundle: nil)

        container.register(ViewController.self)
            .injection { $0.buttonName = "Next" }

        container.register(NextViewController.self)
            .injection { $0.inject = 10 }

    }
}

