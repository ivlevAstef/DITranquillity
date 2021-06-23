//
//  AnyArguments.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09.06.2021.
//  Copyright © 2021 Alexander Ivlev. All rights reserved.
//

/// Stores information about arguments for any types.
/// Usage:
/// ```
/// var arguments = AnyArguments()
/// arguments.addArgs(for: T1.self, args: arg1, arg2)
/// arguments.addArgs(for: T2.self, args: arg3, arg4)
///
/// let obj: T = container.resolve(arguments: arguments)
/// assert(obj.t1.arg1 == arg1)
/// assert(obj.t1.arg2 == arg2)
/// assert(obj.t2.arg3 == arg3)
/// assert(obj.t2.arg4 == arg4)
/// ```
/// Also if need arguments in resolved type, your can use short syntax:
/// ```
/// let obj: T = container.resolve(args: arg1, arg2)
/// assert(obj.arg1 == arg1)
/// assert(obj.arg2 == arg2)
/// ```
public struct AnyArguments {
  private var typesWithArgs: [(type: ObjectIdentifier, args: Arguments)] = []

  /// empty initialization
  public init() { }

  /// If need inject arguments in one type, your can use this initialization
  public init(for type: DIAType, args: Any?...) {
    typesWithArgs.append((ObjectIdentifier(swiftType(type)), Arguments(args: args)))
  }

  internal init(for type: DIAType, argsArray: [Any?]) {
    typesWithArgs.append((ObjectIdentifier(swiftType(type)), Arguments(args: argsArray)))
  }

  /// add arguments for specified type.
  @discardableResult
  public mutating func addArgs(for type: DIAType, args: Any?...) -> Self {
    typesWithArgs.append((ObjectIdentifier(swiftType(type)), Arguments(args: args)))
    return self
  }

  internal func getArguments(for component: Component) -> Arguments? {
    let types = Set(([component.info.type] + component.alternativeTypes.map {
      switch $0 {
      case let .type(type),
           let .name(_, type),
           let .tag(_, type):
        return type
      }
    }).map { ObjectIdentifier($0) })

    let relevantTypesWithArgs = typesWithArgs.filter { types.contains($0.type) }
    if relevantTypesWithArgs.count != 1 {
      return nil
    }
    return relevantTypesWithArgs.first?.args
  }
}


internal struct Arguments {
  private var args: [Any?] = []

  internal init(args: [Any?]) {
    self.args = args
  }

  internal mutating func getArgument(for type: DIAType) -> Any? {
    if args.count > 0 {
      return args.removeFirst()
    }
    return nil
  }
}
