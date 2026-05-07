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
    static func asyncEachMake<each P, R: Sendable>(
        useObject: Bool = false,
        _ names: [String?]? = nil,
        fn: @escaping @Sendable @isolated(any) (repeat each P) async -> R) -> MethodSignature
    {
        let types = EachTypes()
        repeat types.append((each P).self)
        if useObject {
            types.useObject()
        }

        let isolation = fn.isolation
        return MethodSignature(types.result, names, isolation, { _ in
            fatalError("Unsupport use async method without isolation context")
        }, { params in
            let maker = EachMaker(params: params)
            return await fn(repeat maker.make() as each P)
        })
    }
}

// MARK: Combo

extension MethodMaker {
    private static func mainIsolated<R>(closure: @escaping @Sendable @MainActor () -> R) -> R {
        if Thread.isMainThread {
            nonisolated(unsafe) var result: R? = nil
            MainActor.assumeIsolated {
                result = closure()
            }
            return result!
        } else {
            nonisolated(unsafe) var result: R? = nil
            DispatchQueue.main.sync {
                MainActor.assumeIsolated {
                    result = closure()
                }
            }

            return result!
        }
    }

    static func comboEachMake<each P, R>(
        useObject: Bool = false,
        _ names: [String?]? = nil,
        fn: @escaping (repeat each P) -> R) -> MethodSignature
    {
        let types = EachTypes()
        repeat types.append((each P).self)
        if useObject {
            types.useObject()
        }

        return MethodSignature(types.result, names, nil, { params in
            let maker = EachMaker(params: params)
            return fn(repeat maker.make() as each P)
        }, { params in
            let maker = EachMaker(params: params)
            return fn(repeat maker.make() as each P)
        })
    }

    static func comboMainEachMake<each P, R: Sendable>(
        useObject: Bool = false,
        _ names: [String?]? = nil,
        fn: @escaping @Sendable @MainActor (repeat each P) -> R) -> MethodSignature
    {
        let types = EachTypes()
        repeat types.append((each P).self)
        if useObject {
            types.useObject()
        }

        return MethodSignature(types.result, names, nil, { params in
            let maker = EachMaker(params: params)
            return mainIsolated {
                return fn(repeat maker.make() as each P)
            }
        }, { params in
            let maker = EachMaker(params: params)
            return await fn(repeat maker.make() as each P)
        })
    }

    @available(tvOS 17.0, watchOS 10.0, macOS 14.0, iOS 17.0, *)
    private struct IsoWrapper<each P, R> {
        let fn: @isolated(any) @Sendable (repeat each P) -> R
    }
    @available(tvOS 17.0, watchOS 10.0, macOS 14.0, iOS 17.0, *)
    private struct NoIsoWrapper<each P, R> {
        let fn: @Sendable (repeat each P) -> R
    }

    @available(tvOS 17.0, watchOS 10.0, macOS 14.0, iOS 17.0, *)
    static func comboEachMake<each P, R: Sendable>(
        useObject: Bool = false,
        _ names: [String?]? = nil,
        fn: @escaping @isolated(any) @Sendable (repeat each P) -> R) -> MethodSignature
    {
        typealias IsoWrap = IsoWrapper<repeat each P, R>
        typealias NoIsoWrap = NoIsoWrapper<repeat each P, R>
        assert(MemoryLayout<IsoWrap>.size == MemoryLayout<NoIsoWrap>.size)
        let sF = unsafeBitCast(IsoWrap(fn: fn), to: NoIsoWrap.self).fn

        let types = EachTypes()
        repeat types.append((each P).self)
        if useObject {
            types.useObject()
        }

        let isolation = fn.isolation
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
            return await fn(repeat maker.make() as each P)
        })
    }

    static func comboEachMake<P0, each P, M0, R>(
        fn: @escaping (P0, repeat each P) -> R,
        modificator: @escaping (M0) -> P0) -> MethodSignature
    {
        let types = EachTypes()
        types.append(M0.self)
        repeat types.append((each P).self)

        return MethodSignature(types.result, nil, nil, { params in
            let maker = EachMaker(params: params)
            return fn(modificator(maker.make()), repeat maker.make() as each P)
        }, { params in
            let maker = EachMaker(params: params)
            return fn(modificator(maker.make()), repeat maker.make() as each P)
        })
    }

    @available(tvOS 17.0, watchOS 10.0, macOS 14.0, iOS 17.0, *)
    private struct IsoWrapperM0<P0, each P, R> {
        let fn: @isolated(any) @Sendable (P0, repeat each P) -> R
    }
    @available(tvOS 17.0, watchOS 10.0, macOS 14.0, iOS 17.0, *)
    private struct NoIsoWrapperM0<P0, each P, R> {
        let fn: @Sendable (P0, repeat each P) -> R
    }

    @available(tvOS 17.0, watchOS 10.0, macOS 14.0, iOS 17.0, *)
    static func comboEachMake<P0, each P, M0, R: Sendable>(
        fn: @escaping @isolated(any) @Sendable (P0, repeat each P) -> R,
        modificator: @escaping @Sendable (M0) -> P0) -> MethodSignature
    {
        typealias IsoWrap = IsoWrapperM0<P0, repeat each P, R>
        typealias NoIsoWrap = NoIsoWrapperM0<P0, repeat each P, R>
        assert(MemoryLayout<IsoWrap>.size == MemoryLayout<NoIsoWrap>.size)
        let sF = unsafeBitCast(IsoWrap(fn: fn), to: NoIsoWrap.self).fn

        let types = EachTypes()
        types.append(M0.self)
        repeat types.append((each P).self)

        let isolation = fn.isolation
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
            return await fn(modificator(maker.make()), repeat maker.make() as each P)
        })
    }

    static func comboEachMake<P0, P1, each P, M0, M1, R>(
        fn: @escaping (P0, P1, repeat each P) -> R,
        modificator: @escaping (M0, M1) -> (P0, P1)) -> MethodSignature
    {
        let types = EachTypes()
        types.append(M0.self)
        types.append(M1.self)
        repeat types.append((each P).self)

        return MethodSignature(types.result, nil, nil, { params in
            let maker = EachMaker(params: params)
            let modifyResult = modificator(maker.make(), maker.make())
            return fn(modifyResult.0, modifyResult.1, repeat maker.make() as each P)
        }, { params in
            let maker = EachMaker(params: params)
            let modifyResult = modificator(maker.make(), maker.make())
            return fn(modifyResult.0, modifyResult.1, repeat maker.make() as each P)
        })
    }

    @available(tvOS 17.0, watchOS 10.0, macOS 14.0, iOS 17.0, *)
    private struct IsoWrapperM1<P0, P1, each P, R> {
        let fn: @isolated(any) @Sendable (P0, P1, repeat each P) -> R
    }
    @available(tvOS 17.0, watchOS 10.0, macOS 14.0, iOS 17.0, *)
    private struct NoIsoWrapperM1<P0, P1, each P, R> {
        let fn: @Sendable (P0, P1, repeat each P) -> R
    }

    @available(tvOS 17.0, watchOS 10.0, macOS 14.0, iOS 17.0, *)
    static func comboEachMake<P0, P1, each P, M0, M1, R: Sendable>(
        fn: @escaping @isolated(any) @Sendable (P0, P1, repeat each P) -> R,
        modificator: @escaping @Sendable (M0, M1) -> (P0, P1)) -> MethodSignature
    {
        typealias IsoWrap = IsoWrapperM1<P0, P1, repeat each P, R>
        typealias NoIsoWrap = NoIsoWrapperM1<P0, P1, repeat each P, R>
        assert(MemoryLayout<IsoWrap>.size == MemoryLayout<NoIsoWrap>.size)
        let sF = unsafeBitCast(IsoWrap(fn: fn), to: NoIsoWrap.self).fn

        let types = EachTypes()
        types.append(M0.self)
        types.append(M1.self)
        repeat types.append((each P).self)

        let isolation = fn.isolation
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
            return await fn(modifyResult.0, modifyResult.1, repeat maker.make() as each P)
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
