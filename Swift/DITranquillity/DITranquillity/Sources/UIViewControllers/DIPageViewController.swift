//
//  DIPageViewController.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 04/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

public class DIPageViewController: UIPageViewController {
  public override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : AnyObject]?) {
    super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    try! DIScopeMain.resolve(self)
  }
}
