//
//  SpecificType.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 06/12/2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

protocol SpecificType {
    static var recursive: Bool { get }

    static var type: DIAType { get }
    static var tagType: DIAType { get }
    static var isSwiftType: Bool { get }

    static var many: Bool { get }
    static var optional: Bool { get }
    static var delayed: Bool { get }
    static var inFramework: Bool { get }

    static var tag: Bool { get }
    static var arg: Bool { get }

    static var useObject: Bool { get }

    static func make(by obj: Any?) -> Self

    init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) -> Any?)
}

extension SpecificType {
  static var recursive: Bool { return true }

  static var type: DIAType { return self }
  static var tagType: DIAType { return self }
  static var isSwiftType: Bool { return false }

  static var many: Bool { return false }
  static var optional: Bool { return false }
  static var delayed: Bool { return false }
  static var inFramework: Bool { return false }

  static var tag: Bool { return false }
  static var arg: Bool { return false }

  static var useObject: Bool { return false }

  static func make(by obj: Any?) -> Self { return obj as! Self }

  init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) -> Any?) {
    fatalError("Unsupport")
  }
}
