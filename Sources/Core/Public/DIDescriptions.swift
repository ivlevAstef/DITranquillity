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
			return "\nType: \(type) not found\n"
		case .typeIsNotFoundForName(let type, let name, let typesInfo):
			return "\nCannot found type: \(type) for name: \(name).\n\tUse:\n\(multiLine(typesInfo))\n"
		case .notSpecifiedInitializationMethodFor(let typeInfo):
			return "\nNot specified initial method for:\n \(typeInfo)\n"
		case .initializationMethodWithSignatureIsNotFoundFor(let typeInfo, let signature):
			return "\nInitial method with signature: \(signature) not found.\n\tUse: \(typeInfo)\n"
		case .pluralSpecifiedDefaultType(let type, let typesInfo):
			return "\nPlural specified default type for type: \(type).\n\tUse:\n\(multiLine(typesInfo))\n"
		case .defaultTypeIsNotSpecified(let type, let typesInfo):
			return "\nDefault type not specified for type: \(type).\n\tUse:\n\(multiLine(typesInfo))\n"
		case .intersectionNamesForType(let type, let names, let typesInfo):
			return "\nIntersection names for type: \(type).\n\tIntersections: \(names)\n\tUse:\n\(multiLine(typesInfo))\n"
		case .typeIsIncorrect(let requestedType, let realType, let typeInfo):
			return "\nIncorrect type.\n\tRequested type: \(requestedType)\n\tReal type: \(realType)\n\tUse: \(typeInfo)\n"
		case .recursiveInitialization(let typeInfo):
			return "\nRecursive initialization into:\(typeInfo)\n"
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
