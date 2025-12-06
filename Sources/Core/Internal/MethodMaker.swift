//
//  MethodMaker.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 12/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

import Foundation

struct MethodMaker { }

// MARK: Async

extension MethodMaker {
    static func asyncEachMake<each P, R>(
        useObject: Bool = false,
        _ names: [String?]? = nil,
        by f: @escaping @isolated(any) (repeat each P) async -> R) -> MethodSignature
    {
        let types = EachTypes()
        repeat types.append((each P).self)
        if useObject {
            types.useObject()
        }

        let isolation = extractIsolation(f)
        return MethodSignature(types.result, names, isolation, { _ in
            fatalError("Unsupport use async method without isolation context")
        }, { params in
            let maker = EachMaker(params: params)
            return await f(repeat maker.make() as each P)
        })
    }
}

// MARK: Combo

extension MethodMaker {
    private static func mainIsolated<R>(closure: @escaping @MainActor () -> R) -> R {
        if Thread.isMainThread {
            return MainActor.assumeIsolated {
                return closure()
            }
        } else {
            let result: R = DispatchQueue.main.sync {
                MainActor.assumeIsolated {
                    closure()
                }
            }

            return result
        }
    }

    static func comboEachMake<each P, R>(
        useObject: Bool = false,
        _ names: [String?]? = nil,
        sF: @escaping (repeat each P) -> R,
        aF: @escaping @isolated(any) (repeat each P) -> R) -> MethodSignature
    {
        let types = EachTypes()
        repeat types.append((each P).self)
        if useObject {
            types.useObject()
        }

        let isolation = extractIsolation(aF)
        return MethodSignature(types.result, names, isolation, { params in
            let maker = EachMaker(params: params)
            if isolation === MainActor.shared {
                return mainIsolated {
                    return sF(repeat maker.make() as each P)
                }
            }
            return sF(repeat maker.make() as each P)
        }, { params in
            let maker = EachMaker(params: params)
            return await aF(repeat maker.make() as each P)
        })
    }

    static func comboEachMake<P0, each P, M0, R>(
        sF: @escaping (P0, repeat each P) -> R,
        aF: @escaping @isolated(any) (P0, repeat each P) -> R,
        modificator: @escaping (M0) -> P0) -> MethodSignature
    {
        let types = EachTypes()
        types.append(M0.self)
        repeat types.append((each P).self)

        let isolation = extractIsolation(aF)
        return MethodSignature(types.result, nil, isolation, { params in
            let maker = EachMaker(params: params)
            if isolation === MainActor.shared {
                return mainIsolated {
                    return sF(modificator(maker.make()), repeat maker.make() as each P)
                }
            }
            return sF(modificator(maker.make()), repeat maker.make() as each P)
        }, { params in
            let maker = EachMaker(params: params)
            return await aF(modificator(maker.make()), repeat maker.make() as each P)
        })
    }

    static func comboEachMake<P0, P1, each P, M0, M1, R>(
        sF: @escaping (P0, P1, repeat each P) -> R,
        aF: @escaping @isolated(any) (P0, P1, repeat each P) -> R,
        modificator: @escaping (M0, M1) -> (P0, P1)) -> MethodSignature
    {
        let types = EachTypes()
        types.append(M0.self)
        types.append(M1.self)
        repeat types.append((each P).self)

        let isolation = extractIsolation(aF)
        return MethodSignature(types.result, nil, isolation, { params in
            let maker = EachMaker(params: params)
            let modifyResult = modificator(maker.make(), maker.make())
            if isolation === MainActor.shared {
                return mainIsolated {
                    return sF(modifyResult.0, modifyResult.1, repeat maker.make() as each P)
                }
            }
            return sF(modifyResult.0, modifyResult.1, repeat maker.make() as each P)
        }, { params in
            let maker = EachMaker(params: params)
            let modifyResult = modificator(maker.make(), maker.make())
            return await aF(modifyResult.0, modifyResult.1, repeat maker.make() as each P)
        })
    }
}

private final class EachTypes {
    private(set) var result: [DIAType] = []

    func append<P>(_ type: P.Type) {
        result.append(P.self)
    }

    func useObject() {
        assert(!result.isEmpty, "Fail code logic - call use object with zero method parameters")
        result[0] = UseObject.self
    }
}

private final class EachMaker: @unchecked Sendable {
    private var index: Int = 0
    private let params: [Any?]

    init(params: [Any?]) {
        self.params = params
    }

    func make<P>() -> P {
        defer { index += 1 }
        return gmake(by: params[index])
    }
}
