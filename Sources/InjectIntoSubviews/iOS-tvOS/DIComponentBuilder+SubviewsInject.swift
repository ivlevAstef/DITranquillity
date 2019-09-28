//
//  DIComponentBuilder+SubviewsInject.swift
//  DITranquillity
//
//  Created by Nikita Patskov on 23.04.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

import UIKit

extension DIComponentBuilder where Impl: UIViewController {
  internal func useInjectIntoSubviewComponent() {
    if DISetting.Defaults.injectToSubviews {
      autoInjectToSubviews()
    }
  }

  /// Function allows injection inside UIViewController view and its subviews.
  /// Setted to *false* by default cause optimization purposes.
  /// If you want enable injection into ViewController views, UITableViewCells and UICollectionViewCells, set this property to *true*.
  ///
  /// - Returns: Self
  @discardableResult
  public func autoInjectToSubviews() -> Self {
    injection { [resolver] vc in
      _ = SwiftNSResolver(resolver: resolver, on: vc)
    }

    return self
  }
}

extension DIComponentBuilder where Impl: UIView {
  internal func useInjectIntoSubviewComponent() {
    if DISetting.Defaults.injectToSubviews {
      autoInjectToSubviews()
    }
  }

  /// Function allows injection inside UIView and its subviews.
  /// Setted to *false* by default cause optimization purposes.
  /// If you want enable injection into views, UITableViewCells and UICollectionViewCells, set this property to *true*.
  ///
  /// - Returns: Self
  @discardableResult
  public func autoInjectToSubviews() -> Self {
    injection { [resolver] vc in
      _ = SwiftNSResolver(resolver: resolver, on: vc)
    }

    return self
  }
}

