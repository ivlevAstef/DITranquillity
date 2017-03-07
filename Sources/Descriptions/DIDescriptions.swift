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
    switch self {
    case .typeIsNotFound(let type):
      return "Type: \(type) not found\n"
    case .typeIsNotFoundForName(let type, let name, let typesInfo):
      return "Cannot found type: \(type) for name: \(name).\n\tUse:\n\(multiLine(typesInfo))\n"
    case .notSpecifiedInitializationMethodFor(let typeInfo):
      return "Not specified initial method for:\n \(typeInfo)\n"
    case .initializationMethodWithSignatureIsNotFoundFor(let typeInfo, let signature):
      return "Initial method with signature: \(signature) not found.\n\tUse: \(typeInfo)\n"
    case .pluralSpecifiedDefaultType(let type, let typesInfo):
      return "Plural specified default type for type: \(type).\n\tUse:\n\(multiLine(typesInfo))\n"
    case .defaultTypeIsNotSpecified(let type, let typesInfo):
      return "Default type not specified for type: \(type).\n\tUse:\n\(multiLine(typesInfo))\n"
    case .intersectionNamesForType(let type, let names, let typesInfo):
      return "Intersection names for type: \(type).\n\tIntersections: \(names)\n\tUse:\n\(multiLine(typesInfo))\n"
    case .typeIsIncorrect(let requestedType, let realType, let typeInfo):
      return "Incorrect type.\n\tRequested type: \(requestedType)\n\tReal type: \(realType)\n\tUse: \(typeInfo)\n"
    case .recursiveInitialization(let typeInfo):
      return "Recursive initialization into:\(typeInfo)\n"
    case .noAccess(let typesInfo, let modules):
      return "No access to \(typesInfo). This type can resolve from: \(modules)\n"
      
    case .build(let errors):
      return "\nList:\n\(multiLine(errors))\n"
    }
  }

  private func multiLine<T>(_ array: [T]) -> String {
    return array.map {
      return "\t\t\($0)"
    }.joined(separator: "\n")
  }
}
