//
//  DIComponentBuilder+as.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//


// MARK: - contains `as` functions
extension DIComponentBuilder {
  /// Function allows you to specify a type by which the component will be available.
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .as(YourProtocol.self)
  /// ```
  ///
  /// - Parameter type: Type by which the component will be available.
  /// - Returns: Self
  @discardableResult
  public func `as`<Parent>(_ type: Parent.Type) -> Self {
    componentContainer.insert(TypeKey(by: unwrapType(type)), component, otherOperation: {
      self.component.alternativeTypes.append(.type(type))
    })
    return self
  }

  /// Function allows you to specify a type with tag by which the component will be available.
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .as(YourProtocol.self, tag: YourTag.self)
  /// ```
  ///
  /// - Parameters:
  ///   - type: Type by which the component will be available paired with tag.
  ///   - tag: Tag by which the component will be available paired with type.
  /// - Returns: Self
  @discardableResult
  public func `as`<Parent, Tag>(_ type: Parent.Type, tag: Tag.Type) -> Self {
    componentContainer.insert(TypeKey(by: unwrapType(type), tag: tag), component, otherOperation: {
      self.component.alternativeTypes.append(.tag(tag, type: type))
    })
    return self
  }

  /// Function allows you to specify a type with name by which the component will be available.
  /// But! you can get an object by name in only two ways: use container method `resolve(name:)` or use `injection(name:)`.
  /// Inside initialization method, you cann't specify name for get an object. Use tags if necessary.
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .as(YourProtocol.self, name: "YourKey")
  /// ```
  ///
  /// - Parameters:
  ///   - type: Type by which the component will be available paired with name.
  ///   - name: Name by which the component will be available paired with type.
  /// - Returns: Self
  @discardableResult
  public func `as`<Parent>(_ type: Parent.Type, name: String) -> Self {
    componentContainer.insert(TypeKey(by: unwrapType(type), name: name), component, otherOperation: {
      self.component.alternativeTypes.append(.name(name, type: type))
    })
    return self
  }

  /// Function allows you to specify a type with tag by which the component will be available.
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .as(check: YourProtocol.self){$0}
  /// ```
  /// WHERE YourClass implements YourProtocol
  ///
  /// - Parameters:
  ///   - type: Type by which the component will be available paired with tag.
  ///   - validator: Validate type function. Always use `{$0}` for type validation.
  /// - Returns: Self
  @discardableResult
  public func `as`<Parent>(check type: Parent.Type, _ validator: (Impl)->Parent) -> Self {
    return self.as(type)
  }

  /// Function allows you to specify a type with tag by which the component will be available.
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .as(check: YourProtocol.self, tag: YourTag.self){$0}
  /// ```
  /// WHERE YourClass implements YourProtocol
  ///
  /// - Parameters:
  ///   - type: Type by which the component will be available paired with tag.
  ///   - tag: Tag by which the component will be available paired with type.
  ///   - validator: Validate type function. Always use `{$0}` for type validation.
  /// - Returns: Self
  @discardableResult
  public func `as`<Parent, Tag>(check type: Parent.Type, tag: Tag.Type, _ validator: (Impl)->Parent) -> Self {
    return self.as(type, tag: tag)
  }

  /// Function allows you to specify a type with name by which the component will be available.
  /// But! you can get an object by name in only two ways: use container method `resolve(name:)` or use `injection(name:)`.
  /// Inside initialization method, you cann't specify name for get an object. Use tags if necessary.
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .as(YourProtocol.self, name: "YourKey")
  /// ```
  /// WHERE YourClass implements YourProtocol
  ///
  /// - Parameters:
  ///   - type: Type by which the component will be available paired with name.
  ///   - name: Name by which the component will be available paired with type.
  ///   - validator: Validate type function. Always use `{$0}` for type validation.
  /// - Returns: Self
  @discardableResult
  public func `as`<Parent>(check type: Parent.Type, name: String, _ validator: (Impl)->Parent) -> Self {
    return self.as(type, name: name)
  }
}
