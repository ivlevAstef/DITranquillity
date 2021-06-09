//
//  ExtensionsContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 17/08/2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

internal class ExtensionsContainer {
  private var extensionsByType: [DIComponentInfo: DIExtensions] = [:]
  private let mutex: PThreadMutex = PThreadMutex(recursive: ())

  internal func get(by type: DIComponentInfo) -> DIExtensions
  {
    return mutex.sync {
      if let extensions = extensionsByType[type] {
        return extensions
      }
      let extensions = DIExtensions()
      extensionsByType[type] = extensions
      return extensions
    }
  }

  internal func optionalGet(by type: DIComponentInfo) -> DIExtensions?
  {
    return mutex.sync {
      return extensionsByType[type]
    }
  }

}
