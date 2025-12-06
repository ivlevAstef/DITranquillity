//
//  DIComponentBuilder+lifetime.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

// MARK: - contains `lifetime` and `default` functions
extension DIComponentBuilder {
    /// Function to set lifetime of an object.
    /// The lifetime of an object determines when it is created and destroyed.
    /// Using:
    /// ```
    /// container.register(YourClass.self)
    ///   .lifetime(.prototype)
    /// ```
    ///
    /// - Parameter lifetime: LifeTime. for more information seeing enum `DILifeTime`.
    /// - Returns: Self
    @discardableResult
    public func lifetime(_ lifetime: DILifeTime) -> Self {
        component.lifeTime = lifetime
        return self
    }
    
    /// Function declaring that this component will use the default.
    /// It's necessary to resolve uncertainties if several components are available on one type.
    /// Component declared as "default" will be given in the case if there were clarifications that you need.
    /// But the components belonging to the framework have higher priority than the default components from other frameworks.
    /// Using:
    /// ```
    /// container.register(YourClass.self)
    ///   .default()
    /// ```
    ///
    /// - Returns: Self
    @discardableResult
    public func `default`() -> Self {
        component.priority = .default
        return self
    }
    
    /// Function declaring that this component will use the default.
    /// It's necessary to resolve uncertainties if several components are available on one type.
    /// Component declared as "test" will be given in the case if there were clarifications that you need.
    /// But the components belonging to the framework have higher priority than the default components from other frameworks.
    /// Has the greatest power "default"
    /// Using:
    /// ```
    /// container.register(YourClass.self)
    ///   .test()
    /// ```
    ///
    /// - Returns: Self
    @discardableResult
    public func test() -> Self {
        component.priority = .test
        return self
    }
    
    /// Function declaring that this component is root.
    /// Root components using only into graph validation `container.makeGraph().checkIsValid()`.
    /// The root components accelerate graph validation, and allow you to check the graph more precisely.
    /// Singleton components always is root components `.lifetime(.single)`
    @discardableResult
    public func root() -> Self {
        component.isRoot = true
        return self
    }
    
    /// Function declaring that this component register but it may not be used.
    /// Actual only if you using `root components` system, because check graph found unused components and log warnings.
    @discardableResult
    public func unused() -> Self {
        component.unused = true
        return self
    }
}
