//
//  ParsedType.swift
//  DITranquillity
//
//  Created by Ивлев Александр on 06/12/2018.
//

indirect enum ParsedType {

  case simple(type: DIAType)
  case specific(type: SpecificType.Type, parent: ParsedType)

  var type: DIAType {
    switch self {
    case .simple(let type):
        return type
    case .specific(let type, _):
        return type
    }
  }

  var base: ParsedType {
    var iter = self
    while case .specific(_, let parent) = iter {
        iter = parent
    }
    return iter
  }

  var firstNotSwiftType: ParsedType {
    var iter = self
    while case .specific(let sType, let parent) = iter, sType.isSwiftType {
      iter = parent
    }
    return iter
  }

  var many: Bool { return sType?.many ?? false }
  var optional: Bool { return sType?.optional ?? false }
  var delayed: Bool { return sType?.delayed ?? false }
  var arg: Bool { return sType?.arg ?? false }

  var hasMany: Bool { return sType?.many ?? parent?.hasMany ?? false }
  var hasOptional: Bool { return sType?.optional ?? parent?.hasOptional ?? false }
  var hasDelayed: Bool { return sType?.delayed ?? parent?.hasDelayed ?? false }

  var delayMaker: SpecificType.Type? {
    var iter = self
    while case .specific(let sType, let parent) = iter {
      if sType.delayed {
        return sType
      }
      iter = parent
    }
    return nil
  }

  private var sType: SpecificType.Type? {
    if case .specific(let sType, _) = self {
        return sType
    }
    return nil
  }

  private var parent: ParsedType? {
    if case .specific(_, let parent) = self {
        return parent
    }
    return nil
  }

  init(type: DIAType) {
    if let sType = type as? SpecificType.Type {
        self = .specific(type: sType, parent: ParsedType(type: sType.type))
    } else {
        self = .simple(type: type)
    }
  }

  init(obj: Any) {
    // swift bug - if T is Any then type(of: obj) return always any. - compile optimization?
    self.init(type: Swift.type(of: (obj as Any)))
  }

}

extension ParsedType: Equatable {
  static func ==(_ lhs: ParsedType, _ rhs: ParsedType) -> Bool {
    switch (lhs, rhs) {
    case (.simple(let typeLeft), .simple(let typeRight)):
      return typeLeft == typeRight
    case (.specific(let typeLeft, _), .specific(let typeRight, _)):
      return typeLeft == typeRight
    default:
      return false
    }
  }
}
