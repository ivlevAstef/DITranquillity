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

extension DIResolveStyle: CustomStringConvertible {
  public var description: String {
    switch self {
    case .one:
      return "resolve one"
    case .many:
      return "resolve many"
    case .byName(let name):
      return "resolve by name: \(name)"
    }
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
		case .build(let errors):
			return "\nList:\n\(multiLine(errors))\n"
    case .stack(let type, let child, let resolveStyle):
      if case .stack(_,_,_) = child {
        return "\(child)\t\(type) use \(resolveStyle)\n"
      }
      return "\(child)Stack:\n\t\(type) use \(resolveStyle)\n"
    case .byCall(let file, let line, let function, let stack):
      return "\nBy call function: \(function) in file: \((file as NSString).lastPathComponent) on line: \(line).\nDescription: \(stack)"
    case .whileCreateSingleton(let typeInfo, let stack):
      return "\nWhile create singleton for \(typeInfo)\n\(stack)\n"
		}
	}

	private func multiLine<T>(_ array: [T]) -> String {
		return array.map {
			return "\t\t\($0)"
		}.joined(separator: "\n")
	}
}
