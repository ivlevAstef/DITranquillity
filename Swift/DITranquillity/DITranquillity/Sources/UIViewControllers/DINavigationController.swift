//
//  DINavigationController.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 04/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

public class DINavigationController: UINavigationController {
  public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
    super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    try! DIScopeMain.resolve(self)
  }
  
  public override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
    try! DIScopeMain.resolve(self)
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    try! DIScopeMain.resolve(self)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    try! DIScopeMain.resolve(self)
  }
}