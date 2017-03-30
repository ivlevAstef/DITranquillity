//
//  DIDescriptions.swift
//  DITranquillity
//
//  Created by Ивлев А.Е. on 09.02.17.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

import Foundation

extension DITypeInfo: CustomStringConvertible {
  public var description: String {
    return "Register type: \(type) in file: \((file as NSString).lastPathComponent) on line: \(line)"
  }
}

extension DIError: CustomStringConvertible {
  public var description: String {
    #if ENABLE_DI_MODULE /// :( into switch if not work
      if case .noAccess(let typesInfo, let modules) = self {
        return "No access to \(typesInfo). This type can resolve from: \(modules)\n"
      }
    #endif

    if case .build(let errors) = self {
      return "\nList:\n\(multiLine(errors))\n"
    }

    switch self {
    /// Until Resolve
    case .typeNotFound(let type):
      return "Cannot found type: \(type)\n"
    case .typeForNameNotFound(let type, let name, let typesInfo):
      return "Cannot found type: \(type) for name: \(name).\n\tUse:\n\(multiLine(typesInfo))\n"
    case .initialMethodNotFound(let typeInfo, let signature):
      return "Cannot found initial method with signature: \(signature).\n\tUse: \(typeInfo)\n"
    case .ambiguousType(let type, let typesInfo):
      return "Ambiguous type: \(type).\n\tUse:\n\(multiLine(typesInfo))\n"
    case .incorrectType(let requestedType, let realType, let typeInfo):
      return "Incorrect type: \(realType) for requested type: \(requestedType)\n\tUse: \(typeInfo)\n"
    case .recursiveInitial(let typeInfo):
      return "Recursive initialize into type info: \(typeInfo)\n"

    /// Until Build
    case .noSpecifiedInitialMethod(let typeInfo):
      return "Not specified initial method for type info: \(typeInfo)\n"
    case .intersectionNames(let type, let names, let typesInfo):
      return "Intersection names for type: \(type).\n\tIntersections: \(names)\n\tUse:\n\(multiLine(typesInfo))\n"
    case .pluralDefaultAd(let type, let typesInfo):
      return "Plural default ad for type: \(type).\n\tUse:\n\(multiLine(typesInfo))\n"
    case .noAccess(let typesInfo, let modules):
      return "No access to \(typesInfo). This type can resolve from: \(modules)\n"

    default:
      fatalError("Not fully implemented DIError.description")
    }
  }

  private func multiLine<T>(_ array: [T]) -> String {
    return array.map {
      return "\t\t\($0)"
    }.joined(separator: "\n")
  }
}
