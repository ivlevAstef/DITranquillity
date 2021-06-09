//
//  ViewController+Children.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 31/08/2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

#if os(iOS) || os(tvOS)
  import UIKit
#elseif os(OSX)
  import Cocoa
#endif

#if os(iOS) || os(tvOS)

  #if swift(>=4.2)
  #else
    extension UIViewController {
      var children: [UIViewController] { return childViewControllers }
    }
  #endif

#elseif os(OSX)

  #if swift(>=4.2)
  #else
    extension NSViewController {
      var children: [NSViewController] { return childViewControllers }
    }
  #endif

#endif
