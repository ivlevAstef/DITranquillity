//
//  DIComponentBuilder+SubviewsInject.swift
//  DITranquillity
//
//  Created by Nikita on 23.04.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

// MARK: - contains autoInjectToSubviews for UIViewController function
extension DIComponentBuilder where Impl: UIViewController {
  
  /// Function allows injection inside UIViewController view and its subviews.
  /// Setted to *false* by default cause optimization purposes.
  /// If you want enable injection into ViewController views (e.g. UITableViewCells and UICollectionViewCells), set this property to *true*.
  ///
  /// - Returns: Self
  @discardableResult
  public func autoInjectToSubviews() -> Self {
    component.injectToSubviews = true
    return self
  }
}
