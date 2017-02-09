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
		return "<Registeration type: \(type) in file: \((file as NSString).lastPathComponent), line: \(line)>"
	}
}

extension DIError: CustomStringConvertible {
	public var description: String {
		switch self {
		case .typeIsNotFound(let type):
			return "Error: type: \(type) not found"
		case .typeIsNotFoundForName(let type, let name, let typesInfo):
			return "Error: cannot found type: \(type) for name: \(name).\n\tUse:\n\(multiLine(typesInfo))"
		case .notSpecifiedInitializationMethodFor(let typeInfo):
			return "Error: not specified initial method for:\n \(typeInfo)"
		case .initializationMethodWithSignatureIsNotFoundFor(let typeInfo, let signature):
			return "Error: initial method with signature: \(signature) not found.\n\tUse: \(typeInfo)"
		case .pluralSpecifiedDefaultType(let type, let typesInfo):
			return "Error: plural specified default type for type: \(type).\n\tUse:\n\(multiLine(typesInfo))"
		case .defaultTypeIsNotSpecified(let type, let typesInfo):
			return "Error: default type not specified for type: \(type).\n\tUse:\n\(multiLine(typesInfo))"
		case .intersectionNamesForType(let type, let names, let typesInfo):
			return "Error: intersection names for type: \(type).\n\tIntersections: \(names)\n\tUse:\n\(multiLine(typesInfo))"
		case .typeIsIncorrect(let requestedType, let realType, let typeInfo):
			return "Error: incorrect type.\n\tRequested type: \(requestedType)\n\tReal type: \(realType)\n\tUse: \(typeInfo)"
		case .recursiveInitialization(let typeInfo):
			return "Error: recursive initialization into:\(typeInfo)"
		case .build(let errors):
			return "Build errors:\n\(multiLine(errors))"
		}
	}

	private func multiLine<T>(_ array: [T]) -> String {
		return array.map {
			return "\t\t\($0)"
		}.joined(separator: "\n")
	}
}
