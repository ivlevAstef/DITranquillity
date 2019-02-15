//
//  ParsedType.swift
//  DITranquillity
//
//  Created by Ивлев Александр on 06/12/2018.
//

final class ParsedType {

  let type: DIAType

  let sType: SpecificType.Type?
  let parent: ParsedType?

  var base: ParsedType {
    var iter = self
    while let parent = iter.parent {
        iter = parent
    }
    return iter
  }

  var firstNotSwiftType: ParsedType {
    var iter = self
    while let sType = iter.sType, let parent = iter.parent, sType.isSwiftType {
      iter = parent
    }
    return iter
  }

  var many: Bool { return sType?.many ?? false }
  var optional: Bool { return sType?.optional ?? false }
  var delayed: Bool { return sType?.delayed ?? false }
  var arg: Bool { return sType?.arg ?? false }

  var useObject: Bool { return sType?.useObject ?? false }

  var hasMany: Bool { return oGet(sType?.many, parent?.hasMany) }
  var hasOptional: Bool { return oGet(sType?.optional, parent?.hasOptional) }
  var hasDelayed: Bool { return oGet(sType?.delayed, parent?.hasDelayed) }

  var delayMaker: SpecificType.Type? {
    var iter: ParsedType? = self
    while let sType = iter?.sType {
      if sType.delayed {
        return sType
      }
      iter = iter?.parent
    }
    return nil
  }

  init(type: DIAType) {
    self.type = type
    if let sType = type as? SpecificType.Type {
      self.sType = sType
      self.parent = sType.recursive ? ParsedType(type: sType.type) : nil
    } else {
      self.sType = nil
      self.parent = nil
    }
  }

  convenience init(obj: Any) {
    // swift bug - if T is Any then type(of: obj) return always any. - compile optimization?
    self.init(type: Swift.type(of: (obj as Any)))
  }

  @inline(__always)
  private func oGet(_ value1: Bool?, _ value2: @autoclosure () -> Bool?) -> Bool
  {
    if true == value1 {
        return true
    }
    return value2() ?? false
  }

}

extension ParsedType: Equatable {
  static func ==(_ lhs: ParsedType, _ rhs: ParsedType) -> Bool {
    return lhs.type == rhs.type
  }
}
