//
//  DIComponentBuilder.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

/// Builder class for configuring registered components.
///
/// `DIComponentBuilder` provides a fluent interface for configuring component properties
/// such as lifetime, alternative types, injections, and more. Instances are created by
/// calling `register(_:)` on a `DIContainer`.
///
/// ## Overview
///
/// The builder supports the following configuration methods:
/// - **Type Registration**: `as(_:)`, `as(_:tag:)`, `as(_:name:)` - register alternative types
/// - **Injections**: `injection(_:)`, `injection(keyPath:)` - configure property injection
/// - **Lifetime**: `lifetime(_:)` - set object lifecycle
/// - **Priority**: `default()`, `test()` - set resolution priority
/// - **Metadata**: `root()`, `unused()` - set graph validation hints
///
/// ## Important
///
/// **Do not retain instances of this class.** Component registration happens automatically
/// when the builder is deallocated (`deinit`). The typical usage pattern is method chaining:
///
/// ```swift
/// container.register(MyService.init)
///     .as(ServiceProtocol.self)
///     .injection(\.logger)
///     .lifetime(.single)
/// // Registration occurs here when the builder goes out of scope
/// ```
///
/// ## Example
///
/// ```swift
/// // Complete registration example
/// container.register { MyService(database: $0) }
///     .as(ServiceProtocol.self)
///     .as(ServiceProtocol.self, tag: Primary.self)
///     .injection(\.logger)
///     .injection { $0.configure(with: $1) }
///     .postInit { $0.start() }
///     .lifetime(.perContainer(.strong))
///     .default()
/// ```
public final class DIComponentBuilder<Impl> {
    private weak var extensions: DIExtensions?

    init(container: DIContainer, componentInfo: DIComponentInfo) {
        self.extensions = container.extensions
        self.component = Component(componentInfo: componentInfo,
                                   in: container.frameworkStack.last, container.partStack.last)
        self.componentContainer = container.componentContainer
        self.resolver = container.resolver
    }

    deinit {
        log(.verbose, msgc: {
            var msg = "\(component.priority) "
            msg += "registration: \(component.info)\n"
            msg += "\(DISetting.Log.tab)initial: \(nil != component.initial)\n"
            msg += "\(DISetting.Log.tab)lifetime: \(component.lifeTime)\n"
            msg += "\(DISetting.Log.tab)injections: \(component.injections.count)\n"
            return msg
        })

        extensions?.componentRegistration?(DIComponentVertex(component: component))
        componentContainer.insert(TypeKey(by: unwrapType(Impl.self)), component)
    }

    let component: Component
    let componentContainer: ComponentContainer
    let resolver: Resolver
}
