//
//  Resolver+Sync.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30.11.2025.
//  Copyright © 2025 Alexander Ivlev. All rights reserved.
//

/// Async extension for Resolver
extension Resolver {
    func resolve<T>(type: T.Type = T.self, name: String? = nil, from framework: DIFramework.Type? = nil, arguments: AnyArguments? = nil) -> T {
        let pType = ParsedType(type: type)
        log(.verbose, msg: "Begin resolve \(description(type: pType))", brace: .begin)
        defer { log(.verbose, msg: "End resolve \(description(type: pType))", brace: .end) }

        let checkOnRoot = container.componentContainer.hasRootComponents
        return gmake(by: make(by: pType, stack: RAIIStack(), with: name, from: framework, use: nil, arguments: arguments, isRoot: checkOnRoot))
    }

    func injection<T>(obj: T, from framework: DIFramework.Type? = nil, arguments: AnyArguments? = nil) {
        log(.verbose, msg: "Begin injection in obj: \(obj)", brace: .begin)
        defer { log(.verbose, msg: "End injection in obj: \(obj)", brace: .end) }

        let checkOnRoot = container.componentContainer.hasRootComponents
        _ = make(by: ParsedType(obj: obj), stack: RAIIStack(), with: nil, from: framework, use: obj, arguments: arguments, isRoot: checkOnRoot)
    }

    func resolveCached(component: Component, arguments: AnyArguments? = nil) {
        log(.verbose, msg: "Begin resolve cached object by component: \(component.info)", brace: .begin)
        defer { log(.verbose, msg: "End resolve cached object by component: \(component.info)", brace: .end) }

        let checkOnRoot = container.componentContainer.hasRootComponents
        _ = makeObject(by: component, stack: RAIIStack(), use: nil, arguments: arguments, isRoot: checkOnRoot)
    }

    func resolve<T>(type: T.Type = T.self, component: Component, arguments: AnyArguments? = nil) -> T {
        let pType = ParsedType(type: type)
        log(.verbose, msg: "Begin resolve \(description(type: pType)) by component: \(component.info)", brace: .begin)
        defer { log(.verbose, msg: "End resolve \(description(type: pType)) by component: \(component.info)", brace: .end) }

        let checkOnRoot = container.componentContainer.hasRootComponents
        return gmake(by: makeObject(by: component, stack: RAIIStack(), use: nil, arguments: arguments, isRoot: checkOnRoot))
    }

    private func make(by parsedType: ParsedType,
                      stack: RAIIStack,
                      with name: String?,
                      from framework: DIFramework.Type?,
                      use object: Any?,
                      arguments: AnyArguments?,
                      isRoot: Bool) -> Any? {
        log(.verbose, msg: "Begin make \(description(type: parsedType))", brace: .begin)
        defer { log(.verbose, msg: "End make \(description(type: parsedType))", brace: .end) }

        let components = filterComponents(findComponents(by: parsedType, with: name, from: framework), by: parsedType, use: stack.data)
        if let delayMaker = makeDelayMakerIfCan(by: parsedType, stack: stack, components: components, use: object, arguments: arguments, isRoot: isRoot) {
            return delayMaker
        }

        return make(by: parsedType, stack: stack, components: components, use: object, arguments: arguments, isRoot: isRoot)
    }

    /// isMany for optimization
    internal func make(by parsedType: ParsedType,
                       stack: RAIIStack,
                       components: Components,
                       use object: Any?,
                       arguments: AnyArguments?,
                       isRoot: Bool) -> Any? {
        if parsedType.hasMany {
            assert(nil == object, "Many injection not supported")
            var result: [Any?] = []
            for component in components.sorted(by: { $0.order < $1.order }) {
                result.append(makeObject(by: component, stack: stack, use: nil, arguments: arguments, isRoot: isRoot))
            }

            return result
        }

        if let component = components.first, 1 == components.count {
            return makeObject(by: component, stack: stack, use: object, arguments: arguments, isRoot: isRoot)
        }

        if components.isEmpty {
            log(.info, msg: "Not found \(description(type: parsedType))")
        } else {
            let infos = components.map{ $0.info }
            log(.warning, msg: "Ambiguous \(description(type: parsedType)) contains in: \(infos)")
        }

        return nil
    }

    /// Super function
    private func makeObject(by component: Component, stack: RAIIStack, use usingObject: Any?, arguments: AnyArguments?, isRoot: Bool) -> Any? {
        log(.verbose, msg: "Found component: \(component.info)")

        if isRoot && !(component.isRoot || component.lifeTime == .single) {
            log(.error, msg: "Are you using root components, but a root component was found that was not marked as root: \(component.info)")
        }

        let uniqueKey = component.info

        func makeObject(scope: DIScope) -> Any? {
            var optCacheObject: Any? = scope.storage.fetch(key: uniqueKey)
            if let weakRef = optCacheObject as? WeakAny {
                optCacheObject = weakRef.value
            }

            if let cacheObject = getReallyObject(optCacheObject) {
                /// suspending ignore injection for new object
                guard let usingObject = usingObject else {
                    log(.verbose, msg: "Resolve object: \(cacheObject) use scope: \(scope.name)")
                    return cacheObject
                }

                /// suspending double injection
                if cacheObject as AnyObject === usingObject as AnyObject {
                    log(.verbose, msg: "Resolve object: \(cacheObject) use scope: \(scope.name)")
                    return cacheObject
                }
            }

            if let makedObject = makeObject() {
                let objectForSave = (.weak == scope.policy) ? WeakAny(value: makedObject) : makedObject
                scope.storage.save(object: objectForSave, by: uniqueKey)
                log(.verbose, msg: "Save object: \(makedObject) to scope \(scope.name)")
                return makedObject
            }

            return nil
        }

        var componentArguments: Arguments?
        func getArgumentObject(parameter: MethodSignature.Parameter) -> Any? {
            componentArguments = componentArguments ?? arguments?.getArguments(for: component)

            if componentArguments == nil {
                log(.error, msg: "Get arguments for \(component.info) failed. Please specify arguments or remove dublicates for this type")
                return nil
            }
            return componentArguments?.getArgument(for: parameter.parsedType.base.type)
        }

        func makeObject() -> Any? {
            guard let initializedObject = initialObject() else {
                return nil
            }

            for injection in component.injections {
                if injection.cycle {
                    cache.cycleInjectionQueue.append((initializedObject, injection.signature))
                } else {
                    _ = use(signature: injection.signature, usingObject: initializedObject)
                }
            }

            if let signature = component.postInit {
                if component.injections.contains(where: { $0.cycle }) {
                    cache.cycleInjectionQueue.append((initializedObject, signature))
                } else {
                    _ = use(signature: signature, usingObject: initializedObject)
                }
            }

            container.extensions.objectMaked?(uniqueKey, initializedObject)
            return initializedObject
        }

        func initialObject() -> Any? {
            if let obj = usingObject {
                log(.verbose, msg: "Use object: \(obj)")
                return obj
            }

            if let signature = component.initial {
                let obj = use(signature: signature, usingObject: nil)
                log(.verbose, msg: "Create object: \(String(describing: obj))")
                return obj
            }

            log(.warning, msg: "Can't found initial method in \(component.info)")
            return nil
        }

        func endResolving() {
            while !cache.cycleInjectionQueue.isEmpty {
                let data = cache.cycleInjectionQueue.removeFirst()
                _ = use(signature: data.signature, usingObject: data.obj)
            }
        }

        func use(signature: MethodSignature, usingObject: Any?) -> Any? {
            var objParameters = [Any?]()
            for parameter in signature.parameters {
                let makedObject: Any?
                if parameter.parsedType.useObject {
                    makedObject = usingObject
                } else if parameter.parsedType.arg {
                    makedObject = getArgumentObject(parameter: parameter)
                } else {
                    makedObject = make(by: parameter.parsedType,
                                       stack: stack,
                                       with: parameter.name,
                                       from: component.framework,
                                       use: nil,
                                       arguments: arguments,
                                       isRoot: false)
                }

                if nil != makedObject || parameter.parsedType.optional {
                    objParameters.append(makedObject)
                    continue
                }

                return nil
            }

            return signature.sCall(objParameters)
        }


        stack.data.push(component.info)
        // defer -> in function end

        func makeOrGetObject() -> Any? {
            switch component.lifeTime {
            case .single:
                return makeObject(scope: Cache.single)
            case .perRun(let referenceCounting):
                switch referenceCounting {
                case .weak: return makeObject(scope: Cache.weakPerRun)
                case .strong: return makeObject(scope: Cache.strongPerRun)
                }
            case .perContainer(let referenceCounting):
                switch referenceCounting {
                case .weak: return makeObject(scope: cache.weakPerContainer)
                case .strong: return makeObject(scope: cache.strongPerContainer)
                }
            case .objectGraph:
                return makeObject(scope: stack.data.graph)
            case .prototype:
                return makeObject()
            case .custom(let scope):
                return makeObject(scope: scope)
            }
        }

        let obj = makeOrGetObject()
        container.extensions.objectResolved?(uniqueKey, obj)

        // defer
        if stack.data.isLast() {
            endResolving()
        }
        stack.data.pop()

        return obj
    }
}
