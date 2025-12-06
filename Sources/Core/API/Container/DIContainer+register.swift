//
//  DIContainer+register.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.

//

// MARK: - register
extension DIContainer {
    /// Registering a new component without initial.
    /// Using:
    /// ```
    /// container.register(YourClass.self)
    ///   . ...
    /// ```
    ///
    /// - Parameters:
    ///   - type: A type of new component.
    /// - Returns: component builder, to configure the component.
    @discardableResult
    public func register<Impl>(_ type: Impl.Type, file: String = #file, line: Int = #line) -> DIComponentBuilder<Impl> {
        return DIComponentBuilder(container: self, componentInfo: DIComponentInfo(type: Impl.self, file: file, line: line))
    }
    
    /// Declaring a new component with initial method.
    /// Using:
    /// ```
    /// container.register{ YourClass(p0:$0,p1:$1, ...) }
    /// ```
    /// or short:
    /// ```
    /// container.register(YourClass.init)
    /// ```
    ///
    /// - Parameter closure: initial method. Must return type declared at registration.
    /// - Returns: component builder, to configure the component.
    @discardableResult
    public func register<Impl,each P>(
        file: String = #file,
        line: Int = #line,
        _ closure: @escaping @isolated(any) (repeat each P) -> Impl
    ) -> DIComponentBuilder<Impl> {
        return register(file, line, MethodMaker.comboEachMake(sF: closure, aF: closure))
    }
    
    /// Declaring a new component with initial method.
    /// Using:
    /// ```
    /// container.register{ YourClass(p0:$0,p1:$1, ...) }
    /// ```
    /// or short:
    /// ```
    /// container.register(YourClass.init)
    /// ```
    ///
    /// - Parameter closure: initial method. Must return type declared at registration.
    /// - Returns: component builder, to configure the component.
    @discardableResult
    public func register<Impl,each P>(
        file: String = #file,
        line: Int = #line,
        _ closure: @escaping @isolated(any) (repeat each P) async -> Impl
    ) -> DIComponentBuilder<Impl> {
        return register(file, line, MethodMaker.asyncEachMake(by: closure))
    }
    
    
    /// Declaring a new component with initial and modificator one argument.
    /// Using:
    /// ```
    /// container.register(YourClass.init) { arg($0) }
    /// ```
    ///
    /// - Parameter closure: initial method. Must return type declared at registration.
    /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
    /// - Returns: component builder, to configure the component.
    @discardableResult
    public func register<Impl,P0,each P,M0>(file: String = #file, line: Int = #line,
                                            _ closure: @escaping @isolated(any) (P0, repeat each P) -> Impl,
                                            modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
        return register(file, line, MethodMaker.comboEachMake(sF: closure, aF: closure, modificator: modificator))
    }
    
    /// Declaring a new component with initial and modificator one argument.
    /// Using:
    /// ```
    /// container.register(YourClass.init) { (arg($0), many($1)) }
    /// ```
    ///
    /// - Parameter closure: initial method. Must return type declared at registration.
    /// - Parameter modificator: Need for support set arg / many / tag on first and second initial argument.
    /// - Returns: component builder, to configure the component.
    @discardableResult
    public func register<Impl,P0,P1,each P,M0,M1>(file: String = #file, line: Int = #line,
                                                  _ closure: @escaping @isolated(any) (P0, P1, repeat each P) -> Impl,
                                                  modificator: @escaping (M0, M1) -> (P0, P1)) -> DIComponentBuilder<Impl> {
        return register(file, line, MethodMaker.comboEachMake(sF: closure, aF: closure, modificator: modificator))
    }
    
    internal func register<Impl>(_ file: String, _ line: Int, _ signature: MethodSignature) -> DIComponentBuilder<Impl> {
        let builder = register(Impl.self, file: file, line: line)
        builder.component.set(initial: signature)
        return builder
    }
}
