//
//  SwiftNSResolver.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 26.04.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

@objc
internal final class SwiftNSResolver: _DINSResolver {
  internal override func inject(into object: Any) {
    resolver.injection(obj: object)
  }

  private let resolver: Resolver

  internal init(resolver: Resolver, on obj: AnyObject) {
    self.resolver = resolver
    super.init()

    setTo(obj)
  }
}
