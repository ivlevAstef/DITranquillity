//
//  Resolver.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30.11.2025.
//  Copyright © 2025 Alexander Ivlev. All rights reserved.
//

final class Resolver {
    unowned let container: DIContainer

    let cache = Cache()

    init(container: DIContainer) {
        self.container = container // unowned
    }

    /// Remove components who doesn't have initialization method
    ///
    /// - Parameter components: Components from which will be removed
    /// - Returns: components Having a initialization method
    func removeWhoDoesNotHaveInitialMethod(components: Components) -> Components {
        return Components(components.filter { nil != $0.initial })
    }

    /// Remove all cache objects in container
    func clean() {
        cache.containerStorage.clean()
    }

    /// Finds the most suitable components that satisfy the types.
    ///
    /// - Parameters:
    ///   - type: a type
    ///   - name: a name
    ///   - bundle: bundle from whic the call is made
    /// - Returns: components
    func findComponents(by parsedType: ParsedType, with name: String?, from framework: DIFramework.Type?) -> Components {
        let components = Resolver.findComponents(by: parsedType, with: name, from: framework, in: container)
        if let parent = container.parent {
            if components.isEmpty {
                return parent.resolver.findComponents(by: parsedType, with: name, from: framework)
            }

            if parsedType.hasMany
            {
                let parentComponents = parent.resolver.findComponents(by: parsedType, with: name, from: framework)
                return components + parentComponents
            }
        }
        return components
    }

    @inline(__always) func filterComponents(_ components: Components, by parsedType: ParsedType, use data: Data) -> Components {
        if !parsedType.hasMany {
            return components
        }
        // isManyRemove objects contains in stack for exclude cycle initialization
        var newComponents: Components = []
        for component in components {
            if !data.contains(component.info) {
                newComponents.append(component)
            }
        }
        return newComponents
    }

    private static func findComponents(by parsedType: ParsedType, with name: String?, from framework: DIFramework.Type?, in container: DIContainer) -> Components {
        func byPriority(_ priority: DIComponentPriority, _ components: Components, isEmpty: Bool = true) -> Components {
            let filtering = ContiguousArray(components.filter { $0.priority == priority })
            return filtering.isEmpty && isEmpty ? components : filtering
        }

        func filter(by framework: DIFramework.Type?, _ components: Components) -> Components {
            if components.count <= 1 {
                return components
            }

            /// check into self bundle
            if let framework = framework {
                /// get all components in bundle
                let filteredByFramework = ContiguousArray(components.filter{ $0.framework.map{ framework == $0 } ?? false })

                func componentsIsNeedReturn(_ components: Components) -> Components? {
                    let filtered = byPriority(.default, components)
                    return 1 == filtered.count ? filtered : nil
                }

                if let components = componentsIsNeedReturn(filteredByFramework) {
                    return components
                }

                /// get direct dependencies
                let filteredByChilds = container.frameworksDependencies.filterByChilds(for: framework, components: components)

                if let components = componentsIsNeedReturn(filteredByChilds) {
                    return components
                }
            }

            return byPriority(.default, components)
        }

        /// type without optional
        var type = parsedType.firstNotSwiftType
        /// real type without many, tags, optional
        let simpleType = parsedType.base
        var components = Set<Component>()
        var filterByFramework: Bool = true

        var first: Bool = true
        repeat {
            let currentComponents: Set<Component>
            if let sType = type.sType, let parent = type.parent {
                if sType.many {
                    currentComponents = container.componentContainer[ShortTypeKey(by: simpleType.type)]
                    filterByFramework = filterByFramework && sType.inFramework /// filter
                } else if sType.tag {
                    currentComponents = container.componentContainer[TypeKey(by: simpleType.type, tag: sType.tagType)]
                } else if sType.delayed {
                    // ignore - delayed type don't change components list
                    type = parent.firstNotSwiftType
                    continue
                } else {
                    currentComponents = container.componentContainer[TypeKey(by: simpleType.type)]
                }

                type = parent.firstNotSwiftType
            } else if let name = name {
                currentComponents = container.componentContainer[TypeKey(by: simpleType.type, name: name)]
            } else {
                currentComponents = container.componentContainer[TypeKey(by: simpleType.type)]
            }

            /// it's not equals components.isEmpty !!!
            components = first ? currentComponents : components.intersection(currentComponents)
            first = false

        } while type != simpleType || first /*check on first need only for delayed types*/

        let componentsArray = Components(components)
        if componentsArray.count > 1 {
            // If no found test components, then return 0, and continue without additional logic.
            let testComponents = byPriority(.test, componentsArray, isEmpty: false)
            if testComponents.count == 1 {
                return testComponents
            } else if testComponents.count > 1 {
                log(.error, msg: "Found more test components: \(testComponents.map { $0.info.description })")
            }
        }

        if filterByFramework {
            return filter(by: framework, componentsArray)
        }

        return componentsArray
    }
}

extension Resolver {
    final class RAIIStack: Sendable {
        let data: Data

        init() {
            data = Data()
        }

        init(restore: Data, graph: DIScope? = nil) {
            let graph = graph?.toStrongCopy() ?? restore.graph.toStrongCopy()
            self.data = Data(graph: graph, stack: restore.stack)
        }

        deinit {
            data.graph.toWeak() // Needs for delay maker - because DIScore is retained, but need objects removed if can
        }
    }

    final class Data: @unchecked Sendable {
        let graph: DIScope
        private(set) var stack: ContiguousArray<Component.UniqueKey>
        private let stackMonitor: FastLock = makeFastLock()

        init(graph: DIScope? = nil, stack: ContiguousArray<Component.UniqueKey> = []) {
            self.graph = graph ?? DIScope(name: "object graph", storage: DIUnsafeCacheStorage(), policy: .strong)
            self.stack = stack
        }

        func push(_ componentInfo: DIComponentInfo) {
            stackMonitor.lock()
            defer { stackMonitor.unlock() }
            stack.append(componentInfo)
        }

        func pop() {
            stackMonitor.lock()
            defer { stackMonitor.unlock() }
            stack.removeLast()
        }

        func contains(_ componentInfo: DIComponentInfo) -> Bool {
            stackMonitor.lock()
            defer { stackMonitor.unlock() }
            return stack.contains(componentInfo)
        }

        func isEmpty() -> Bool {
            stackMonitor.lock()
            defer { stackMonitor.unlock() }
            return stack.isEmpty
        }

        func isLast() -> Bool {
            stackMonitor.lock()
            defer { stackMonitor.unlock() }
            return stack.count == 1
        }
    }

    final class Cache {
        static let singleStorage = DICacheStorage()
        let containerStorage = DICacheStorage()

        static var single = DIScope(name: "single", storage: singleStorage, policy: .strong)
        static var weakPerRun = DIScope(name: "per run", storage: singleStorage, policy: .weak)
        static var strongPerRun = DIScope(name: "per run", storage: singleStorage, policy: .strong)
        lazy var weakPerContainer = DIScope(name: "per container", storage: containerStorage, policy: .weak)
        lazy var strongPerContainer = DIScope(name: "per container", storage: containerStorage, policy: .strong)

        var cycleInjectionQueue: ContiguousArray<(obj: Any?, signature: MethodSignature)> = []
    }
}
