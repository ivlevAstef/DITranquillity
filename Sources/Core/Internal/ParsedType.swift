//
//  ParsedType.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 06/12/2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

final class ParsedType: @unchecked Sendable {

    let type: DIAType

    let sType: SpecificType.Type?
    let parent: ParsedType?

    var base: ParsedType { _base ?? makeBase() }
    private unowned var _base: ParsedType? = nil
    private func makeBase() -> ParsedType {
        var iter = self
        while let parent = iter.parent {
            iter = parent
        }
        _base = iter
        return iter
    }

    var firstNotSwiftType: ParsedType { _firstNotSwiftType ?? makeFirstNotSwiftType() }
    private unowned var _firstNotSwiftType: ParsedType? = nil
    private func makeFirstNotSwiftType() -> ParsedType {
        var iter = self
        while let sType = iter.sType, let parent = iter.parent, sType.isSwiftType {
            iter = parent
        }
        _firstNotSwiftType = iter
        return iter
    }

    private(set) lazy var many: Bool = { sType?.many ?? false }()
    private(set) lazy var optional: Bool = {
        guard let sType else {
            return false
        }
        if sType.optional {
            return true
        }
        // `many` not need - because it's inner type
        if sType.asyncDelayed || sType.syncDelayed || sType.tag || sType.arg {
            return parent?.optional ?? false
        }
        return false
    }()
    private(set) lazy var asyncDelayed: Bool = { sType?.asyncDelayed ?? false }()
    private(set) lazy var syncDelayed: Bool = { sType?.syncDelayed ?? false }()
    private(set) lazy var arg: Bool = { sType?.arg ?? false }()

    private(set) lazy var useObject: Bool = { sType?.useObject ?? false }()

    private(set) lazy var delayMaker: (type: SpecificType.Type, sync: Bool)? = {
        var iter: ParsedType? = self
        while let sType = iter?.sType {
            if sType.syncDelayed || sType.asyncDelayed {
                return (sType, sType.syncDelayed)
            }
            iter = iter?.parent
        }
        return nil
    }()

    var hasMany: Bool { return oGet(sType?.many, parent?.hasMany) }
    var hasDelayed: Bool { return oGet(sType.map { $0.syncDelayed || $0.asyncDelayed }, parent?.hasDelayed) }

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

    func nextParsedTypeAfterManyOrBreakIfDelayed() -> ParsedType? {
        var pType: ParsedType = self
        repeat {
            if pType.syncDelayed || pType.asyncDelayed {
                return nil
            }
            if pType.many {
                return pType.parent
            }

            if let parentType = pType.parent {
                pType = parentType
                continue
            }
            break
        } while true

        return nil
    }

    private func oGet(_ value1: Bool?, _ value2: @autoclosure () -> Bool?) -> Bool {
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
